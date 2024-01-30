package main

import (
	"errors"
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"
	//"gopkg.in/ini.v1"
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
	// https://digitalocean.com/community/tutorials/how-to-use-the-flag-package-in-go

	// Attempt to gracefully load things from a known config file location
	// cfg := ini.Empty()
	// home, _ := os.UserHomeDir()
	// cfg, err := ini.LooseLoad(fmt.Sprintf("%s/.config/icanhazip/defaults", home))
	// https://ini.unknwon.io/docs

	flag.Parse()
	if flag.NArg() > 0 {
		fmt.Fprintf(os.Stderr, "Error: Unused command line arguments detected.\n")
		flag.Usage()
		os.Exit(1)
	}
}

var (
	// ErrUnsupportedType is returned if the type passed in is unsupported
	ErrUnsupportedType = errors.New("Unsupported type")
)

// FromEnvP is the same as FromEnv, but panics on error
func FromEnvP(env string, value interface{}) interface{} {
	ev, err := FromEnv(env, value)
	if err != nil {
		panic(err)
	}
	return ev
}

// FromEnv returns the environment variable specified by env
// using the type of value
func FromEnv(env string, value interface{}) (interface{}, error) {
	envs := os.Environ()
	found := false
	for _, e := range envs {
		if strings.HasPrefix(e, env+"=") {
			found = true
			break
		}
	}

	if !found {
		return value, nil
	}

	ev := os.Getenv(env)

	switch value.(type) {
	case string:
		vt := interface{}(ev)
		return vt, nil
	case int:
		i, e := strconv.ParseInt(ev, 10, 64)
		return int(i), e
	case int8:
		i, e := strconv.ParseInt(ev, 10, 8)
		return int8(i), e
	case int16:
		i, e := strconv.ParseInt(ev, 10, 16)
		return int16(i), e
	case int32:
		i, e := strconv.ParseInt(ev, 10, 32)
		return int32(i), e
	case int64:
		i, e := strconv.ParseInt(ev, 10, 64)
		return i, e
	case uint:
		i, e := strconv.ParseUint(ev, 10, 64)
		return uint(i), e
	case uint8:
		i, e := strconv.ParseUint(ev, 10, 8)
		return uint8(i), e
	case uint16:
		i, e := strconv.ParseUint(ev, 10, 16)
		return uint16(i), e
	case uint32:
		i, e := strconv.ParseUint(ev, 10, 32)
		return uint32(i), e
	case uint64:
		i, e := strconv.ParseUint(ev, 10, 64)
		return i, e
	case float32:
		i, e := strconv.ParseFloat(ev, 32)
		return float32(i), e
	case float64:
		i, e := strconv.ParseFloat(ev, 64)
		return float64(i), e
	case bool:
		i, e := strconv.ParseBool(ev)
		return i, e
	default:
		return value, ErrUnsupportedType
	}
}
