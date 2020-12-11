::

    pushd ${NAME_OF_MODULE}
    terraform init
    terraform plan -var-file=../test.tfvars -out=foop
    terraform apply foop
    popd
