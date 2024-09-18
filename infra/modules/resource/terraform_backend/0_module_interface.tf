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
# https://registry.terraform.io/providers/hashicorp/aws/latest

terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "registry.opentofu.org/hashicorp/aws"
      version = ">= 5.0.0, < 6.0.0"
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

variable "basename" {
  type        = string
  description = "Tag substring to use for all related resources (e.g.:  test1)"
  # There should be no default for this variable.
}

/*
             _               _
  ___  _   _| |_ _ __  _   _| |_ ___
 / _ \| | | | __| '_ \| | | | __/ __|
| (_) | |_| | |_| |_) | |_| | |_\__ \
 \___/ \__,_|\__| .__/ \__,_|\__|___/
                |_|
*/

output "lock_table_name" {
  value = aws_dynamodb_table.tf_lock.id
}

output "state_bucket_name" {
  value = aws_s3_bucket.tf_state.id
}
