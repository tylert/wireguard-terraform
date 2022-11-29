terraform {
  backend "s3" {
    acl            = "private"
    bucket         = "tf-armpit1-8LwmPcDsT1e2MuxceZN6x"
    dynamodb_table = "tf-armpit1-8LwmPcDsT1e2MuxceZN6x"
    encrypt        = true
    key            = "armpit1/terraform.tfstate"
    region         = "ca-central-1"
  }
}

provider "aws" {
  region = "ca-central-1"
}

# basename = "armpit1"
