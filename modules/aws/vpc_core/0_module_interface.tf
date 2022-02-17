/*
          _
 ___  ___| |_ _   _ _ __
/ __|/ _ \ __| | | | '_ \
\__ \  __/ |_| |_| | |_) |
|___/\___|\__|\__,_| .__/
                   |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest

terraform {
  required_version = ">= 1.1.0, < 1.2.0"

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = ">= 3.74.1, < 4.2.0"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones

data "aws_caller_identity" "current" {}

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

# XXX FIXME TODO Set this to true when NAT instances are golden.
variable "create_nat_instances" {
  type        = bool
  description = "Create NAT instances instead of NAT gateways"
  default     = false
}

variable "how_many_azs" {
  type        = number
  description = "How many availability zones to use in the desired region"
  default     = 3
}

variable "how_many_nats" {
  type        = number
  description = "CHANGE FOR MOAR SPENDY!!!  How many NAT gateways/instances to create across the available AZs"
  default     = 0
  # WARNING:  how_many_nats <= how_many_azs
}

variable "preserve_default_rules" {
  type        = bool
  description = "Preserve the default NACL and SG rules when these resources get tagged"
  default     = true
}

# A NOTE ABOUT VPC AND SUBNET SIZES:

# https://aws.amazon.com/vpc/faqs/
# https://pantz.org/software/tcpip/subnetchart.html

# A subnet range can't be larger or smaller than your allowed VPC CIDR block.
# AWS reserves 5 addresses on every subnet.  We expect to create a minimum of 3
# subnets.  The value chosen for this variable very much depends on the VPC
# CIDR block and the number of AZs.  We can have this value be min = 0, max =
# 12 but some values in this range are still just plain silly or cause errors
# like...

# Call to function "cidrsubnet" failed: prefix extension of n does not accommodate a subnet numbered 8.

# Assigned IPv6 ranges are currently fixed at /56 for VPCs and /64 for subnets
# (8 bits).

variable "subnet_ipv4_cidr_bits" {
  type        = number
  description = "Bits to carve off for each IPv4 subnet range from the main VPC CIDR block"
  default     = 4
}

variable "subnet_ipv6_cidr_bits" {
  type        = number
  description = "Bits to carve off for each IPv6 subnet range from the main VPC CIDR block"
  default     = 8
}

variable "vpc_ipv4_cidr_block" {
  type        = string
  description = "IPv4 CIDR block to assign to the VPC (with netmask from /16 to /28)"
  # There should be no default for this variable.
}

variable "vpc_instance_tenancy" {
  type        = string
  description = "CHANGE FOR MOAR SPENDY!!!  How much to share resources with other cloud users"
  default     = "default"

  # validation {
  #   condition     = contains(["default", "dedicated", "host"], var.vpc_instance_tenancy)
  #   error_message = "Value must be one of:  default, dedicated or host"
  # }
}

/*
             _               _
  ___  _   _| |_ _ __  _   _| |_ ___
 / _ \| | | | __| '_ \| | | | __/ __|
| (_) | |_| | |_| |_) | |_| | |_\__ \
 \___/ \__,_|\__| .__/ \__,_|\__|___/
                |_|
*/

output "network_acl_id_public" {
  value = aws_network_acl.public.id
}

output "network_acl_id_private" {
  value = aws_network_acl.private.id
}

output "network_acl_id_secure" {
  value = aws_network_acl.secure.id
}

output "route_table_ids_public" {
  value = aws_route_table.public_az[*].id
}

output "route_table_ids_private" {
  value = aws_route_table.private_az[*].id
}

output "route_table_ids_secure" {
  value = aws_route_table.secure_az[*].id
}

output "security_group_id_public" {
  value = aws_security_group.public.id
}

output "security_group_id_private" {
  value = aws_security_group.private.id
}

output "security_group_id_secure" {
  value = aws_security_group.secure.id
}

output "subnet_ids_public" {
  value = aws_subnet.public_az[*].id
}

output "subnet_ids_private" {
  value = aws_subnet.private_az[*].id
}

output "subnet_ids_secure" {
  value = aws_subnet.secure_az[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}
