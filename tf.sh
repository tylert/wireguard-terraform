#!/usr/bin/env bash


# Enable "bash strict mode".
# set -u is the same as set -o nounset
# set -e is the same as set -o errexit
# set -E is the same as set -o errtrace
# set -eEu -o pipefail
# shopt -s extdebug is the same as bash --debugger
# shopt -s extdebug
# IFS=$'\n\t'


tf_init() {
    local module="${1}"

    if [ -z "${module}" ]; then
        echo 'Unspecified module.'
        return 1
    fi

    "${TERRAFORM}"         \
        -chdir="${module}" \
        init               \
        -input=false
}


tf_plan() {
    local module="${1}"
    local plan_file="${2}"
    local var_file="${3}"

    if [ -z "${module}" ]; then
        echo 'Unspecified module.'
        return 1
    fi

    if [ -z "${plan_file}" ]; then
        plan_file='../plan_file'
    fi

    if [ -z "${var_file}" ]; then
        var_file='terraform.tfvars'
    fi

    "${TERRAFORM}"              \
        -chdir="${module}"      \
        plan                    \
        -input=false            \
        -out="${plan_file}"     \
        -var-file="${var_file}"
}


tf_apply() {
    local module="${1}"
    local plan_file="${2}"

    if [ -z "${module}" ]; then
        echo 'Unspecified module.'
        return 1
    fi

    if [ -z "${plan_file}" ]; then
        plan_file='../plan_file'
    fi

    "${TERRAFORM}"         \
        -chdir="${module}" \
        apply              \
        -auto-approve      \
        -input=false       \
        "${plan_file}"
}


tf_plan_destroy() {
    local module="${1}"
    local plan_file="${2}"
    local var_file="${3}"

    if [ -z "${module}" ]; then
        echo 'Unspecified module.'
        return 1
    fi

    if [ -z "${plan_file}" ]; then
        plan_file='../plan_file'
    fi

    if [ -z "${var_file}" ]; then
        var_file='terraform.tfvars'
    fi

    "${TERRAFORM}"              \
        -chdir="${module}"      \
        plan                    \
        -destroy                \
        -input=false            \
        -out="${plan_file}"     \
        -var-file="${var_file}"
}


tf_destroy() {
    local module="${1}"
    local plan_file="${2}"

    tf_apply "${module}" "${plan_file}"
}


# Use the binary found in ${PATH} by default
if [ -z "${TERRAFORM}" ]; then
    TERRAFORM='terraform'
fi

action="${1}"
module="${2}"
"tf_${action}" "${module}"
