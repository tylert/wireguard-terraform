/*
                                    _       _ _
__   ___ __   ___    __ _ _ __   __| |   __| | |__   ___ _ __
\ \ / / '_ \ / __|  / _` | '_ \ / _` |  / _` | '_ \ / __| '_ \
 \ V /| |_) | (__  | (_| | | | | (_| | | (_| | | | | (__| |_) |
  \_/ | .__/ \___|  \__,_|_| |_|\__,_|  \__,_|_| |_|\___| .__/
      |_|                                               |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  assign_generated_ipv6_cidr_block = true
  enable_classiclink               = false
  # enable_classiclink_dns_support   = false # ???
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = var.vpc_instance_tenancy

  tags = {
    Name = "vpc-${var.basename}"
  }
}

resource "aws_vpc_dhcp_options" "main" {
  domain_name         = "${var.aws_region}.compute.internal" # "ec2.internal"???
  domain_name_servers = ["AmazonProvidedDNS"]
  # ntp_servers         = []

  tags = {
    Name = "dopt-${var.basename}"
  }
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}

data "aws_availability_zones" "available" {
  state = "available"
}
