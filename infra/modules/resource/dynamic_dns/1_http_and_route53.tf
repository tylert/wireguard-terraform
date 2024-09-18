/*
 _     _   _            ___                     _       ____ _____
| |__ | |_| |_ _ __    ( _ )    _ __ ___  _   _| |_ ___| ___|___ /
| '_ \| __| __| '_ \   / _ \/\ | '__/ _ \| | | | __/ _ \___ \ |_ \
| | | | |_| |_| |_) | | (_>  < | | | (_) | |_| | ||  __/___) |__) |
|_| |_|\__|\__| .__/   \___/\/ |_|  \___/ \__,_|\__\___|____/____/
              |_|
*/

# https://medium.com/@matzhouse/dynamic-dns-with-terraform-and-route53-3fafe7c68970

# https://search.opentofu.org/provider/opentofu/http/latest/docs/datasources/http
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/datasources/route53_zone
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/route53_record

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
