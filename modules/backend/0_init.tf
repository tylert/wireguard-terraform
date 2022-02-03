/*
 _       _ _
(_)_ __ (_) |_
| | '_ \| | __|
| | | | | | |_
|_|_| |_|_|\__|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest

terraform {
  required_version = ">= 1.1.5, < 1.2.0"

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = ">= 3.74.0, < 4.0.0"
    }
  }
}
