#!/usr/bin/env bash

layer_dir="${1}"
if [ -z "${layer_dir}" ]; then
    echo 'You must provide a layer to deploy.'
    exit 1
fi

if [ -z "${TF_BIN}" ]; then
    TF_BIN='tofu'
fi

plan_file='plan_file.zip'

# Do an init, followed by a validate, plan, pause, then do an apply
# Hit ctrl-c once to abort things (before ending the pause to do it cleanly)
TF_IN_AUTOMATION=1 "${TF_BIN}" -chdir="${layer_dir}" init -input=false -upgrade=true
TF_IN_AUTOMATION=1 "${TF_BIN}" -chdir="${layer_dir}" validate
TF_IN_AUTOMATION=1 "${TF_BIN}" -chdir="${layer_dir}" plan ${EXTERMINATE_EXTERMINATE} -input=false -out="${plan_file}"
echo '=============================================================='
echo '=============================================================='
echo '=============================================================='
echo 'HIT ENTER HERE IF YOU WOULD LIKE TO PROCEED WITH DEPLOYMENT!!!'
echo 'OTHERWISE HIT CTRL-C EXACTLY ONCE TO ABORT THIS DEPLOYMENT!!!'
echo '=============================================================='
echo '=============================================================='
echo '=============================================================='
read
TF_IN_AUTOMATION=1 "${TF_BIN}" -chdir="${layer_dir}" apply -auto-approve -input=false "${plan_file}"
