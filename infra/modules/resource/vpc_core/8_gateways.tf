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

# There is no additional charge for using Interet Gateways and that's what
# makes your public subnet a public subnet.

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-${var.basename}"
  }
}

resource "aws_route" "public_az_ipv4" {
  count                  = var.how_many_azs
  route_table_id         = element(aws_route_table.public_az[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}

resource "aws_route" "public_az_ipv6" {
  count                       = var.how_many_azs
  route_table_id              = element(aws_route_table.public_az[*].id, count.index)
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

# Egress-Only Internet Gateways are only for IPv6 traffic so there is no IPv4
# routing done here.  There is no additional charge for using Egress-Only
# Internet Gateways so just shut up and use them.

resource "aws_egress_only_internet_gateway" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eigw-${var.basename}"
  }
}

resource "aws_route" "private_az_ipv6" {
  count                       = var.how_many_azs
  route_table_id              = element(aws_route_table.private_az[*].id, count.index)
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.private.id
}

/*
                                  _
                      _ __   __ _| |_       __ ___      __
                     | '_ \ / _` | __|____ / _` \ \ /\ / /
                     | | | | (_| | ||_____| (_| |\ V  V /
                     |_| |_|\__,_|\__|     \__, | \_/\_/
                                           |___/
*/

# EIP may require IGW to exist prior to association.  Use depends_on to set an
# explicit dependency on the IGW.

# Do not use network_interface to associate the EIP to aws_lb or
# aws_nat_gateway resources.  Instead use the allocation_id available in those
# resources to allow AWS to manage the association, otherwise you will see
# AuthFailure errors.

resource "aws_eip" "natgw_az" {
  count      = false == var.create_nat_instances ? 0 : 0
  vpc        = true
  depends_on = [aws_internet_gateway.public]

  tags = {
    Name = "eipalloc-${var.basename}-natgw-az${count.index}"
  }
}

resource "aws_nat_gateway" "az" {
  count         = false == var.create_nat_instances ? 0 : 0
  allocation_id = element(aws_eip.natgw_az[*].id, count.index)
  subnet_id     = element(aws_subnet.public_az[*].id, count.index)
  depends_on    = [aws_internet_gateway.public]

  tags = {
    Name = "nat-${var.basename}-az${count.index}"
  }
}

resource "aws_route" "private_az_ipv4" {
  count                  = false == var.create_nat_instances ? 0 : 0
  route_table_id         = element(aws_route_table.private_az[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.az[*].id, count.index)
}

/*
                                  _        _           _
                      _ __   __ _| |_     (_)_ __  ___| |_
                     | '_ \ / _` | __|____| | '_ \/ __| __|
                     | | | | (_| | ||_____| | | | \__ \ |_
                     |_| |_|\__,_|\__|    |_|_| |_|___/\__|
*/

resource "aws_eip" "natinst_az" {
  count      = true == var.create_nat_instances ? 0 : 0
  vpc        = true
  depends_on = [aws_internet_gateway.public]

  tags = {
    Name = "eipalloc-${var.basename}-natinst-az${count.index}"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami

# https://alpinelinux.org/cloud/
# http://cdimage.debian.org/cdimage/cloud/
# https://wiki.debian.org/Cloud/AmazonEC2Image
# https://cloud-images.ubuntu.com/locator/

# Owners:
#   "093273469852" for "Uplink Labs" (ArchLinux) AMIs
#   "099720109477" for "Canonical" AMIs
#   "136693071363" for "Debian" AMIs
#   "???" for "Alpine" AMIs

# data "aws_ami" "natinst" {
#   owners      = ["099720109477"]
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group

# resource "aws_instance" "natinst" {
#   count         = true == var.create_nat_instances ? 0 : 0
#   availability_zone           = data.aws_availability_zones.available.names[count.index]
#   instance_type = "t4g.nano"
#   allocation_id = element(aws_eip.natinst_az[*].id, count.index)
#   subnet_id     = element(aws_subnet.public_az[*].id, count.index)
#   depends_on    = [aws_internet_gateway.public]
#   ami           = data.aws_ami.natinst.id
#   associate_public_ip_address = true

#   user_data = <<-EOF
#   EOF

#   tags = {
#     Name = ""
#   }
# }

# resource "aws_route" "private_az_ipv4" {
#   count                  = true == var.create_nat_instances ? 0 : 0
#   route_table_id         = element(aws_route_table.private_az[*].id, count.index)
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = element(aws_nat_gateway.az[*].id, count.index)
# }
