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
