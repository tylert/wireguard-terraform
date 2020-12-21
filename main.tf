/*
                 _
 _ __ ___   __ _(_)_ __
| '_ ` _ \ / _` | | '_ \
| | | | | | (_| | | | | |
|_| |_| |_|\__,_|_|_| |_|
*/

terraform {
  required_version = "~> 0.14.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.22.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 2.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}
