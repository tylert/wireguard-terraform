/*
__   ___ __   ___       ___ ___  _ __ ___
\ \ / / '_ \ / __|____ / __/ _ \| '__/ _ \
 \ V /| |_) | (_|_____| (_| (_) | | |  __/
  \_/ | .__/ \___|     \___\___/|_|  \___|
      |_|
*/

# https://aws.amazon.com/blogs/aws/building-three-tier-architectures-with-security-groups/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones

terraform {
  required_version = "~> 0.13.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.18.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  assign_generated_ipv6_cidr_block = true
  enable_classiclink               = false
# enable_classiclink_dns_support   = false      # ???
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"  # least spendy;  "dedicated"|"host"

  tags = {
    Name = "${var.basename}-vpc"
  }
}

resource "aws_vpc_dhcp_options" "main" {
  domain_name         = "${var.region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
# ntp_servers         = []

  tags = {
    Name = "${var.basename}-dopt"
  }
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}

data "aws_availability_zones" "available" {
  state = "available"
}
