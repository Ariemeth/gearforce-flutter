package main

import (
	"embed"
	"flag"
	"fmt"
	"io/fs"
	"net/http"
	"os"
)

const (
	flagUseLocal = "local"
	flagPort     = "port"

	webPath = "build/web"

	defaultPort  = 80
	defaultLocal = false
)

//go:embed build/web
var embeddedWeb embed.FS

func main() {
	port := flag.Int(flagPort, defaultPort, "port to host the site")
	useLocal := flag.Bool(flagUseLocal, defaultLocal, "true to use the local file system instead of the embedded files")

	flag.Parse()

	fmt.Printf("-%s: %d\n", flagPort, *port)
	fmt.Printf("-%s: %t\n", flagUseLocal, *useLocal)

	http.Handle("/", http.FileServer(getFileSystem(*useLocal)))
	reason := http.ListenAndServe(fmt.Sprintf(":%d", *port), nil)
	fmt.Printf("Server shutdown, reason: %v\n", reason)
}

func getFileSystem(useLocal bool) http.FileSystem {
	if useLocal {
		fmt.Println("using local file system")
		return http.FS(os.DirFS(webPath))
	}

	fmt.Println("using embed file system")
	fsys, err := fs.Sub(embeddedWeb, webPath)
	if err != nil {
		panic(err)
	}
	return http.FS(fsys)
}
