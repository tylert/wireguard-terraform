/*
                     ___         _ _
__   ___ __   ___   ( _ )     __| | |__   ___ _ __
\ \ / / '_ \ / __|  / _ \/\  / _` | '_ \ / __| '_ \
 \ V /| |_) | (__  | (_>  < | (_| | | | | (__| |_) |
  \_/ | .__/ \___|  \___/\/  \__,_|_| |_|\___| .__/
      |_|                                    |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-dhcp-options.html

resource "aws_vpc" "main" {
  cidr_block = var.vpc_ipv4_cidr_block

  assign_generated_ipv6_cidr_block = true
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = var.vpc_instance_tenancy

  tags = {
    Name = "vpc-${var.basename}"
  }
}

# Unless you're doing fancy stuff in DNS:
# if us-east-1 then "ec2.internal", if other region then "$REGION.compute.internal"

resource "aws_vpc_dhcp_options" "main" {
  domain_name         = "us-east-1" == data.aws_region.current.name ? "ec2.internal" : "${data.aws_region.current.name}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]                              # max 4
  # ntp_servers         = [] # max 4  # "time.aws.com"???  "time.nrc.ca"???

  tags = {
    Name = "dopt-${var.basename}"
  }
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}
