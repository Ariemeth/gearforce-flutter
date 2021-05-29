package main

import (
	"context"
	"crypto/tls"
	"embed"
	"errors"
	"flag"
	"fmt"
	"io/fs"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"

	"golang.org/x/crypto/acme/autocert"
)

const (
	flagUseLocal = "local"
	flagPort     = "port"
	flagHostURL  = "host"
	flagIsDev    = "isDev"
	envUseLocal  = "USE_LOCAL"
	envPort      = "HOST_PORT"
	envHostURL   = "HOST_URL"
	envIsDEV     = "IS_DEV"

	webPath     = "build/web"
	storagePath = "shared"

	defaultPort  = 80
	defaultLocal = false
	defaultIsDev = false
	defaultHost  = ""
)

//go:embed build/web
var embeddedWeb embed.FS

type config struct {
	port     int
	host     string
	useLocal bool
	isDev    bool
}

func main() {

	config := getConfig()

	if _, err := os.Stat(storagePath); errors.Is(err, os.ErrNotExist) {
		log.Printf("Storage path [%s] not found", storagePath)
	} else {
		log.Printf("Storage path [%s] found", storagePath)
	}

	handler := logWrapper(http.FileServer(getFileSystem(config.useLocal, webPath)))

	var m *autocert.Manager

	if !config.isDev {
		if err := runProdServer(m, handler, config.port, config.host, storagePath); err != nil {
			log.Fatalf("Shutting down, unable to start secure server: %v", err)
		}
	}

	var httpSrv *http.Server
	if !config.isDev {
		httpSrv = makeHTTPToHTTPSRedirectServer()
	} else {
		httpSrv = makeHTTPServer(handler)
	}

	if m != nil {
		httpSrv.Handler = m.HTTPHandler(httpSrv.Handler)
	}

	httpSrv.Addr = fmt.Sprintf(":%d", config.port)
	log.Printf("Starting HTTP server on %s\n", httpSrv.Addr)
	err := httpSrv.ListenAndServe()

	log.Printf("Server shutdown, reason: %v", err)
}

func runProdServer(m *autocert.Manager, h http.Handler, port int, allowedHost, dataDir string) error {
	hostPolicy := func(ctx context.Context, host string) error {
		if host == allowedHost {
			return nil
		}
		return fmt.Errorf("acme/autocert: only %s host is allowed", allowedHost)
	}
	m = &autocert.Manager{
		Prompt:     autocert.AcceptTOS,
		HostPolicy: hostPolicy,
		Cache:      autocert.DirCache(dataDir),
	}

	httpsSrv := makeHTTPServer(h)
	httpsSrv.Addr = ":443"
	httpsSrv.TLSConfig = &tls.Config{GetCertificate: m.GetCertificate}

	go func() {
		log.Printf("Starting HTTPS server on %s", httpsSrv.Addr)
		err := httpsSrv.ListenAndServeTLS("", "")
		if err != nil {
			log.Fatalf("httpsSrv.ListendAndServeTLS() failed with %s", err)
		}
	}()

	return nil
}

func getConfig() config {
	c := config{
		port:     defaultPort,
		host:     defaultHost,
		useLocal: defaultLocal,
		isDev:    defaultIsDev,
	}

	// check for environment configs, ignore errors at this point
	if port, exists := os.LookupEnv(envPort); exists {
		c.port, _ = strconv.Atoi(port)
	}
	if host, exists := os.LookupEnv(envHostURL); exists {
		c.host = host
	}
	if _, exists := os.LookupEnv(envUseLocal); exists {
		c.useLocal = true
	}
	if _, exists := os.LookupEnv(envIsDEV); exists {
		c.isDev = true
	}

	flag.IntVar(&c.port, flagPort, c.port, "port to host the site")
	flag.BoolVar(&c.useLocal, flagUseLocal, c.useLocal, "true to use the local file system instead of the embedded files")
	flag.StringVar(&c.host, flagHostURL, c.host, "host address to use when acquiring a certificate")
	flag.BoolVar(&c.isDev, flagIsDev, c.isDev, "run in production mode, this will require a host url")

	flag.Parse()

	log.Printf("-%s or %s: %d", flagPort, envPort, c.port)
	log.Printf("-%s or %s: %t", flagUseLocal, envUseLocal, c.useLocal)
	log.Printf("-%s or %s: %s", flagHostURL, envHostURL, c.host)
	log.Printf("-%s or %s: %t", flagIsDev, envIsDEV, c.isDev)

	if !c.isDev && c.host == "" {
		log.Fatal("Cannot run in production mode without a host url")
	}

	return c
}

// logWrapper wraps the http handler from the FileServer to log information
// about the request.
func logWrapper(h http.Handler) http.Handler {

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s requested %s", getIP(r), r.URL.Path)
		h.ServeHTTP(w, r)
	})
}

// getIP returns the IP address of the http.Request. If the request has a
// X-FORWARDED-FOR header that value is used over the RemoteAddr.
func getIP(r *http.Request) string {
	// check if the IP was forwarded
	if f := r.Header.Get("X-FORWARDED-FOR"); f != "" {
		return f
	}
	return r.RemoteAddr
}

// getFileSystem returns the a FileSystem to use, either the embedded
// filesystem or the local FileSystem.
func getFileSystem(useLocal bool, path string) http.FileSystem {
	if useLocal {
		log.Println("using local file system")
		return http.FS(os.DirFS(path))
	}

	log.Println("using embedded file system")
	fsys, err := fs.Sub(embeddedWeb, path)
	if err != nil {
		panic(err)
	}
	return http.FS(fsys)
}

func makeServerFromMux(mux *http.ServeMux) *http.Server {
	// set timeouts so that a slow or malicious client doesn't
	// hold resources forever
	return &http.Server{
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 5 * time.Second,
		IdleTimeout:  120 * time.Second,
		Handler:      mux,
	}
}

func makeHTTPServer(h http.Handler) *http.Server {
	mux := &http.ServeMux{}
	mux.HandleFunc("/", h.ServeHTTP)
	return makeServerFromMux(mux)

}

func makeHTTPToHTTPSRedirectServer() *http.Server {
	handleRedirect := func(w http.ResponseWriter, r *http.Request) {
		newURI := "https://" + r.Host + r.URL.String()
		http.Redirect(w, r, newURI, http.StatusFound)
	}
	mux := &http.ServeMux{}
	mux.HandleFunc("/", handleRedirect)
	return makeServerFromMux(mux)
}
