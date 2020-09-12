/******************************************************************************
Setup
******************************************************************************/

terraform {
  # required version set by module
  backend "s3" {
    region         = "ca-central-1"
    bucket         = "cace1-tf-marc-orthos"
    key            = "x99/network/terraform.tfstate"
    encrypt        = true
    acl            = "private"
    dynamodb_table = "terraform_lock"
  }
}

provider "aws" {
  # required version set by module
  region = "${var.region}"
}

module "vpc" {
  source = "git::git@github.com:tylert/tfmods-aws//vpc?ref=0.1.0"

  region          = "${var.region}"
  basename        = "${var.basename}"
  vpc_cidr_block  = "${var.vpc_cidr_block}"
  span_azs        = "${var.span_azs}"
  enable_natgws   = "${var.enable_natgws}"
  enable_bastions = "${var.enable_bastions}"
}
