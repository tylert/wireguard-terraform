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
* https://github.com/fly-examples/rds-connector/blob/main/main.tf#L118-L180


Network ACLs
------------

Rule numbers can be assigned any values from 1 to 32766, inclusive.  This code
reserves for "its own use" the entire rule number range from 16834 to 32766
(2^14 to 2^15-2).

Rule numbers 23xxx to 32xxx are RFU.
Rule numbers xx5xx to xx9xx are RFU.
Rule numbers xxxx3 to xxxx9 are RFU.

ingress <-> RX = receive
egress  <-> TX = transmit

::

    17xxx:  public ingress
    18xxx:  public egress
    19xxx:  private ingress
    20xxx:  private egress
    21xxx:  secure ingress
    22xxx:  secure egress

    xx0Nx:  traffic within our VPC
    xx1Nx:  non-IP traffic (ICMP, IGMP, etc.)
    xx2Nx:  L4 ephemeral ports (TCP, UDP, etc.)
    xx3Nx:  application services (HTTPS, HTTP, etc.)
    xx4Nx:  management services (SSH, VNC, RDP, etc.)

    xxxx1:  IPv4
    xxxx2:  IPv6



Security Groups
---------------

Allow all outbound traffic to go anywhere from any subnets.
Allow all inbound traffic to freely pass between the "same-tier" subnets.
Allow all inbound traffic to freely pass between the "different-tier" subnets.
Allow all inbound ICMP, HTTPS, SSH traffic to freely-enter all subnets.


TODO
----

https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-s3.html
^^^ provide option to use S3 for VPC flow logs instead of CloudWatch Logs

https://www.terraform.io/docs/configuration/variables.html#custom-validation-rules
^^^ for variables to make sure they are not too big or too small (e.g.:  AZ and NAT gw counts)???

https://www.hashicorp.com/blog/terraform-0-12-conditional-operator-improvements#conditionally-omitted-arguments
^^^ to select either NAT gws or NAT instances???

https://registry.terraform.io/providers/hashicorp/random/latest/docs
^^^ generate random strings for the basenames???


Major Terraform Annoyances
--------------------------

* https://github.com/hashicorp/terraform-provider-aws/issues/15982
* https://github.com/hashicorp/terraform/issues/13022  <-- Open since March 2017
