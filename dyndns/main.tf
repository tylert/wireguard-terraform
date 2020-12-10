terraform {
  required_version = "~> 0.14.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.20.0"
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
