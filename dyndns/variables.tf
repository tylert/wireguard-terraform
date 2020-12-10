variable "region" {
  type        = string
  description = "AWS region in which to launch all non-global resources"
  default     = "ca-central-1"
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
