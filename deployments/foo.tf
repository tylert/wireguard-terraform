# terraform {
#   backend "s3" {
#     acl            = "private"
#     bucket         = "s3-armpit1-tfstate-01067f59-6ffc-5a5c-b5e2-b50d87d7ae3d"
#     dynamodb_table = "dydb-armpit1-tflock-01067f59-6ffc-5a5c-b5e2-b50d87d7ae3d"
#     encrypt        = true
#     key            = "armpit1/terraform.tfstate"
#     region         = "ca-central-1"
#   }
# }

provider "aws" {
  region = var.aws_region
}
