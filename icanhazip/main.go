package main

import (
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"strings"
)

func main() {
	// Print out the version information
	if aVersion {
		fmt.Println(GetVersion())
		os.Exit(0)
	}

	sm := http.NewServeMux()
	sm.HandleFunc("/", showIp)

	var (
		l   net.Listener
		err error
	)
	switch aProto {
	case "4":
		l, err = net.Listen("tcp4", fmt.Sprintf(":%s", aPort))
	case "6":
		l, err = net.Listen("tcp6", fmt.Sprintf(":%s", aPort))
	default:
		fmt.Println("Unsupported protocol")
		os.Exit(2)
	}

	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(fmt.Sprintf(":%s", aPort))
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
