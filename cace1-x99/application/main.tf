/******************************************************************************
Setup
******************************************************************************/

terraform {
  # required version set by module
  backend "s3" {
    region         = "ca-central-1"
    bucket         = "cace1-tf-marc-orthos"
    key            = "x1/application/terraform.tfstate"
    encrypt        = true
    acl            = "private"
    dynamodb_table = "terraform_lock"
  }
}

provider "aws" {
  # required version set by module
  region = "${var.region}"
}

# To share output variables from other terraform stack layers

provider "terraform" {
  # required version set by module
}

# To build templated user_data.txt files

provider "template" {
  # required version set by module
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    region = "ca-central-1"
    bucket = "cace1-tf-marc-orthos"
    key    = "x1/network/terraform.tfstate"
  }
}
