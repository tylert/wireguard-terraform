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

variable "tf_lock_table_name" {
  type        = string
  description = "Name of Terraform lock table"
  default     = "terraform_lock"
}

variable "tf_state_bucket_name" {
  type        = string
  description = "Name of Terraform state bucket"
  default     = "froopyland_state_bucket"
}
