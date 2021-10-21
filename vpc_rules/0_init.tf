/*
                      _     _
 _ __  _ __ _____   _(_) __| | ___ _ __ ___
| '_ \| '__/ _ \ \ / / |/ _` |/ _ \ '__/ __|
| |_) | | | (_) \ V /| | (_| |  __/ |  \__ \
| .__/|_|  \___/ \_/ |_|\__,_|\___|_|  |___/
|_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest

terraform {
  required_version = "~> 1.0.9"

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 3.63.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
