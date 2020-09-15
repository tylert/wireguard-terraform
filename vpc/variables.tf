/******************************************************************************
Input Variables
******************************************************************************/

variable "region" {
  description = "AWS region in which to launch all AWS resources"
  type        = "string"
}

variable "basename" {
  description = "Name tag prefix to use for all AWS resources"
  type        = "string"
}

variable "span_azs" {
  description = "Number of Availability Zones to use in this region"
  type        = "string"
  default     = "2"
}

variable "enable_natgws" {
  description = "Whether to turn on the spendy IPv4 NAT gateways"
  type        = "string"
  default     = true
}

variable "enable_bastions" {
  description = "Whether to turn on the spendy SSH bastion hosts"
  type        = "string"
  default     = true
}

variable "vpc_cidr_block" {
  description = "IPv4 CIDR block to assign to the VPC (should be /16)"
  type        = "string"
}

# /16 + 6 => /22, /56 + 6 => /62

variable "subnet_mask_offset" {
  description = "How many bits to carve off of the main VPC CIDR block netmask for each subnet"
  type        = "string"
  default     = "6"
}

# Instances must be:  Linux, amd64, hvm, ebs, ssd, gp2

variable "bastion_ami" {
  description = ""
  type        = "string"
  default     = "ami-b3d965d7" # stock Ubuntu 16.04 LTS
}

variable "bastion_user" {
  description = ""
  type        = "string"
  default     = "ubuntu"
}
