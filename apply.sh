#!/usr/bin/env bash

layer_dir="${1}"
if [ -z "${layer_dir}" ]; then
    echo 'You must provide a layer to deploy.'
    exit 1
fi

terraform_bin='terraform'
plan_file='plan_file.zip'

# Do an init, followed by a plan, pause, then do an apply
# Hit ctrl-c to abort the deployment (before ending the pause to do it cleanly)
"${terraform_bin}" -chdir="${layer_dir}" init -input=false -upgrade=true
"${terraform_bin}" -chdir="${layer_dir}" plan ${EXTERMINATE_EXTERMINATE} -input=false -out="${plan_file}"

echo 'Pause for reflection before applying everything...'
read
"${terraform_bin}" -chdir="${layer_dir}" apply -auto-approve -input=false "${plan_file}"

# Clean up the stale plan file
rm -f "${layer_dir}/${plan_file}"
