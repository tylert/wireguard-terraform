#!/usr/bin/env bash


# A helpful wrapper script for using Terraform modules as distinct entities.

# This script depends on:  bash, terraform, tflint.


# Enable "bash strict mode".
# set -u is the same as set -o nounset
# set -e is the same as set -o errexit
# set -E is the same as set -o errtrace
# set -eEu -o pipefail
# shopt -s extdebug is the same as bash --debugger
# shopt -s extdebug
# IFS=$'\n\t'


# Call 'terraform init' for a module
tf_init() {
    local module="${1}"
    local conf_file="${2}"

    if [ -z "${module}" ]; then
        echo 'Unspecified module.'
        return 1
    fi

    if [ -z "${conf_file}" ]; then
        conf_file='../backend.tfvars'
    fi

    if [ -e "${conf_file}" ]; then
        "${TERRAFORM}"                     \
            -chdir="${module}"             \
            init                           \
            -backend-config="${conf_file}" \
            -input=false                   \
            -upgrade=true
    else
        "${TERRAFORM}"         \
            -chdir="${module}" \
            init               \
            -input=false       \
            -upgrade=true
    fi
}


# Call 'tflint --init' for a module
tf_lint_init() {
    local module="${1}"

    if [ -z "${module}" ]; then
        echo 'Unspecified module.'
        return 1
    fi

    "${TFLINT}" --init "${module}"
}


# Call 'tflint' for a module
tf_lint() {
    local module="${1}"

    if [ -z "${module}" ]; then
        echo 'Unspecified module.'
        return 1
    fi

    "${TFLINT}" "${module}"
}


# Call 'terraform validate' for a module
tf_validate() {
    local module="${1}"

    if [ -z "${module}" ]; then
        echo 'Unspecified module.'
        return 1
    fi

    "${TERRAFORM}"         \
        -chdir="${module}" \
        validate
}


# Call 'terraform fmt' for all files in a module
tf_fmt() {
    local module="${1}"

    if [ -z "${module}" ]; then
        echo 'Unspecified module.'
        return 1
    fi

    # Only .tf and .tfvars files can be processed with terraform fmt
    for file in "${module}"/*.tf; do
        "${TERRAFORM}" fmt "${file}"
    done
}


# Call 'terraform plan' for a module
#     XXX FIXME TODO  Combine tf_plan and tf_plan_destroy functions???
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

    if [ -e "${var_file}" ]; then
        "${TERRAFORM}"              \
            -chdir="${module}"      \
            plan                    \
            -input=false            \
            -out="${plan_file}"     \
            -var-file="${var_file}"
    else
        "${TERRAFORM}"          \
            -chdir="${module}"  \
            plan                \
            -input=false        \
            -out="${plan_file}"
    fi
}


# Call 'terraform plan -destroy' for a module
#     XXX FIXME TODO  Combine tf_plan and tf_plan_destroy functions???
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

    if [ -e "${var_file}" ]; then
        "${TERRAFORM}"              \
            -chdir="${module}"      \
            plan                    \
            -destroy                \
            -input=false            \
            -out="${plan_file}"     \
            -var-file="${var_file}"
    else
        "${TERRAFORM}"          \
            -chdir="${module}"  \
            plan                \
            -destroy            \
            -input=false        \
            -out="${plan_file}"
    fi
}


# Call 'terraform apply' for a module
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


# Call 'terraform destroy' for a module
tf_destroy() {
    local module="${1}"
    local plan_file="${2}"

    tf_apply "${module}" "${plan_file}"
}


# Use the binary found in ${PATH} by default
if [ -z "${TERRAFORM}" ]; then
    TERRAFORM='terraform'
fi

# Use the binary found in ${PATH} by default
if [ -z "${TFLINT}" ]; then
    TFLINT='tflint'
fi

action="${1}"
module="${2}"
"tf_${action}" "${module}"
