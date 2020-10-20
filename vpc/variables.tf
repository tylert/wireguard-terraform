variable "basename" {
  description = "Tag prefix to use for all resources"
  type        = string
}

variable "region" {
  description = "AWS region in which to launch all non-global resources"
  type        = string
}

variable "how_many_azs" {
  description = "Number of availability zones to use in the desired region"
  type        = string
  default     = 2
}

variable "vpc_cidr_block" {
  description = "IPv4 CIDR block to assign to the VPC (with netmask from /16 to /28)"
  type        = string
}

variable "enable_natgws" {
  description = "Whether to turn on the spendy IPv4 NAT gateways"
  type        = string
  default     = false
}
