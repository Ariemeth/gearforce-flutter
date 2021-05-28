package main

import (
	"embed"
	"errors"
	"flag"
	"fmt"
	"io/fs"
	"log"
	"net/http"
	"os"
)

const (
	flagUseLocal = "local"
	flagPort     = "port"

	webPath     = "build/web"
	storagePath = "shared"

	defaultPort  = 80
	defaultLocal = false
)

//go:embed build/web
var embeddedWeb embed.FS

func main() {
	var port int
	flag.IntVar(&port, flagPort, defaultPort, "port to host the site")
	var useLocal bool
	flag.BoolVar(&useLocal, flagUseLocal, defaultLocal, "true to use the local file system instead of the embedded files")

	flag.Parse()

	log.Printf("-%s: %d", flagPort, port)
	log.Printf("-%s: %t", flagUseLocal, useLocal)

	if _, err := os.Stat(storagePath); errors.Is(err, os.ErrNotExist) {
		log.Printf("Storage path [%s] not found", storagePath)
	} else {
		log.Printf("Storage path [%s] found", storagePath)
	}

	http.Handle("/", logWrapper(http.FileServer(getFileSystem(useLocal, webPath))))
	reason := http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	log.Printf("Server shutdown, reason: %v", reason)
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
