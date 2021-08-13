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

variable "dyndns_url" {
  type        = string
  description = ""
  default     = "https://icanhazip.com" # https://ip.me
}

variable "hosted_zone_name" {
  type        = string
  description = "Name of domain to update (e.g.:  example.com)"
  # there should be no default for this variable
}

variable "record_name" {
  type        = string
  description = "Name of record to update (e.g.:  m0)"
  # there should be no default for this variable
}

variable "ttl" {
  type        = number
  description = "The TTL to set for the A record"
  default     = 1800
}
