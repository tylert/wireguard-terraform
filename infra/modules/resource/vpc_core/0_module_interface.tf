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
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "registry.opentofu.org/hashicorp/aws"
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

variable "create_nat_instances" {
  type        = bool
  description = "Create NAT instances instead of NAT gateways"
  default     = false
}

variable "dns_servers" {
  type        = list(string)
  description = ""
  default     = ["AmazonProvidedDNS"] # max 4
}

variable "enable_ipv6" {
  type        = bool
  description = "Toggle the things needed to use IPv6"
  default     = true
}

variable "flow_logs_enabled" {
  type        = bool
  description = "CHANGE FOR MOAR SPENDY!!!  Enable VPC Flow Logs (S3)"
  default     = false
}

variable "flow_logs_max_aggregation_interval" {
  type        = number
  description = ""
  default     = 600
}

variable "how_many_azs" {
  type        = number
  description = "How many availability zones to use in the desired region"
  default     = 3
}

# time.nrc.ca, time.aws.com
variable "ntp_servers" {
  type        = list(string)
  description = ""
  default     = [] # max 8;  4 IPv4 and 4 IPv6
  # default     = ["169.254.169.123"] # max 8;  4 IPv4 and 4 IPv6
}

variable "preserve_default_rules" {
  type        = bool
  description = "Preserve the default NACL and SG rules when these resources get tagged"
  default     = true
}

# A NOTE ABOUT VPC AND SUBNET SIZES:

# https://aws.amazon.com/vpc/faqs
# https://pantz.org/software/tcpip/subnetchart.html

# A subnet range can't be larger or smaller than your allowed VPC CIDR block.
# AWS reserves 5 addresses on every subnet.  We expect to create a minimum of 3
# subnets per AZ.  The value chosen for this variable very much depends on the
# VPC CIDR block chosen and the number of AZs.  We can have this value be min =
# 0, max = 12 but some values in this range are still just plain silly or cause
# errors like...

# Call to function "cidrsubnet" failed: prefix extension of n does not accommodate a subnet numbered 8.

# IPv6 VPC ranges may be between /44 and /60, and IPv6 subnet ranges may be
# between /44 and /64, in increments of /4.  Assigned IPv6 ranges were once
# fixed at /56 for VPCs and /64 for subnets (8 bits).

# https://aws.amazon.com/about-aws/whats-new/2023/11/vpcs-subnets-support-more-sizes-ipv6-cidrs

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

variable "use_ipam" {
  type        = bool
  description = "Use AWS IPAM instead of picking your own CIDR"
  default     = false
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
