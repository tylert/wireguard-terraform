::

    # Create everything
    pushd vpc_core
    terraform init \
        -input=false
    terraform plan \
        -input=false \
        -out=myplan-myenv1 \
        -var=basename=myenv1 \
        -var=region=ca-central-1 \
        -var=vpc_cidr_block=10.0.0.0/16
    terraform apply \
        -input=false \
        myplan-myenv1
    popd
    pushd vpc_rules
    terraform init \
        -input=false
    terraform plan \
        -input=false \
        -out=myplan-myenv1 \
        -var=basename=myenv1 \
        -var=region=ca-central-1
    terraform apply \
        -input=false \
        myplan-myenv1
    popd

    # Destroy everything
    pushd vpc_rules
    terraform destroy \
        -input=false \
        -var=basename=myenv1 \
        -var=region=ca-central-1
    popd
    pushd vpc_core
    terraform destroy \
        -input=false \
        -var=basename=myenv1 \
        -var=region=ca-central-1 \
        -var=vpc_cidr_block=10.0.0.0/16
    popd

* https://learn.hashicorp.com/tutorials/terraform/automate-terraform?in=terraform/automation


Rule Numbers (1 to 32766)

 0xxx:  RFU public ingress
 1xxx:  RFU public egress
 2xxx:  RFU private ingress
 3xxx:  RFU private egress
 4xxx:  RFU secure ingress
 5xxx:  RFU secure egress

 6xxx:  general public ingress
 7xxx:  general public egress
 8xxx:  general private ingress
 9xxx:  general private egress
10xxx:  general secure ingress
11xxx:  general secure egress

xx0Nx:  traffic within our VPC
xx1Nx:  non-IP traffic (ICMP, IGMP)
xx2Nx:  ephemeral ports (TCP, UDP)
xx3Nx:  application services (HTTPS, HTTP, etc.)
xx4Nx:  management services (SSH, VNC, RDP, etc.)

xxxx1:  IPv4
xxxx2:  IPv6


Allow all outbound traffic to go anywhere from any subnets
Allow all inbound traffic to freely pass between the "same-tier" subnets
Allow all inbound traffic to freely pass between the "different-tier" subnets
Allow all inbound ICMP, HTTPS, SSH traffic to freely-enter all subnets
