/*
          _
 ___  ___| |_ _   _ _ __
/ __|/ _ \ __| | | | '_ \
\__ \  __/ |_| |_| | |_) |
|___/\___|\__|\__,_| .__/
                   |_|
*/

# https://github.com/opentofu/opentofu/releases
# https://github.com/opentofu/terraform-provider-aws/releases
# https://search.opentofu.org/provider/opentofu/aws/latest

terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "registry.opentofu.org/opentofu/aws"
      version = ">= 5.0.0, < 6.0.0"
    }
  }
}

# https://search.opentofu.org/provider/opentofu/aws/latest/docs/datasources/caller_identity
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/datasources/region
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/datasources/availability_zones

data "aws_caller_identity" "current" {} # aws_account_id

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

# https://search.opentofu.org/provider/opentofu/aws/latest/docs/datasources/vpc
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/datasources/network_acls
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/datasources/security_group

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
