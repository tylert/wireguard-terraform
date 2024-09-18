/*
          _
 ___  ___| |_ _   _ _ __
/ __|/ _ \ __| | | | '_ \
\__ \  __/ |_| |_| | |_) |
|___/\___|\__|\__,_| .__/
                   |_|
*/

# https://github.com/opentofu/opentofu/releases
# https://github.com/opentofu/terraform-provider-aws/releases
# https://github.com/opentofu/terraform-provider-http/releases
# https://search.opentofu.org/provider/opentofu/aws/latest
# https://search.opentofu.org/provider/opentofu/http/latest

terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "registry.opentofu.org/opentofu/aws"
      version = ">= 5.0.0, < 6.0.0"
    }
    http = {
      source  = "registry.opentofu.org/opentofu/http"
      version = ">= 3.0.0, < 4.0.0"
    }
  }
}

# https://search.opentofu.org/provider/opentofu/aws/latest/docs/datasources/caller_identity
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/datasources/region
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/datasources/availability_zones

data "aws_caller_identity" "current" {} # aws_account_id

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

/*
 _                   _
(_)_ __  _ __  _   _| |_ ___
| | '_ \| '_ \| | | | __/ __|
| | | | | |_) | |_| | |_\__ \
|_|_| |_| .__/ \__,_|\__|___/
        |_|
*/

variable "dyndns_url" {
  type        = string
  description = ""
  default     = "https://icanhazip.com" # https://ip.me
}

variable "hosted_zone_name" {
  type        = string
  description = "Name of domain to update (e.g.:  example.com)"
  # There should be no default for this variable.
}

variable "record_name" {
  type        = string
  description = "Name of record to update (e.g.:  m0)"
  # There should be no default for this variable.
}

variable "ttl" {
  type        = number
  description = "The TTL to set for the A record"
  default     = 1800
}

/*
             _               _
  ___  _   _| |_ _ __  _   _| |_ ___
 / _ \| | | | __| '_ \| | | | __/ __|
| (_) | |_| | |_| |_) | |_| | |_\__ \
 \___/ \__,_|\__| .__/ \__,_|\__|___/
                |_|
*/

output "myip" {
  value = chomp(data.http.myip.body)
}
