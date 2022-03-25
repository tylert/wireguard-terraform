::

    # Develop a single module
    ./tf.sh fmt MODULE_LEAF_DIRECTORY
    ./tf.sh init MODULE_LEAF_DIRECTORY
    ./tf.sh validate MODULE_LEAF_DIRECTORY
    ./tf.sh lint_init MODULE_LEAF_DIRECTORY
    ./tf.sh lint MODULE_LEAF_DIRECTORY

    # Deploy a single deployment
    ./tf.sh init DEPLOYMENT_LEAF_DIRECTORY
    ./tf.sh plan DEPLOYMENT_LEAF_DIRECTORY
    ./tf.sh apply DEPLOYMENT_LEAF_DIRECTORY

    # Undeploy a single deployment
    ./tf.sh plan_destroy DEPLOYMENT_LEAF_DIRECTORY
    ./tf.sh destroy DEPLOYMENT_LEAF_DIRECTORY


Network ACLs
------------

Rule numbers can be assigned any values from 1 to 32766, inclusive.  This code
reserves for "its own use" the entire rule number range from 16834 to 32766
(2^14 to 2^15-2).

* Rule numbers 23xxx to 32xxx are RFU.
* Rule numbers xx5xx to xx9xx are RFU.
* Rule numbers xxxx3 to xxxx9 are RFU.
* Rule numbers xxxx0 are RFU.

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

#. Allow all outbound traffic to go anywhere from any subnets.
#. Allow all inbound traffic to freely pass between the "same-tier" subnets.
#. Allow all inbound traffic to freely pass between the "different-tier" subnets.
#. Allow all inbound ICMP, HTTPS, SSH traffic to freely-enter all subnets.


TODO
----

* https://registry.terraform.io/modules/hashicorp/dir/template/latest  templating backends hack to remove most Terraform annoyances???
* https://github.com/cloudposse/terraform-aws-dynamic-subnets/blob/master/nat-instance.tf
* https://github.com/zmingxie/amzn2-wireguard-ami  Packer template for building the needed AMIs
* https://github.com/fly-examples/rds-connector/blob/main/main.tf#L118-L180
* https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-s3.html  provide option to use S3 for VPC flow logs instead of CloudWatch Logs
* https://www.terraform.io/docs/configuration/variables.html#custom-validation-rules  for variables to make sure they are not too big or too small (e.g.:  AZ and NAT gw counts)???
* https://registry.terraform.io/providers/hashicorp/random/latest/docs  generate random strings for the basenames???
* https://registry.terraform.io/providers/hashicorp/cloudinit/latest  cloud-init magic???
* https://github.com/int128/terraform-aws-nat-instance  NAT instance with ASG
* https://docs.aws.amazon.com/vpc/latest/userguide/route-table-options.html  S3 endpoint PrivateLink stuff
* https://goteleport.com/blog/security-hardening-ssh-bastion-best-practices/  harden SSH???
* https://github.com/smallstep/step-ssh-example/blob/master/host-bootstrap.sh  user-data some SSH goop


Terraform Annoyances
--------------------

* https://github.com/hashicorp/terraform-provider-aws/issues/15982  open since Nov 2020;  intermittent pseudo-failure based on IPv6 address?
* https://github.com/hashicorp/terraform-provider-aws/issues/20104  open since Jul 2021;  allow tagging of sgr resources (new AWS feature)
* https://github.com/hashicorp/terraform-provider-aws/issues/21574  open since Nov 2021;  seems related to issue 15982
* https://github.com/hashicorp/terraform/issues/13022  open since Mar 2017;  making backend config unnecessarily complicated
* https://github.com/hashicorp/terraform/issues/19300  open since Nov 2018;  making backend use unnecessarily complicated
* https://github.com/hashicorp/terraform/issues/23340  open since Nov 2019;  making testing of modules unnecessarily complicated
* https://github.com/terraform-linters/tflint/issues/1181  open since Aug 2021;  makes adding tflint config files to a project less awesome
* https://github.com/terraform-linters/tflint/issues/1217  open since Sep 2021;  makes adding tflint config files to a project less awesome
* https://github.com/jsiebens/hashi-up/issues/24  open since Jul 2021;  makes automated fetching of Terraform less awesome


SSH Keygen
~~~~~~~~~~

* https://github.com/terraform-aws-modules/terraform-aws-key-pair
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
* https://stackoverflow.com/questions/49743220/how-do-i-create-an-ssh-key-in-terraform
* https://devops.stackexchange.com/questions/3408/how-can-i-get-terraforms-extern-to-execute-ssh-keygen-y-f-ssh-id-rsa
* https://gist.github.com/irvingpop/968464132ded25a206ced835d50afa6b
* https://www.terraform.io/docs/language/resources/provisioners/local-exec.html


References
----------

* https://aws.amazon.com/blogs/aws/building-three-tier-architectures-with-security-groups/
* https://smartlogic.io/blog/how-i-organize-terraform-modules-off-the-beaten-path/
* https://learn.hashicorp.com/tutorials/terraform/automate-terraform?in=terraform/automation
* https://www.hashicorp.com/blog/terraform-0-12-conditional-operator-improvements#conditionally-omitted-arguments
* https://www.terraform.io/docs/language/state/workspaces.html#when-to-use-multiple-workspaces
* https://www.hashicorp.com/resources/going-multi-account-with-terraform-on-aws
* https://blog.gruntwork.io/5-lessons-learned-from-writing-over-300-000-lines-of-infrastructure-code-36ba7fadeac1
* https://jeffbrown.tech/terraform-dynamic-blocks/
* https://learn.hashicorp.com/collections/terraform/modules
* https://www.terraform.io/docs/language/modules/sources.html#selecting-a-revision
* https://markwarneke.me/2020-10-14-Generic-Terraform-Module-Test-Using-Terratest/
* https://github.com/amritb/poor-mans-vpn
* https://www.procustodibus.com/blog/2021/04/wireguard-point-to-site-port-forwarding/
* https://blog.aleksic.dev/using-ansible-and-nomad-for-a-homelab-part-1
* https://techoverflow.net/2022/02/01/how-to-connect-tailscale-to-headscale-server-on-linux/
* https://developers.cloudflare.com/cloudflare-one/tutorials/ssh/
* https://blog.tonari.no/introducing-innernet


Cleanup In Aisle Five
---------------------

* https://github.com/rebuy-de/aws-nuke
* https://github.com/gruntwork-io/cloud-nuke
