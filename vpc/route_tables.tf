/*
                 _         _        _     _
 _ __ ___  _   _| |_ ___  | |_ __ _| |__ | | ___  ___
| '__/ _ \| | | | __/ _ \ | __/ _` | '_ \| |/ _ \/ __|
| | | (_) | |_| | ||  __/ | || (_| | |_) | |  __/\__ \
|_|  \___/ \__,_|\__\___|  \__\__,_|_.__/|_|\___||___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

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

# We only really need a single public route table since internet gateways are
# not bound to a single AZ so all the public subnets can share the same IGW.
# However, there might be other use-cases that would benefit from having one
# route table per subnet.

resource "aws_route_table" "public_az" {
  count  = var.how_many_azs
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-rtb-pub-az${count.index}"
  }
}

resource "aws_route_table_association" "public_az" {
  count          = var.how_many_azs
  route_table_id = element(aws_route_table.public[*].id, count.index)
  subnet_id      = element(aws_subnet.public_az[*].id, count.index)
}

/*
                         _   _                      _
                    _ __| |_| |__        _ __  _ __(_)_   __
                   | '__| __| '_ \ _____| '_ \| '__| \ \ / /
                   | |  | |_| |_) |_____| |_) | |  | |\ V /
                   |_|   \__|_.__/      | .__/|_|  |_| \_/
                                        |_|
*/

# We need to create a private route table for each private subnet since each
# NAT gateway or NAT instance lives in a single AZ so we need a way to maintain
# HA.

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

/*
                            _   _
                       _ __| |_| |__        ___  ___  ___
                      | '__| __| '_ \ _____/ __|/ _ \/ __|
                      | |  | |_| |_) |_____\__ \  __/ (__
                      |_|   \__|_.__/      |___/\___|\___|
*/

resource "aws_route_table" "secure_az" {
  count  = var.how_many_azs
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-rtb-sec-az${count.index}"
  }
}

resource "aws_route_table_association" "secure_az" {
  count          = var.how_many_azs
  route_table_id = element(aws_route_table.secure_az[*].id, count.index)
  subnet_id      = element(aws_subnet.secure_az[*].id, count.index)
}
