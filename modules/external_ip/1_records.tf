/*
                            _
 _ __ ___  ___ ___  _ __ __| |___
| '__/ _ \/ __/ _ \| '__/ _` / __|
| | |  __/ (_| (_) | | | (_| \__ \
|_|  \___|\___\___/|_|  \__,_|___/
*/

# https://medium.com/@matzhouse/dynamic-dns-with-terraform-and-route53-3fafe7c68970

# https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record

data "http" "myip" {
  url = var.dyndns_url
}

data "aws_route53_zone" "selected" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "myip" {
  zone_id         = data.aws_route53_zone.selected.zone_id
  name            = "${var.record_name}.${var.hosted_zone_name}"
  type            = "A"
  ttl             = var.ttl
  records         = [chomp(data.http.myip.body)]
  allow_overwrite = true
}
