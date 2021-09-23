/*
                 _       _     _
__   ____ _ _ __(_) __ _| |__ | | ___  ___
\ \ / / _` | '__| |/ _` | '_ \| |/ _ \/ __|
 \ V / (_| | |  | | (_| | |_) | |  __/\__ \
  \_/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
*/

variable "aws_region" {
  type        = string
  description = "AWS region in which to launch all non-global resources"
  # There should be no default for this variable.
}

variable "basename" {
  type        = string
  description = "Tag substring to use for all related resources (e.g.:  test1)"
  # There should be no default for this variable.
}

variable "create_nat_instances" {
  type        = bool
  description = "Create NAT instances instead of NAT gateways"
  default     = false # XXX FIXME TODO Set this to true when NAT instances are golden.
}

variable "create_private_endpoints" {
  type        = bool
  description = "CHANGE FOR MOAR SPENDY!!!  Create private VPC interface endpoints for AWS services"
  default     = false
  # WARNING:  Required if not using NAT gateways/instances
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

# A subnet range can't be larger (or smaller) than your allowed VPC CIDR block.
# AWS reserves 5 addresses on every subnet.  The value chosen also depends on
# the VPC CIDR block and the number of AZs.  We can have min = 0, max = 12 but
# some values in this range are still just plain silly or cause errors like...

# Call to function "cidrsubnet" failed: prefix extension of n does not accommodate a subnet numbered 8.

variable "subnet_cidr_bits" {
  type        = number
  description = "Bits to carve off for each IPv4 subnet range from the main VPC CIDR block"
  default     = 4
}

variable "vpc_cidr_block" {
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
