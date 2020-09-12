# https://aws.amazon.com/blogs/aws/building-three-tier-architectures-with-security-groups/

/*
*/

terraform {
  required_version = "~> 0.13.2"
}

provider "aws" {
  version = "~> 1.57.0"
  region  = "${var.region}"
}

# To build templated user_data.txt files

/*
provider "template" {
  version = "~> 2.0.0"
}
*/

# https://www.terraform.io/docs/providers/aws/r/vpc.html
# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
# https://www.terraform.io/docs/providers/aws/r/egress_only_internet_gateway.html
# https://www.terraform.io/docs/providers/aws/r/vpc_dhcp_options.html
# https://www.terraform.io/docs/providers/aws/r/vpc_dhcp_options_association.html
# https://www.terraform.io/docs/providers/aws/d/availability_zones.html

/*
__   ___ __   ___
\ \ / / '_ \ / __|
 \ V /| |_) | (__
  \_/ | .__/ \___|
      |_|
*/

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"

  assign_generated_ipv6_cidr_block = true
  enable_classiclink               = false
# enable_classiclink_dns_support   = false      # ???
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"  # least spendy

  tags = {
    Name = "${var.basename}-vpc"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-igw"
  }
}

resource "aws_egress_only_internet_gateway" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-eigw"
  }
}

resource "aws_vpc_dhcp_options" "main" {
  domain_name         = "${var.region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
# ntp_servers         = []

  tags = {
    Name = "${var.basename}-dopt"
  }
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.domain_name.id
}

data "aws_availability_zones" "all" {}

# https://www.terraform.io/docs/providers/aws/r/eip.html
# https://www.terraform.io/docs/providers/aws/r/nat_gateway.html

# resource "aws_eip" "az" {
#   count      = "${var.enable_natgws ? var.span_azs : 0}"
#   vpc        = true
#   depends_on = ["aws_internet_gateway.public"]
#
#   tags = {
#     Name = "${var.basename}-eip"
#   }
# }


# resource "aws_nat_gateway" "az" {
#   count         = "${var.enable_natgws ? var.span_azs : 0}"
#   allocation_id = "${element(aws_eip.az.*.id, count.index)}"
#   subnet_id     = "${element(aws_subnet.public_az.*.id, count.index)}"
#   depends_on    = ["aws_internet_gateway.public"]
# }

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

/*
           _                       _
 ___ _   _| |__        _ __  _   _| |__
/ __| | | | '_ \ _____| '_ \| | | | '_ \
\__ \ |_| | |_) |_____| |_) | |_| | |_) |
|___/\__,_|_.__/      | .__/ \__,_|_.__/
                      |_|
*/

# VPC netmask size + subnet_mask_offset = new subnet netmask

resource "aws_subnet" "public_az" {
  count                           = "${var.span_azs}"
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = "${cidrsubnet(var.vpc_cidr_block, var.subnet_mask_offset, count.index)}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_mask_offset, count.index)}"
  availability_zone               = "${data.aws_availability_zones.all.names[count.index]}"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.basename}-sub-pub-az${count.index}"
  }
}

/*
           _                      _
 ___ _   _| |__        _ __  _ __(_)_   __
/ __| | | | '_ \ _____| '_ \| '__| \ \ / /
\__ \ |_| | |_) |_____| |_) | |  | |\ V /
|___/\__,_|_.__/      | .__/|_|  |_| \_/
                      |_|
*/

resource "aws_subnet" "private_az" {
  count                           = "${var.span_azs}"
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = "${cidrsubnet(var.vpc_cidr_block, var.subnet_mask_offset, var.span_azs + var.span_azs + count.index)}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_mask_offset, var.span_azs + var.span_azs + count.index)}"
  availability_zone               = "${data.aws_availability_zones.all.names[count.index]}"
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.basename}-sub-priv-az${count.index}"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route

/*
      _   _               _       __
 _ __| |_| |__         __| | ___ / _|
| '__| __| '_ \ _____ / _` |/ _ \ |_
| |  | |_| |_) |_____| (_| |  __/  _|
|_|   \__|_.__/       \__,_|\___|_|
*/

# Creating a new VPC forces the creation of a new default route table.
# We want to tag it with something that indicates which VPC it belongs to.
# We will simply ignore this resource as it is not required for our use case.

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "${var.basename}-rtb-def"
  }
}

/*
      _   _                       _
 _ __| |_| |__        _ __  _   _| |__
| '__| __| '_ \ _____| '_ \| | | | '_ \
| |  | |_| |_) |_____| |_) | |_| | |_) |
|_|   \__|_.__/      | .__/ \__,_|_.__/
                     |_|
*/

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-rtb-pub"
  }
}

resource "aws_route_table_association" "public_az" {
  count          = "${var.span_azs}"
  route_table_id = aws_route_table.public.id
  subnet_id      = "${element(aws_subnet.public_az.*.id, count.index)}"
}

resource "aws_route" "public_ipv4" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}

resource "aws_route" "public_ipv6" {
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.public.id
}

/*
      _   _                      _
 _ __| |_| |__        _ __  _ __(_)_   __
| '__| __| '_ \ _____| '_ \| '__| \ \ / /
| |  | |_| |_) |_____| |_) | |  | |\ V /
|_|   \__|_.__/      | .__/|_|  |_| \_/
                     |_|
*/

resource "aws_route_table" "private_az" {
  count  = "${var.span_azs}"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-rtb-priv-az${count.index}"
  }
}

resource "aws_route_table_association" "private_az" {
  count          = "${var.span_azs}"
  route_table_id = "${element(aws_route_table.private_az.*.id, count.index)}"
  subnet_id      = "${element(aws_subnet.private_az.*.id, count.index)}"
}

# resource "aws_route" "private_az_ipv4" {
#   count                  = "${var.span_azs}"
#   route_table_id         = "${element(aws_route_table.private_az.*.id, count.index)}"
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = "${element(aws_nat_gateway.az.*.id, count.index)}"
# }

resource "aws_route" "private_az_ipv6" {
  count                       = "${var.span_azs}"
  route_table_id              = "${element(aws_route_table.private_az.*.id, count.index)}"
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.eigw.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule

/*
            _           _       __
  __ _  ___| |       __| | ___ / _|
 / _` |/ __| |_____ / _` |/ _ \ |_
| (_| | (__| |_____| (_| |  __/  _|
 \__,_|\___|_|      \__,_|\___|_|
*/

# Creating a new VPC forces the creation of a new default NACL.
# We want to tag it with something that indicates which VPC it belongs to.
# However, when you try to tag it with Terraform, the rules get flushed.
# Just put back the rules that got flushed so we're left with a stock one.
# We will simply ignore this resource as it is not required for our use case.

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  ingress {
    from_port  = "0"
    to_port    = "0"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    rule_no    = "100"
    action     = "allow"
  }

  ingress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    ipv6_cidr_block = "::/0"
    rule_no         = "101"
    action          = "allow"
  }

  egress {
    from_port  = "0"
    to_port    = "0"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    rule_no    = "100"
    action     = "allow"
  }

  egress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    ipv6_cidr_block = "::/0"
    rule_no         = "101"
    action          = "allow"
  }

  tags = {
    Name = "${var.basename}-acl-def"
  }
}

/*
            _                   _
  __ _  ___| |      _ __  _   _| |__
 / _` |/ __| |_____| '_ \| | | | '_ \
| (_| | (__| |_____| |_) | |_| | |_) |
 \__,_|\___|_|     | .__/ \__,_|_.__/
                   |_|
*/

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = ["${aws_subnet.public_az.*.id}"]

  tags = {
    Name = "${var.basename}-acl-pub"
  }
}

resource "aws_network_acl_rule" "pub_in_vpc_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "1000"
  cidr_block     = aws_vpc.main.cidr_block
  egress         = false
  protocol       = "-1"
  from_port      = "0"
  to_port        = "0"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "pub_in_vpc_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "1001"
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
  egress          = false
  protocol        = "-1"
  from_port       = "0"
  to_port         = "0"
  rule_action     = "allow"
}

resource "aws_network_acl_rule" "pub_in_tcp_ephem_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "1100"
  cidr_block     = "0.0.0.0/0"
  egress         = false
  protocol       = "tcp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "pub_in_tcp_ephem_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "1101"
  ipv6_cidr_block = "::/0"
  egress          = false
  protocol        = "tcp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
}

resource "aws_network_acl_rule" "pub_in_udp_ephem_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "1200"
  cidr_block     = "0.0.0.0/0"
  egress         = false
  protocol       = "udp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "pub_in_udp_ephem_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "1201"
  ipv6_cidr_block = "::/0"
  egress          = false
  protocol        = "udp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
}

resource "aws_network_acl_rule" "pub_in_tcp_https_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "1300"
  cidr_block     = "0.0.0.0/0"
  egress         = false
  protocol       = "tcp"
  from_port      = "443"
  to_port        = "443"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "pub_in_tcp_https_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "1301"
  ipv6_cidr_block = "::/0"
  egress          = false
  protocol        = "tcp"
  from_port       = "443"
  to_port         = "443"
  rule_action     = "allow"
}

resource "aws_network_acl_rule" "pub_out_vpc_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "2000"
  cidr_block     = aws_vpc.main.cidr_block
  egress         = true
  protocol       = "-1"
  from_port      = "0"
  to_port        = "0"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "pub_opt_vpc_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "2001"
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
  egress          = true
  protocol        = "-1"
  from_port       = "0"
  to_port         = "0"
  rule_action     = "allow"
}

resource "aws_network_acl_rule" "pub_out_tcp_ephem_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "2100"
  cidr_block     = "0.0.0.0/0"
  egress         = true
  protocol       = "tcp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "pub_out_tcp_ephem_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "2101"
  ipv6_cidr_block = "::/0"
  egress          = true
  protocol        = "tcp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
}

resource "aws_network_acl_rule" "pub_out_udp_ephem_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "2200"
  cidr_block     = "0.0.0.0/0"
  egress         = true
  protocol       = "udp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "pub_out_udp_ephem_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "2201"
  ipv6_cidr_block = "::/0"
  egress          = true
  protocol        = "udp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
}

resource "aws_network_acl_rule" "pub_out_tcp_https_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "2300"
  cidr_block     = "0.0.0.0/0"
  egress         = true
  protocol       = "tcp"
  from_port      = "443"
  to_port        = "443"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "pub_out_tcp_https_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "2301"
  ipv6_cidr_block = "::/0"
  egress          = true
  protocol        = "tcp"
  from_port       = "443"
  to_port         = "443"
  rule_action     = "allow"
}

/*
            _                  _
  __ _  ___| |      _ __  _ __(_)_   __
 / _` |/ __| |_____| '_ \| '__| \ \ / /
| (_| | (__| |_____| |_) | |  | |\ V /
 \__,_|\___|_|     | .__/|_|  |_| \_/
                   |_|
*/

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = ["${aws_subnet.private_az.*.id}"]

  tags = {
    Name = "${var.basename}-acl-priv"
  }
}

resource "aws_network_acl_rule" "priv_in_vpc_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "3000"
  cidr_block     = aws_vpc.main.cidr_block
  egress         = false
  protocol       = "-1"
  from_port      = "0"
  to_port        = "0"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "priv_in_vpc_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "3001"
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
  egress          = false
  protocol        = "-1"
  from_port       = "0"
  to_port         = "0"
  rule_action     = "allow"
}

resource "aws_network_acl_rule" "priv_in_tcp_ephem_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "3100"
  cidr_block     = "0.0.0.0/0"
  egress         = false
  protocol       = "tcp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "priv_in_tcp_ephem_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "3101"
  ipv6_cidr_block = "::/0"
  egress          = false
  protocol        = "tcp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
}

resource "aws_network_acl_rule" "priv_in_udp_ephem_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "3200"
  cidr_block     = "0.0.0.0/0"
  egress         = false
  protocol       = "udp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "priv_in_udp_ephem_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "3201"
  ipv6_cidr_block = "::/0"
  egress          = false
  protocol        = "udp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
}

resource "aws_network_acl_rule" "priv_out_vpc_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "4000"
  cidr_block     = aws_vpc.main.cidr_block
  egress         = true
  protocol       = "-1"
  from_port      = "0"
  to_port        = "0"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "priv_out_vpc_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "4001"
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
  egress          = true
  protocol        = "-1"
  from_port       = "0"
  to_port         = "0"
  rule_action     = "allow"
}

resource "aws_network_acl_rule" "priv_out_tcp_ephem_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "4100"
  cidr_block     = "0.0.0.0/0"
  egress         = true
  protocol       = "tcp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "priv_out_tcp_ephem_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "4101"
  ipv6_cidr_block = "::/0"
  egress          = true
  protocol        = "tcp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
}

resource "aws_network_acl_rule" "priv_out_udp_ephem_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "4200"
  cidr_block     = "0.0.0.0/0"
  egress         = true
  protocol       = "udp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "priv_out_udp_ephem_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "4201"
  ipv6_cidr_block = "::/0"
  egress          = true
  protocol        = "udp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

/*
                     _       __
 ___  __ _        __| | ___ / _|
/ __|/ _` |_____ / _` |/ _ \ |_
\__ \ (_| |_____| (_| |  __/  _|
|___/\__, |      \__,_|\___|_|
     |___/
*/

# Creating a new VPC forces the creation of a new default SG.
# We want to tag it with something that indicates which VPC it belongs to.
# However, when you try to tag it with Terraform, the rules get flushed.
# Just put back the rules that got flushed so we're left with a stock one.
# We will simply ignore this resource as it is not required for our use case.

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = "0"
    to_port          = "0"
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.basename}-sg-def"
  }
}

/*
                             _
 ___  __ _       _ __  _   _| |__
/ __|/ _` |_____| '_ \| | | | '_ \
\__ \ (_| |_____| |_) | |_| | |_) |
|___/\__, |     | .__/ \__,_|_.__/
     |___/      |_|
*/

resource "aws_security_group" "public" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.basename}-sg-pub" # Group Name / supports name_prefix
  description = "${var.basename}-sg-pub"

  tags = {
    Name = "${var.basename}-sg-pub"
  }
}

resource "aws_security_group_rule" "ingress_public" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  self              = true
}

resource "aws_security_group_rule" "egress_public_ipv4" {
  security_group_id = aws_security_group.public.id
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_public_ipv6" {
  security_group_id = aws_security_group.public.id
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
}

/*
                            _
 ___  __ _       _ __  _ __(_)_   __
/ __|/ _` |_____| '_ \| '__| \ \ / /
\__ \ (_| |_____| |_) | |  | |\ V /
|___/\__, |     | .__/|_|  |_| \_/
     |___/      |_|
*/

resource "aws_security_group" "private" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.basename}-sg-priv" # Group Name / supports name_prefix
  description = "${var.basename}-sg-priv"

  tags = {
    Name = "${var.basename}-sg-priv"
  }
}

resource "aws_security_group_rule" "ingress_private" {
  security_group_id        = aws_security_group.private.id
  type                     = "ingress"
  from_port                = "0"
  to_port                  = "0"
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.public.id}"
}

resource "aws_security_group_rule" "egress_private_ipv4" {
  security_group_id = aws_security_group.private.id
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_private_ipv6" {
  security_group_id = aws_security_group.private.id
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
}

/*
                         _
 ___  __ _       ___ ___| |__
/ __|/ _` |_____/ __/ __| '_ \
\__ \ (_| |_____\__ \__ \ | | |
|___/\__, |     |___/___/_| |_|
     |___/
*/

resource "aws_security_group" "ssh" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.basename}-sg-ssh" # Group Name / supports name_prefix
  description = "${var.basename}-sg-ssh"

  tags = {
    Name = "${var.basename}-sg-ssh"
  }
}

resource "aws_security_group_rule" "ingress_ssh_ipv4" {
  security_group_id = aws_security_group.ssh.id
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_ssh_ipv6" {
  security_group_id = aws_security_group.ssh.id
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "egress_ssh_ipv4" {
  security_group_id = aws_security_group.ssh.id
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_ssh_ipv6" {
  security_group_id = aws_security_group.ssh.id
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
}

/******************************************************************************
SSH Bastion Hosts
******************************************************************************/

/*
data "template_file" "user_data" {
  template = "${file("user_data.txt")}"

  vars {
    foo = "${var.foo}"
  }
}
*/

# https://www.terraform.io/docs/providers/aws/r/instance.html

resource "aws_instance" "public_bastion_az" {
  count                  = "${var.enable_bastions ? var.span_azs : 0}"
  instance_type          = "t2.micro"
  ami                    = "${var.bastion_ami}"
  availability_zone      = "${data.aws_availability_zones.all.names[count.index]}"
  subnet_id              = "${element(aws_subnet.public_az.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}", "${aws_security_group.public.id}"]
  user_data              = "${file("user_data.txt")}"
  tenancy                = "default"
  ipv6_address_count     = "1"

  # user_data            = "${data.template_file.user_data.rendered}"
  # iam_instance_profile = "XXX FIXME XXX"

  connection {
    user = "${var.bastion_user}"
  }
  tags = {
    Name = "${var.basename}-bast-az${count.index}-pub"
  }
}
