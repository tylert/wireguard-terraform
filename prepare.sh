#!/usr/bin/env bash


# A helpful installer script for fetching all dependencies for this project.

# This script depends on:  awk, bash, curl, cut, grep, sha256sum/shasum, tr,
# uname.

# XXX FIXME TODO  Needs more semver like https://github.com/fsaintjacques/semver-tool.
# XXX FIXME TODO  Alternately, replace all this horribleness with our own Go binary???


# Enable "bash strict mode".
# set -u is the same as set -o nounset
# set -e is the same as set -o errexit
# set -E is the same as set -o errtrace
# set -eEu -o pipefail
# shopt -s extdebug is the same as bash --debugger
# shopt -s extdebug
# IFS=$'\n\t'


# Download 'hashi-up' binary
hu_get() {
    local path="${1}"

    if [ -z "${path}" ]; then
        path="$(pwd)"
    fi

    # Find out which binary to fetch based on the local machine
    local suffix=''
    case $(uname) in
        'Linux')
            case $(uname -m) in
                'x86_64') echo 'No suffix needed for x86_64 Linux.' ;;
                'aarch64') suffix='-arm64' ;;
                'armv6l' | 'armv7l') suffix='-armhf' ;;
                *) echo 'I do not recognize your Linux machine type.' ; exit 1 ;;
            esac ;;
        'Darwin')
            case $(uname -m) in
                'x86_64') suffix='-darwin' ;;
                'arm64') echo 'Hashi-up does not yet provide Darwin arm64 builds.' ; exit 2 ;;
                *) echo 'I do not recognize your Darwin machine type.' ; exit 3 ;;
            esac ;;
        # 'MINGW') suffix='.exe' ;;
        *) echo 'I do not recognize your OS.' ; exit 4 ;;
    esac

    # Where to fetch things from/to
    local repo_base='https://github.com/jsiebens/hashi-up'
    local target_file="${path}/hashi-up"

    # Fetch release and expected hash data before downloading the main binary
    local release=$(curl --head --silent ${repo_base}/releases/latest | grep location: | awk -F"/" '{ printf "%s", $NF }' | tr -d '\r')
    local bin_url="${repo_base}/releases/download/${release}/hashi-up${suffix}"
    local remote_hash=$(curl --location "${bin_url}.sha256" --silent | cut -d' ' -f1)

    # Actually download the 'hashi-up' binary
    if [ ! -e "${target_file}" ]; then
        echo "Downloading '${bin_url}' to '${target_file}'."
        curl --location "${bin_url}" --output "${target_file}" --progress-bar --show-error
        chmod +x "${target_file}"
        echo 'Download complete.'
    fi

    # Determine hash of newly downloaded file
    local local_hash=''
    case $(uname) in
        'Linux') local_hash=$(sha256sum "${target_file}" | cut -d' ' -f1) ;;
        'Darwin') local_hash=$(shasum -a 256 "${target_file}" | cut -d' ' -f1) ;;
        # 'MINGW') local_hash=remote_hash ;;
        *) echo 'I do not recognize your OS.' ; exit 3 ;;
    esac

    # Compare hashes to decide if the download was likely successful
    if [ "${remote_hash}" != "${local_hash}" ]; then
        echo "Wrong hash!!!  '${remote_hash}' expected but got '${local_hash}'."
        echo "Please delete '${target_file}' and try again."
    fi
}


# Download 'terraform' binary
tf_get() {
    local path="${1}"
    local version="${2}"

    if [ -z "${path}" ]; then
        path="$(pwd)"
    fi

    # Control which version of Terraform is desired (or else assume latest)
    local extra_options=''
    if [ ! -z "${version}" ]; then
        extra_options="--version ${version}"
    fi

    # Where to fetch things to
    local target_file="${path}/terraform"

    # Actually download the 'terraform' binary
    # XXX FIXME TODO  https://github.com/jsiebens/hashi-up/issues/24
    if [ ! -e "${target_file}" ]; then
        bash -c "${HASHI_UP} terraform get --dest ${path} ${extra_options}"
    fi

    # Determine hash of newly downloaded file
    local local_hash=''
    case $(uname) in
        'Linux') local_hash=$(sha256sum "${target_file}" | cut -d' ' -f1) ;;
        'Darwin') local_hash=$(shasum -a 256 "${target_file}" | cut -d' ' -f1) ;;
        # 'MINGW') local_hash=remote_hash ;;
        *) echo 'I do not recognize your OS.' ; exit 3 ;;
    esac

    # XXX FIXME TODO  Actually do something with the hash and compare it to the
    # remote one fetched from https://releases.hashicorp.com/terraform/index.json.

    # Compare hashes to decide if the download was likely successful
    # if [ "${remote_hash}" != "${local_hash}" ]; then
    #     echo "Wrong hash!!!  '${remote_hash}' expected but got '${local_hash}'."
    #     echo "Please delete '${target_file}' and try again."
    # fi
}


# Use the binary found in ${PATH} by default
if [ -z "${HASHI_UP}" ]; then
    HASHI_UP='hashi-up'
fi

path="${1}"
version="${2}"
"hu_get" "${path}"
"tf_get" "${path}" "${version}"
