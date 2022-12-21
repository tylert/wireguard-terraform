#!/usr/bin/env bash

terraform -chdir=infra/deployments/tyler1/ plan -destroy -input=false -out=plan_file
echo 'Pause for reflection before destroying everything...'
read
terraform -chdir=infra/deployments/tyler1/ apply -auto-approve -input=false plan_file
