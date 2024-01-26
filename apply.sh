#!/usr/bin/env bash

layer_dir="${1}"
if [ -z "${layer_dir}" ]; then
    echo 'You must provide a layer to deploy.'
    exit 1
fi

tf_bin='TF_IN_AUTOMATION=1 tofu'
plan_file='plan_file.zip'

# Do an init, followed by a validate, plan, pause, then do an apply
# Hit ctrl-c once to abort things (before ending the pause to do it cleanly)
"${tf_bin}" -chdir="${layer_dir}" init -input=false -upgrade=true
"${tf_bin}" -chdir="${layer_dir}" validate
"${tf_bin}" -chdir="${layer_dir}" plan ${EXTERMINATE_EXTERMINATE} -input=false -out="${plan_file}"
echo '=============================================================='
echo '=============================================================='
echo '=============================================================='
echo 'HIT ENTER HERE IF YOU WOULD LIKE TO PROCEED WITH DEPLOYMENT!!!'
echo 'OTHERWISE HIT CTRL-C EXACTLY ONCE TO ABORT THIS DEPLOYMENT!!!'
echo '=============================================================='
echo '=============================================================='
echo '=============================================================='
read
"${tf_bin}" -chdir="${layer_dir}" apply -auto-approve -input=false "${plan_file}"
