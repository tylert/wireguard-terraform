/*
           _                _
 ___ _   _| |__  _ __   ___| |_ ___
/ __| | | | '_ \| '_ \ / _ \ __/ __|
\__ \ |_| | |_) | | | |  __/ |_\__ \
|___/\__,_|_.__/|_| |_|\___|\__|___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# https://www.terraform.io/docs/configuration/functions/cidrsubnet.html

/*
                                       _     _ _
                           _ __  _   _| |__ | (_) ___
                          | '_ \| | | | '_ \| | |/ __|
                          | |_) | |_| | |_) | | | (__
                          | .__/ \__,_|_.__/|_|_|\___|
                          |_|
*/

resource "aws_subnet" "public_az" {
  count      = var.how_many_azs
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_ipv4_cidr_block, var.subnet_ipv4_cidr_bits, count.index)

  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_ipv6_cidr_bits, count.index)
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "subnet-${var.basename}-pub-az${count.index}"
  }
}

/*
                                   _            _
                        _ __  _ __(_)_   ____ _| |_ ___
                       | '_ \| '__| \ \ / / _` | __/ _ \
                       | |_) | |  | |\ V / (_| | ||  __/
                       | .__/|_|  |_| \_/ \__,_|\__\___|
                       |_|
*/

resource "aws_subnet" "private_az" {
  count      = var.how_many_azs
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_ipv4_cidr_block, var.subnet_ipv4_cidr_bits, count.index + var.how_many_azs)

  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_ipv6_cidr_bits, count.index + var.how_many_azs)
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "subnet-${var.basename}-priv-az${count.index}"
  }
}

/*
                          ___  ___  ___ _   _ _ __ ___
                         / __|/ _ \/ __| | | | '__/ _ \
                         \__ \  __/ (__| |_| | | |  __/
                         |___/\___|\___|\__,_|_|  \___|
*/

resource "aws_subnet" "secure_az" {
  count      = var.how_many_azs
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_ipv4_cidr_block, var.subnet_ipv4_cidr_bits, count.index + var.how_many_azs + var.how_many_azs)

  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, var.subnet_ipv6_cidr_bits, count.index + var.how_many_azs + var.how_many_azs)
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "subnet-${var.basename}-sec-az${count.index}"
  }
}
