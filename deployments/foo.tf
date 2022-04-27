# terraform {
#   backend "s3" {
#     acl            = "private"
#     bucket         = "tf-armpit1-01067f59-6ffc-5a5c-b5e2-b50d87d7ae3d"
#     dynamodb_table = "tf-armpit1-01067f59-6ffc-5a5c-b5e2-b50d87d7ae3d"
#     encrypt        = true
#     key            = "armpit1/terraform.tfstate"
#     region         = "ca-central-1"
#   }
# }

variable "aws_region" {
  type        = string
  description = "AWS region in which to launch all non-global resources"
  # There should be no default for this variable.
}

provider "aws" {
  region = var.aws_region
}
