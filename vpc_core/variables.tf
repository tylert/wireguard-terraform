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
# default     = "ca-central-1"
}

variable "basename" {
  type        = string
  description = "Tag prefix to use for all resources"
# default     = "test"
}

variable "how_many_azs" {
  type        = number
  description = "How many availability zones to use in the desired region"
  default     = 3
}

variable "how_many_natgws" {
  type        = number
  description = "How many NAT gateways to create across the available AZs"
  default     = 0
}

variable "preserve_default_rules" {
  type        = bool
  description = "Preserve the default NACL and SG rules when these resources get tagged"
  default     = true
}

variable "subnet_bits" {
  type        = number
  description = "Bits to carve off for each IPv4 subnet range from the main VPC CIDR block"
  default     = 6
}

variable "vpc_cidr_block" {
  type        = string
  description = "IPv4 CIDR block to assign to the VPC (with netmask from /16 to /28)"
# default     = "10.0.0.0/16"
}
