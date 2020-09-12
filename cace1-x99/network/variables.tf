/******************************************************************************
Input Variables
******************************************************************************/

variable "basename" {
  description = "Name tag value to use for all AWS resources"
  type        = "string"
  default     = "x99"
}

variable "region" {
  description = "AWS region in which to launch all AWS resources"
  type        = "string"
  default     = "ca-central-1"
}

variable "span_azs" {
  description = "Number of Availability Zones to use in this region"
  type        = "string"
  default     = "1"
}

variable "enable_natgws" {
  description = "Whether to turn on the spendy IPv4 NAT gateways"
  type        = "string"
  default     = false
}

variable "enable_bastions" {
  description = "Whether to turn on the spendy SSH bastion hosts"
  type        = "string"
  default     = false
}

variable "vpc_cidr_block" {
  description = "IPv4 CIDR block for the VPC"
  type        = "string"
  default     = "172.16.0.0/16"
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

variable "ecs_ami" {
  description = ""
  type        = "string"
  default     = "ami-32bb0556" # stock ECS-optimized Amazon Linux
}

variable "ecs_user" {
  description = ""
  type        = "string"
  default     = "ec2-user"
}
