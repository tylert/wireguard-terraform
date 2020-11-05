variable "basename" {
  type        = string
  description = "Tag prefix to use for all resources"
  default     = "test"
}

variable "how_many_azs" {
  type        = number
  description = "Number of availability zones to use in the desired region"
  default     = 3
}

variable "how_many_natgws" {
  type        = number
  description = "Number of NAT gateways to create across the available AZs"
  default     = 0
}

variable "region" {
  type        = string
  description = "AWS region in which to launch all non-global resources"
  default     = "ca-central-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "IPv4 CIDR block to assign to the VPC (with netmask from /16 to /28)"
  default     = "10.0.0.0/16"
}
