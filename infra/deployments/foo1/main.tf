# terraform {
#   backend "s3" {
#     acl            = "private"
#     bucket         = "tf-armpit1-8LwmPcDsT1e2MuxceZN6x"
#     dynamodb_table = "tf-armpit1-8LwmPcDsT1e2MuxceZN6x"
#     encrypt        = true
#     key            = "foo1/terraform.tfstate"
#     region         = "ca-central-1"
#   }
# }

provider "aws" {
  region = "us-east-1"
}

module "vpc_core" {
  source                 = "../../modules/aws/vpc_core"
  basename               = "foo1"
  flow_logs_enabled      = true
  preserve_default_rules = false
  vpc_ipv4_cidr_block    = "10.4.0.0/24"
}
