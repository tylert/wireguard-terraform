package main

import (
	"flag"
	"fmt"
	"os"

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
		sPort    = "TCP port number on which to listen 0-65535"
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
