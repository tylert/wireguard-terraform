# terraform {
#   backend "s3" {
#     acl            = "private"
#     bucket         = "tf-armpit1-8LwmPcDsT1e2MuxceZN6x"
#     dynamodb_table = "tf-armpit1-8LwmPcDsT1e2MuxceZN6x"
#     encrypt        = true
#     key            = "dev/terraform.tfstate"
#     region         = "ca-central-1"
#   }
# }

provider "aws" {
  region = "us-east-1"
}

module "vpc_core1" {
  source                 = "../../modules/aws/vpc_core"
  basename               = "tyler1"
  vpc_ipv4_cidr_block    = "10.4.0.0/16"
  preserve_default_rules = false
  flow_logs_enabled      = true
  # how_many_nats          = 1
}

module "vpc_rules1" {
  source              = "../../modules/aws/vpc_rules"
  basename            = "tyler1"
  external_ipv4_addrs = ["100.100.100.100/32"]
  external_ipv6_addrs = []
  depends_on          = [module.vpc_core1]
}

# Show an example of doing something in more than a single region
# https://developer.hashicorp.com/terraform/language/modules/develop/providers

provider "aws" {
  region = "us-east-2"
  alias  = "second"
}

module "vpc_core2" {
  source                 = "../../modules/aws/vpc_core"
  basename               = "tyler2"
  vpc_ipv4_cidr_block    = "10.5.0.0/16"
  preserve_default_rules = false
  flow_logs_enabled      = true
  # how_many_nats          = 1

  providers = {
    aws = aws.second
  }
}

module "vpc_rules2" {
  source              = "../../modules/aws/vpc_rules"
  basename            = "tyler2"
  external_ipv4_addrs = ["100.100.100.100/32"]
  external_ipv6_addrs = []
  depends_on          = [module.vpc_core2]

  providers = {
    aws = aws.second
  }
}
