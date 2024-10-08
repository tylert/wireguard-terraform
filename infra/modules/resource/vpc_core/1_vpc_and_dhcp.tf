/*
                     ___         _ _
__   ___ __   ___   ( _ )     __| | |__   ___ _ __
\ \ / / '_ \ / __|  / _ \/\  / _` | '_ \ / __| '_ \
 \ V /| |_) | (__  | (_>  < | (_| | | | | (__| |_) |
  \_/ | .__/ \___|  \___/\/  \__,_|_| |_|\___| .__/
      |_|                                    |_|
*/

# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/vpc
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/vpc_dhcp_options
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/vpc_dhcp_options_association
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-dhcp-options.html

resource "aws_vpc" "main" {
  cidr_block = var.use_ipam ? null : var.vpc_ipv4_cidr_block

  assign_generated_ipv6_cidr_block     = var.enable_ipv6 && !var.use_ipam ? true : null
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = var.vpc_instance_tenancy

  tags = {
    Name = "vpc-${var.basename}"
  }
}

# Unless you're doing really fancy stuff in DNS, just take the defaults
# if us-east-1 then "ec2.internal", if other region then "$AWS_REGION.compute.internal"

# XXX FIXME TODO  https://github.com/hashicorp/terraform-provider-aws/issues/21708
# Duplicate dopt gets created that requires manual cleanup after destroy

resource "aws_vpc_dhcp_options" "main" {
  domain_name         = "us-east-1" == data.aws_region.current.name ? "ec2.internal" : "${data.aws_region.current.name}.compute.internal"
  domain_name_servers = var.dns_servers
  ntp_servers         = var.ntp_servers
  # netbios_name_servers = [] # what would Linux even do with this???
  # netbios_node_type    = 2 # what would Linux even do with this???

  tags = {
    Name = "dopt-${var.basename}"
  }
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}
