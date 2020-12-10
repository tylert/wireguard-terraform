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

variable "ttl" {
  type        = number
  description = "The TTL to set for the A record"
  default     = 1800
}

variable "hosted_zone_name" {
  type        = string
  description = ""
# default     = "example.com"
}

variable "dyndns_url" {
  type        = string
  description = ""
  default     = "https://icanhazip.com"
}

variable "record_name" {
  type        = string
  description = ""
  default     = "m0"
}
