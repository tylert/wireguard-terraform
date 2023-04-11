#!/usr/bin/env bash

# Need to add call to init with -backend-config=foo.tfvars later
terraform -chdir=infra/deployments/dev/ init -input=false -upgrade=true
terraform -chdir=infra/deployments/dev/ plan -input=false -out=plan_file
echo 'Pause for reflection before applying everything...'
read
terraform -chdir=infra/deployments/dev/ apply -auto-approve -input=false plan_file
