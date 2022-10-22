package main

import (
	"fmt"
	"log"
	"net"
	"net/http"
	"strings"
)

func main() {
	sm := http.NewServeMux()
	sm.HandleFunc("/", showIp)

	fmt.Println(":8080")

	l, err := net.Listen("tcp4", ":8080")
	if err != nil {
		log.Fatal(err)
	}
	log.Fatal(http.Serve(l, sm))
}

func showIp(w http.ResponseWriter, r *http.Request) {
	requesterIpAndPort := r.RemoteAddr
	requesterIp := r.RemoteAddr[:strings.LastIndex(r.RemoteAddr, ":")]

	fmt.Println(requesterIpAndPort)
	w.WriteHeader(200)
	w.Write([]byte(requesterIp + "\n"))
}

// https://github.com/qwinsi/tiny-server
// https://go.dev/play/p/EOZkK1UUpe
// https://gist.github.com/2minchul/191716b3ca8799f53362746731d08e91
// https://gist.github.com/bacher09/51ce161105a9e1f49b8b917f8eccd3c5
