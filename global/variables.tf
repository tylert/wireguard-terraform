/*
                 _       _     _
__   ____ _ _ __(_) __ _| |__ | | ___  ___
\ \ / / _` | '__| |/ _` | '_ \| |/ _ \/ __|
 \ V / (_| | |  | | (_| | |_) | |  __/\__ \
  \_/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
*/

variable "region" {
  type        = string
  description = "AWS region in which to launch all non-global resources"
# default     = "ca-central-1"
}

variable "lock_table_name" {
  type        = string
  description = "Name of Terraform lock table"
  default     = "terraform_lock"
}

variable "state_bucket_name" {
  type        = string
  description = "Name of Terraform state bucket"
  default     = "cace1-tf-marc-orthos"
}
