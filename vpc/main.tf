# https://aws.amazon.com/blogs/aws/building-three-tier-architectures-with-security-groups/

terraform {
  required_version = "~> 0.13.4"
}

provider "aws" {
  version = "~> 3.11.0"
  region  = var.region
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones

/*
__   ___ __   ___
\ \ / / '_ \ / __|
 \ V /| |_) | (__
  \_/ | .__/ \___|
      |_|
*/

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  assign_generated_ipv6_cidr_block = true
  enable_classiclink               = false
# enable_classiclink_dns_support   = false      # ???
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"  # least spendy;  "dedicated"|"host"

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

data "aws_availability_zones" "available" {
  state = "available"
}

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
  count                           = var.how_many_azs
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(var.vpc_cidr_block, var.subnet_mask_offset, count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_mask_offset, count.index)
  availability_zone               = data.aws_availability_zones.available.names[count.index]
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
  count                           = var.how_many_azs
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(var.vpc_cidr_block, var.subnet_mask_offset, count.index + var.how_many_azs)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_mask_offset, count.index + var.how_many_azs)
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.basename}-sub-priv-az${count.index}"
  }
}

/*
           _                           _
 ___ _   _| |__        _ __  _ __ ___ | |_
/ __| | | | '_ \ _____| '_ \| '__/ _ \| __|
\__ \ |_| | |_) |_____| |_) | | | (_) | |_
|___/\__,_|_.__/      | .__/|_|  \___/ \__|
                      |_|
*/

resource "aws_subnet" "protected_az" {
  count                           = var.how_many_azs
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(var.vpc_cidr_block, var.subnet_mask_offset, count.index + var.how_many_azs + var.how_many_azs)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_mask_offset, count.index + var.how_many_azs + var.how_many_azs)
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.basename}-sub-prot-az${count.index}"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway

# XXX FIXME TODO  Turn these on with a variable

# resource "aws_eip" "az" {
#   count      = var.enable_natgws ? var.how_many_azs : 0
#   vpc        = true
#   depends_on = ["aws_internet_gateway.public"]
#
#   tags = {
#     Name = "${var.basename}-eip"
#   }
# }

# resource "aws_nat_gateway" "az" {
#   count         = var.enable_natgws ? var.how_many_azs : 0
#   allocation_id = element(aws_eip.az.*.id, count.index)
#   subnet_id     = element(aws_subnet.public_az[*].id, count.index)
#   depends_on    = ["aws_internet_gateway.public"]
# }

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
  count          = var.how_many_azs
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public_az[*].id, count.index)
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
  count  = var.how_many_azs
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-rtb-priv-az${count.index}"
  }
}

resource "aws_route_table_association" "private_az" {
  count          = var.how_many_azs
  route_table_id = element(aws_route_table.private_az[*].id, count.index)
  subnet_id      = element(aws_subnet.private_az[*].id, count.index)
}

# XXX FIXME TODO  Turn these on with a variable

# resource "aws_route" "private_az_ipv4" {
#   count                  = var.enable_natgws ? var.how_many_azs : 0
#   route_table_id         = element(aws_route_table.private_az[*].id, count.index)
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = element(aws_nat_gateway.az[*].id, count.index)
# }

resource "aws_route" "private_az_ipv6" {
  count                       = var.how_many_azs
  route_table_id              = element(aws_route_table.private_az[*].id, count.index)
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.eigw.id
}

/*
      _   _                           _
 _ __| |_| |__        _ __  _ __ ___ | |_
| '__| __| '_ \ _____| '_ \| '__/ _ \| __|
| |  | |_| |_) |_____| |_) | | | (_) | |_
|_|   \__|_.__/      | .__/|_|  \___/ \__|
                     |_|
*/

resource "aws_route_table" "protected_az" {
  count  = var.how_many_azs
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-rtb-prot-az${count.index}"
  }
}

resource "aws_route_table_association" "protected_az" {
  count          = var.how_many_azs
  route_table_id = element(aws_route_table.protected_az[*].id, count.index)
  subnet_id      = element(aws_subnet.protected_az[*].id, count.index)
}
