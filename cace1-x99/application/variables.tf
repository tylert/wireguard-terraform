/******************************************************************************
Input Variables
******************************************************************************/

variable "region" {
  description = "AWS region in which to launch all AWS resources"
  default     = "ca-central-1"
}

variable "basename" {
  description = "Basename tag value to use for all AWS resources"
  default     = "x99"
}
