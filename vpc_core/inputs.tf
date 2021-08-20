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
  # there should be no default for this variable
}

variable "basename" {
  type        = string
  description = "Tag prefix to use for all related resources (e.g.:  test1)"
  # there should be no default for this variable
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
}

variable "prefer_nat_instances" {
  type        = bool
  description = ""
  default     = true
}

variable "preserve_default_rules" {
  type        = bool
  description = "Preserve the default NACL and SG rules when these resources get tagged"
  default     = false
}

variable "subnet_bits" {
  type        = number
  description = "Bits to carve off for each IPv4 subnet range from the main VPC CIDR block"
  default     = 6
}

variable "vpc_cidr_block" {
  type        = string
  description = "IPv4 CIDR block to assign to the VPC (with netmask from /16 to /28)"
  # there should be no default for this variable
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