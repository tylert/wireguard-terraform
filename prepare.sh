#!/usr/bin/env bash


# Enable "bash strict mode".
# set -u is the same as set -o nounset
# set -e is the same as set -o errexit
# set -E is the same as set -o errtrace
# set -eEu -o pipefail
# shopt -s extdebug is the same as bash --debugger
# shopt -s extdebug
# IFS=$'\n\t'


hu_get() {
    local path="${1}"

    if [ -z "${path}" ]; then
        path="$(pwd)"
    fi

    local suffix=""
    case $(uname) in
        "Linux")
            case $(uname -m) in
                "aarch64") suffix="-arm64" ;;
                "armv6l" | "armv7l") suffix="-armhf" ;;
            esac ;;
        "Darwin") suffix="-darwin" ;;
    esac

    local repo_base='https://github.com/jsiebens/hashi-up'
    local target_file="${path}/hashi-up"

    # Fetch release and hash data before downloading the main binary
    local release=$(curl --head --silent ${repo_base}/releases/latest | grep -i location: | awk -F"/" '{ printf "%s", $NF }' | tr -d '\r')
    local bin_url="${repo_base}/releases/download/${release}/hashi-up${suffix}"
    local remote_hash=$(curl --location "${bin_url}.sha256" --silent | cut -d' ' -f1)

    # Download the hashi-up binary
    if [ ! -e "${target_file}" ]; then
        echo "Downloading '${bin_url}' to '${target_file}'"
        curl --location "${bin_url}" --output "${target_file}" --progress-bar --show-error
        chmod +x "${target_file}"
        echo "Download complete."
    fi

    local local_hash=""
    case $(uname) in
        "Linux") local_hash=$(sha256sum "${target_file}" | cut -d' ' -f1) ;;
        "Darwin") local_hash=$(shasum -a 256 "${target_file}" | cut -d' ' -f1) ;;
    esac

    if [ "${remote_hash}" != "${local_hash}" ]; then
        echo "Wrong hash!!!  '${remote_hash}' expected but got '${local_hash}'"
    fi
}


tf_get() {
    local path="${1}"

    if [ -z "${path}" ]; then
        path="$(pwd)"
    fi

    local target_file="${path}/terraform"

    if [ ! -e "${target_file}" ]; then
        "${HASHI_UP}" terraform get --dest "${path}"
    fi

    local local_hash=""
    case $(uname) in
        "Linux") local_hash=$(sha256sum "${target_file}" | cut -d' ' -f1) ;;
        "Darwin") local_hash=$(shasum -a 256 "${target_file}" | cut -d' ' -f1) ;;
    esac

    # XXX FIXME TODO  Actually do something with the hash and compare it to the
    # remote one fetched from https://releases.hashicorp.com.
}


# Use the binary found in ${PATH} by default
if [ -z "${HASHI_UP}" ]; then
    HASHI_UP='hashi-up'
fi

path="${1}"
"hu_get" "${path}"
"tf_get" "${path}"
