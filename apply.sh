#!/usr/bin/env bash

# Need to add call to init with -backend-config=foo.tfvars later
terraform -chdir=infra/deployments/tyler1/ init -input=false -upgrade=true
terraform -chdir=infra/deployments/tyler1/ plan -input=false -out=plan_file
echo 'Pause for reflection before applying everything...'
read
terraform -chdir=infra/deployments/tyler1/ apply -auto-approve -input=false plan_file
