/*
          _
 ___  ___| |_ _   _ _ __
/ __|/ _ \ __| | | | '_ \
\__ \  __/ |_| |_| | |_) |
|___/\___|\__|\__,_| .__/
                   |_|
*/

# https://releases.hashicorp.com/terraform
# https://releases.hashicorp.com/terraform-provider-aws
# https://registry.terraform.io/providers/hashicorp/aws/latest

terraform {
  required_version = ">= 1.0.0, < 1.6.0"

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = ">= 5.0.0, < 6.0.0"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones

data "aws_caller_identity" "current" {} # account_id

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

/*
 _                   _
(_)_ __  _ __  _   _| |_ ___
| | '_ \| '_ \| | | | __/ __|
| | | | | |_) | |_| | |_\__ \
|_|_| |_| .__/ \__,_|\__|___/
        |_|
*/

variable "basename" {
  type        = string
  description = "Tag substring to use for all related resources (e.g.:  test1)"
  # There should be no default for this variable.
}

variable "external_ipv4_addrs" {
  type        = list(string)
  description = "List of IPv4 addresses with which to communicate"
  default     = ["0.0.0.0/0"]
}

variable "external_ipv6_addrs" {
  type        = list(string)
  description = "List of IPv6 addresses with which to communicate"
  default     = ["::/0"]
}

variable "https_port" {
  type        = number
  description = "Port to use for HTTPS"
  default     = 443
}

variable "ssh_port" {
  type        = number
  description = "Port to use for SSH"
  default     = 22
}

variable "wg_port" {
  type        = number
  description = "Port to use for Wireguard"
  default     = 51820
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_acls
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group

data "aws_vpc" "main" {
  tags = {
    Name = "vpc-${var.basename}"
  }
}

data "aws_network_acls" "public" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "acl-${var.basename}-pub"
  }
}

data "aws_network_acls" "private" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "acl-${var.basename}-priv"
  }
}

data "aws_network_acls" "secure" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "acl-${var.basename}-sec"
  }
}

data "aws_security_group" "public" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "sg-${var.basename}-pub"
  }
}

data "aws_security_group" "private" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "sg-${var.basename}-priv"
  }
}

data "aws_security_group" "secure" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "sg-${var.basename}-sec"
  }
}

/*
             _               _
  ___  _   _| |_ _ __  _   _| |_ ___
 / _ \| | | | __| '_ \| | | | __/ __|
| (_) | |_| | |_| |_) | |_| | |_\__ \
 \___/ \__,_|\__| .__/ \__,_|\__|___/
                |_|
*/
