/*
          _
 ___  ___| |_ _   _ _ __
/ __|/ _ \ __| | | | '_ \
\__ \  __/ |_| |_| | |_) |
|___/\___|\__|\__,_| .__/
                   |_|
*/

# https://releases.hashicorp.com/terraform
# https://releases.hashicorp.com/terraform-provider-aws
# https://releases.hashicorp.com/terraform-provider-http
# https://registry.terraform.io/providers/hashicorp/aws/latest
# https://registry.terraform.io/providers/hashicorp/http/latest

terraform {
  required_version = ">= 1.0.0, < 1.6.0"

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = ">= 5.0.0, < 6.0.0"
    }
    http = {
      source  = "registry.terraform.io/hashicorp/http"
      version = ">= 3.0.0, < 4.0.0"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones

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
