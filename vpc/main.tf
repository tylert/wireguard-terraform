# https://aws.amazon.com/blogs/aws/building-three-tier-architectures-with-security-groups/

terraform {
  required_version = "~> 0.13.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.18.0"
    }
  }
}

provider "aws" {
  region = var.region
}

/*
__   ___ __   ___       ___ ___  _ __ ___
\ \ / / '_ \ / __|____ / __/ _ \| '__/ _ \
 \ V /| |_) | (_|_____| (_| (_) | | |  __/
  \_/ | .__/ \___|     \___\___/|_|  \___|
      |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones

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
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

/*
           _                       _
 ___ _   _| |__        _ __  _   _| |__
/ __| | | | '_ \ _____| '_ \| | | | '_ \
\__ \ |_| | |_) |_____| |_) | |_| | |_) |
|___/\__,_|_.__/      | .__/ \__,_|_.__/
                      |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

# VPCs are currently limited to a maximum of /16 and a minimum of /28 for IPv4
# Assigned IPv6 ranges are currently fixed at /56 for VPCs and /64 for subnets
# We currently hard-code carving off 2^6 for each IPv4 subnet and 2^8 for each IPv6 subnet
# /16 + 6 => /22 for IPv4, /56 + 8 => /64 for IPv6
# Subnet mask /16 => 2^(32-16) = 2^16 = 65536 hosts
# Subnet mask /22 => 2^(32-22) = 2^10 = 1024 hosts
# Subnet mask /28 => 2^(32-28) = 2^4  = 16 hosts

resource "aws_subnet" "pub_az" {
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

resource "aws_subnet" "priv_az" {
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

resource "aws_subnet" "sec_az" {
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

/*
      _   _               _       __
 _ __| |_| |__         __| | ___ / _|
| '__| __| '_ \ _____ / _` |/ _ \ |_
| |  | |_| |_) |_____| (_| |  __/  _|
|_|   \__|_.__/       \__,_|\___|_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table

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

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-rtb-pub"
  }
}

resource "aws_route_table_association" "pub_az" {
  count          = var.how_many_azs
  route_table_id = aws_route_table.pub.id
  subnet_id      = element(aws_subnet.pub_az[*].id, count.index)
}

/*
      _   _                      _
 _ __| |_| |__        _ __  _ __(_)_   __
| '__| __| '_ \ _____| '_ \| '__| \ \ / /
| |  | |_| |_) |_____| |_) | |  | |\ V /
|_|   \__|_.__/      | .__/|_|  |_| \_/
                     |_|
*/

resource "aws_route_table" "priv_az" {
  count  = var.how_many_azs
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-rtb-priv-az${count.index}"
  }
}

resource "aws_route_table_association" "priv_az" {
  count          = var.how_many_azs
  route_table_id = element(aws_route_table.priv_az[*].id, count.index)
  subnet_id      = element(aws_subnet.priv_az[*].id, count.index)
}

/*
      _   _
 _ __| |_| |__        ___  ___  ___
| '__| __| '_ \ _____/ __|/ _ \/ __|
| |  | |_| |_) |_____\__ \  __/ (__
|_|   \__|_.__/      |___/\___|\___|
*/

resource "aws_route_table" "sec_az" {
  count  = var.how_many_azs
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-rtb-sec-az${count.index}"
  }
}

resource "aws_route_table_association" "sec_az" {
  count          = var.how_many_azs
  route_table_id = element(aws_route_table.sec_az[*].id, count.index)
  subnet_id      = element(aws_subnet.sec_az[*].id, count.index)
}

/*
 _            _
(_)_ __   ___| |_       __ ___      _____
| | '_ \ / _ \ __|____ / _` \ \ /\ / / __|
| | | | |  __/ ||_____| (_| |\ V  V /\__ \
|_|_| |_|\___|\__|     \__, | \_/\_/ |___/
                       |___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route

resource "aws_internet_gateway" "pub" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-igw"
  }
}

resource "aws_route" "pub_ipv4" {
  route_table_id         = aws_route_table.pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.pub.id
}

resource "aws_route" "pub_ipv6" {
  route_table_id              = aws_route_table.pub.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.pub.id
}

/*
             _
 _ __   __ _| |_       __ ___      _____
| '_ \ / _` | __|____ / _` \ \ /\ / / __|
| | | | (_| | ||_____| (_| |\ V  V /\__ \
|_| |_|\__,_|\__|     \__, | \_/\_/ |___/
                      |___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway

# EIP may require IGW to exist prior to association.  Use depends_on to set an
# explicit dependency on the IGW.

# Do not use network_interface to associate the EIP to aws_lb or
# aws_nat_gateway resources.  Instead use the allocation_id available in those
# resources to allow AWS to manage the association, otherwise you will see
# AuthFailure errors.

resource "aws_eip" "natgw" {
  count      = var.how_many_natgws
  vpc        = true
  depends_on = [aws_internet_gateway.pub]

  tags = {
    Name = "${var.basename}-eip-natgw-az${count.index}"
  }
}

resource "aws_nat_gateway" "az" {
  count         = var.how_many_natgws
  allocation_id = element(aws_eip.az.*.id, count.index)
  subnet_id     = element(aws_subnet.pub_az[*].id, count.index)
  depends_on    = [aws_internet_gateway.pub]

  tags = {
    Name = "${var.basename}-natgw-az${count.index}"
  }
}

resource "aws_route" "priv_az_ipv4" {
  count                  = var.how_many_natgws
  route_table_id         = element(aws_route_table.priv_az[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.az[*].id, count.index)
}

/*
             _        _           _
 _ __   __ _| |_     (_)_ __  ___| |_ __ _ _ __   ___ ___  ___
| '_ \ / _` | __|____| | '_ \/ __| __/ _` | '_ \ / __/ _ \/ __|
| | | | (_| | ||_____| | | | \__ \ || (_| | | | | (_|  __/\__ \
|_| |_|\__,_|\__|    |_|_| |_|___/\__\__,_|_| |_|\___\___||___/
*/

# resource "aws_eip" "natinst" {
#   count      = var.how_many_natinsts
#   vpc        = true
#   depends_on = [aws_internet_gateway.pub]

#   tags = {
#     Name = "${var.basename}-eip-natinst-az${count.index}"
#   }
# }

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"]  # Canonical
# }

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

# resource "aws_instance" "natinst" {
#   user_data = <<-EOF
#               EOF
# }

/*
      _
  ___(_) __ ___      __
 / _ \ |/ _` \ \ /\ / /
|  __/ | (_| |\ V  V /
 \___|_|\__, | \_/\_/
        |___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway

resource "aws_egress_only_internet_gateway" "priv" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-eigw"
  }
}

resource "aws_route" "priv_az_ipv6" {
  count                       = var.how_many_azs
  route_table_id              = element(aws_route_table.priv_az[*].id, count.index)
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.priv.id
}
