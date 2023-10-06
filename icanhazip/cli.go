package main

import (
	"flag"
	"fmt"
	"os"

	. "github.com/ian-kent/envconf"
	"gopkg.in/ini.v1"
)

// Command-line arguments
var (
	aPort    string
	aProto   string
	aVersion bool
)

func init() {
	// Usage for command-line arguments
	const (
		uPort    = "TCP port number on which to listen 0-65535"
		uProto   = "IP version on which to listen IPv6/v4"
		uVersion = "Display build version information (default false)"
	)

	flag.StringVar(&aProto, "ipv", FromEnvP("ICANHAZIP_PROTO", "4").(string), uProto)
	flag.StringVar(&aProto, "i", FromEnvP("ICANHAZIP_PROTO", "4").(string), uProto)
	flag.StringVar(&aPort, "port", FromEnvP("ICANHAZIP_PORT", "8080").(string), uPort)
	flag.StringVar(&aPort, "p", FromEnvP("ICANHAZIP_PORT", "8080").(string), uPort)
	flag.BoolVar(&aVersion, "version", FromEnvP("ICANHAZIP_VERSION", false).(bool), uVersion)
	flag.BoolVar(&aVersion, "v", FromEnvP("ICANHAZIP_VERSION", false).(bool), uVersion)

	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "Usage of %s:\n", os.Args[0])
		flag.PrintDefaults()
		// flag.VisitAll(func(f *flag.Flag) {
		//   fmt.Fprintf(os.Stderr, "%v %v %v\n", f.Name, f.Value, f.Usage)
		// })
	}

	// FlagSet for sub-commands???
	// https://www.digitalocean.com/community/tutorials/how-to-use-the-flag-package-in-go

	// Attempt to gracefully load things from a known config file location
	// home, _ := os.UserHomeDir()
	// cfg, err := ini.Load(fmt.Sprintf("%s/.config/icanhazip/defaults", home))

	flag.Parse()
	if flag.NArg() > 0 {
		fmt.Fprintf(os.Stderr, "Error: Unused command line arguments detected.\n")
		flag.Usage()
		os.Exit(1)
	}
}
