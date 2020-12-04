# https://medium.com/@matzhouse/dynamic-dns-with-terraform-and-route53-3fafe7c68970

terraform {
  required_version = "~> 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.20.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "http" "myip" {
  url = var.dyndns_url
}

data "aws_route53_zone" "selected" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "home" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.record_name}.${var.hosted_zone_name}"
  type    = "A"
  ttl     = var.ttl
  records = [chomp(data.http.myip.body)]
}
