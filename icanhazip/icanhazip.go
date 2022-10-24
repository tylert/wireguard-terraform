package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"runtime/debug"
	"strings"

	. "github.com/ian-kent/envconf"
	"github.com/vharitonsky/iniflags"
)

// Command-line arguments
var (
	aPort    string
	aProto   string
	aVersion bool
)

func init() {
	// Help for command-line arguments
	const (
		sPort    = "TCP port number on which to listen"
		sProto   = "IP version on which to listen IPv6/v4"
		sVersion = "Display build version information (default false)"
	)

	flag.StringVar(&aProto, "ipv", FromEnvP("ICANHAZIP_PROTO", "4").(string), sProto)
	flag.StringVar(&aProto, "i", FromEnvP("ICANHAZIP_PROTO", "4").(string), sProto)
	flag.StringVar(&aPort, "port", FromEnvP("ICANHAZIP_PORT", "8080").(string), sPort)
	flag.StringVar(&aPort, "p", FromEnvP("ICANHAZIP_PORT", "8080").(string), sPort)
	flag.BoolVar(&aVersion, "version", FromEnvP("ICANHAZIP_VERSION", false).(bool), sVersion)
	flag.BoolVar(&aVersion, "v", FromEnvP("ICANHAZIP_VERSION", false).(bool), sVersion)
	iniflags.Parse()

	if flag.NArg() > 0 {
		fmt.Fprintf(os.Stderr, "Error: Unused command line arguments detected.\n")
		flag.Usage()
		os.Exit(1)
	}
}

// go build -ldflags "-X main.Version=$(git describe --always --dirty --tags)"
var Version string

func GetVersion() string {
	var barch, bos, bmod, brev, btime, suffix string
	if info, ok := debug.ReadBuildInfo(); ok {
		for _, setting := range info.Settings {
			switch setting.Key {
			case "GOARCH":
				barch = setting.Value
			case "GOOS":
				bos = setting.Value
			case "vcs.modified":
				bmod = setting.Value
			case "vcs.revision":
				brev = setting.Value[0:7]
			case "vcs.time":
				btime = setting.Value
			}
		}
	}
	// If we didn't specify a version string, use the git commit
	if Version == "" {
		Version = brev
	}
	// If the git repo wasn't clean, say so in the version string
	if bmod == "true" {
		suffix = "-dirty"
	}
	return fmt.Sprintf("%s%s %s %s %s", Version, suffix, bos, barch, btime)
}

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
