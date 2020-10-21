variable "region" {
  description = "AWS region in which to launch all AWS resources"
  type        = string
  default     = "ca-central-1"
}

variable "lock_table_name" {
  description = "Name of Terraform lock table"
  type        = string
  default     = "terraform_lock"
}

variable "state_bucket_name" {
  description = "Name of Terraform state bucket"
  type        = string
  default     = "cace1-tf-marc-orthos"
}
