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


# Call 'terraform init' for a directory
tf_init() {
    local directory="${1}"
    local var_file="${2}"

    if [ -z "${directory}" ]; then
        echo 'Unspecified directory.'
        return 1
    fi

    if [ -z "${var_file}" ]; then
        var_file='terraform.tfvars'
    fi

    if [ -e "${var_file}" ]; then
        "${TERRAFORM}"                    \
            -chdir="${directory}"         \
            init                          \
            -backend-config="${var_file}" \
            -input=false                  \
            -upgrade=true
    else
        "${TERRAFORM}"            \
            -chdir="${directory}" \
            init                  \
            -input=false          \
            -upgrade=true
    fi
}


# Call 'tflint --init' for a directory
tf_lint_init() {
    local directory="${1}"

    if [ -z "${directory}" ]; then
        echo 'Unspecified directory.'
        return 1
    fi

    "${TFLINT}" --init "${directory}"
}


# Call 'tflint' for a directory
tf_lint() {
    local directory="${1}"

    if [ -z "${directory}" ]; then
        echo 'Unspecified directory.'
        return 1
    fi

    "${TFLINT}" "${directory}"
}


# Call 'terraform validate' for a directory
tf_validate() {
    local directory="${1}"

    if [ -z "${directory}" ]; then
        echo 'Unspecified directory.'
        return 1
    fi

    "${TERRAFORM}"            \
        -chdir="${directory}" \
        validate
}


# Call 'terraform version' for a directory
tf_version() {
    local directory="${1}"

    if [ -z "${directory}" ]; then
        echo 'Unspecified directory.'
        return 1
    fi

    "${TERRAFORM}"            \
        -chdir="${directory}" \
        version
}


# Call 'terraform fmt' for all files in a directory
tf_fmt() {
    local directory="${1}"

    if [ -z "${directory}" ]; then
        echo 'Unspecified directory.'
        return 1
    fi

    # Only .tf and .tfvars files can be processed with terraform fmt
    for file in $(find "${directory}" -name '*.tf' -o -name '*.tfvars'); do
        "${TERRAFORM}" fmt "${file}"
    done
}


# Call 'terraform plan' for a directory
#     XXX FIXME TODO  Combine tf_plan and tf_plan_destroy functions???
tf_plan() {
    local directory="${1}"
    local var_file="${2}"
    local plan_file="${3}"

    if [ -z "${directory}" ]; then
        echo 'Unspecified directory.'
        return 1
    fi

    if [ -z "${var_file}" ]; then
        var_file='terraform.tfvars'
    fi

    if [ -z "${plan_file}" ]; then
        plan_file='plan_file'
    fi

    if [ -e "${var_file}" ]; then
        "${TERRAFORM}"              \
            -chdir="${directory}"   \
            plan                    \
            -input=false            \
            -out="${plan_file}"     \
            -var-file="${var_file}"
    else
        "${TERRAFORM}"            \
            -chdir="${directory}" \
            plan                  \
            -input=false          \
            -out="${plan_file}"
    fi
}


# Call 'terraform plan -destroy' for a directory
#     XXX FIXME TODO  Combine tf_plan and tf_plan_destroy functions???
tf_plan_destroy() {
    local directory="${1}"
    local var_file="${2}"
    local plan_file="${3}"

    if [ -z "${directory}" ]; then
        echo 'Unspecified directory.'
        return 1
    fi

    if [ -z "${var_file}" ]; then
        var_file='terraform.tfvars'
    fi

    if [ -z "${plan_file}" ]; then
        plan_file='plan_file'
    fi

    if [ -e "${var_file}" ]; then
        "${TERRAFORM}"              \
            -chdir="${directory}"   \
            plan                    \
            -destroy                \
            -input=false            \
            -out="${plan_file}"     \
            -var-file="${var_file}"
    else
        "${TERRAFORM}"            \
            -chdir="${directory}" \
            plan                  \
            -destroy              \
            -input=false          \
            -out="${plan_file}"
    fi
}


# Call 'terraform apply' for a directory
tf_apply() {
    local directory="${1}"
    local plan_file="${2}"

    if [ -z "${directory}" ]; then
        echo 'Unspecified directory.'
        return 1
    fi

    if [ -z "${plan_file}" ]; then
        plan_file='plan_file'
    fi

    "${TERRAFORM}"            \
        -chdir="${directory}" \
        apply                 \
        -auto-approve         \
        -input=false          \
        "${plan_file}"
}


# Call 'terraform destroy' for a directory
tf_destroy() {
    local directory="${1}"
    local plan_file="${2}"

    tf_apply "${directory}" "${plan_file}"
}


# Call 'terraform output' for a directory
tf_output() {
    local directory="${1}"

    if [ -z "${directory}" ]; then
        echo 'Unspecified directory.'
        return 1
    fi

    "${TERRAFORM}"            \
        -chdir="${directory}" \
        output
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
directory="${2}"
first_arg="${3}"
second_arg="${4}"
"tf_${action}" "${directory}" "${first_arg}" "${second_arg}"
