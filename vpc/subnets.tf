/*
           _                _
 ___ _   _| |__  _ __   ___| |_ ___
/ __| | | | '_ \| '_ \ / _ \ __/ __|
\__ \ |_| | |_) | | | |  __/ |_\__ \
|___/\__,_|_.__/|_| |_|\___|\__|___/
*/

# VPCs are currently limited to a maximum of /16 and a minimum of /28 for IPv4.
# Assigned IPv6 ranges are currently fixed at /56 for VPCs and /64 for subnets.
# We currently hard-code carving off 2^6 for each IPv4 subnet and 2^8 for each IPv6 subnet.
# /16 + 6 => /22 for IPv4, /56 + 8 => /64 for IPv6
# Subnet mask /16 => 2^(32-16) = 2^16 = 65536 hosts
# Subnet mask /22 => 2^(32-22) = 2^10 = 1024 hosts
# Subnet mask /28 => 2^(32-28) = 2^4  = 16 hosts

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

/*
                              _                       _
                    ___ _   _| |__        _ __  _   _| |__
                   / __| | | | '_ \ _____| '_ \| | | | '_ \
                   \__ \ |_| | |_) |_____| |_) | |_| | |_) |
                   |___/\__,_|_.__/      | .__/ \__,_|_.__/
                                         |_|
*/

resource "aws_subnet" "public_az" {
  count                           = var.how_many_azs
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(var.vpc_cidr_block, 6, count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
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
  cidr_block                      = cidrsubnet(var.vpc_cidr_block, 6, count.index + var.how_many_azs)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index + var.how_many_azs)
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.basename}-sub-priv-az${count.index}"
  }
}

/*
                                _
                      ___ _   _| |__        ___  ___  ___
                     / __| | | | '_ \ _____/ __|/ _ \/ __|
                     \__ \ |_| | |_) |_____\__ \  __/ (__
                     |___/\__,_|_.__/      |___/\___|\___|
*/

resource "aws_subnet" "secure_az" {
  count                           = var.how_many_azs
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(var.vpc_cidr_block, 6, count.index + var.how_many_azs + var.how_many_azs)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index + var.how_many_azs + var.how_many_azs)
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.basename}-sub-sec-az${count.index}"
  }
}
