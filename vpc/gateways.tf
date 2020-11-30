/*
             _
  __ _  __ _| |_ _____      ____ _ _   _ ___
 / _` |/ _` | __/ _ \ \ /\ / / _` | | | / __|
| (_| | (_| | ||  __/\ V  V / (_| | |_| \__ \
 \__, |\__,_|\__\___| \_/\_/ \__,_|\__, |___/
 |___/                             |___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway

/*
                                _
                               (_) __ ___      __
                               | |/ _` \ \ /\ / /
                               | | (_| |\ V  V /
                               |_|\__, | \_/\_/
                                  |___/
*/

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-igw"
  }
}

resource "aws_route" "pub_ipv4" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}

resource "aws_route" "pub_ipv6" {
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.public.id
}

/*
                                  _
                              ___(_) __ ___      __
                             / _ \ |/ _` \ \ /\ / /
                            |  __/ | (_| |\ V  V /
                             \___|_|\__, | \_/\_/
                                    |___/
*/

resource "aws_egress_only_internet_gateway" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-eigw"
  }
}

resource "aws_route" "priv_az_ipv6" {
  count                       = var.how_many_azs
  route_table_id              = element(aws_route_table.private_az[*].id, count.index)
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.private.id
}

/*
                                _
                    _ __   __ _| |_       __ ___      _____
                   | '_ \ / _` | __|____ / _` \ \ /\ / / __|
                   | | | | (_| | ||_____| (_| |\ V  V /\__ \
                   |_| |_|\__,_|\__|     \__, | \_/\_/ |___/
                                         |___/
*/

# EIP may require IGW to exist prior to association.  Use depends_on to set an
# explicit dependency on the IGW.

# Do not use network_interface to associate the EIP to aws_lb or
# aws_nat_gateway resources.  Instead use the allocation_id available in those
# resources to allow AWS to manage the association, otherwise you will see
# AuthFailure errors.

resource "aws_eip" "natgw_az" {
  count      = var.how_many_natgws
  vpc        = true
  depends_on = [aws_internet_gateway.public]

  tags = {
    Name = "${var.basename}-eip-natgw-az${count.index}"
  }
}

resource "aws_nat_gateway" "az" {
  count         = var.how_many_natgws
  allocation_id = element(aws_eip.natgw_az[*].id, count.index)
  subnet_id     = element(aws_subnet.public_az[*].id, count.index)
  depends_on    = [aws_internet_gateway.public]

  tags = {
    Name = "${var.basename}-natgw-az${count.index}"
  }
}

resource "aws_route" "priv_az_ipv4" {
  count                  = var.how_many_natgws
  route_table_id         = element(aws_route_table.private_az[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.az[*].id, count.index)
}

/*
                                _        _           _
                    _ __   __ _| |_     (_)_ __  ___| |_ ___
                   | '_ \ / _` | __|____| | '_ \/ __| __/ __|
                   | | | | (_| | ||_____| | | | \__ \ |_\__ \
                   |_| |_|\__,_|\__|    |_|_| |_|___/\__|___/
*/

# resource "aws_eip" "natinst" {
#   count      = var.how_many_natinsts
#   vpc        = true
#   depends_on = [aws_internet_gateway.public]

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
