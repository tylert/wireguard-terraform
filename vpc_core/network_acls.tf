/*
            _                      _                 _
 _ __   ___| |___      _____  _ __| | __   __ _  ___| |___
| '_ \ / _ \ __\ \ /\ / / _ \| '__| |/ /  / _` |/ __| / __|
| | | |  __/ |_ \ V  V / (_) | |  |   <  | (_| | (__| \__ \
|_| |_|\___|\__| \_/\_/ \___/|_|  |_|\_\  \__,_|\___|_|___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl

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

resource "aws_default_network_acl" "main" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = -1  # all
    from_port  = 0   # ignored
    to_port    = 0   # ignored
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    rule_no         = 101
    action          = "allow"
    protocol        = -1  # all
    from_port       = 0   # ignored
    to_port         = 0   # ignored
    ipv6_cidr_block = "::/0"
  }

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = -1  # all
    from_port  = 0   # ignored
    to_port    = 0   # ignored
    cidr_block = "0.0.0.0/0"
  }

  egress {
    rule_no         = 101
    action          = "allow"
    protocol        = -1  # all
    from_port       = 0   # ignored
    to_port         = 0   # ignored
    ipv6_cidr_block = "::/0"
  }

  tags = {
    Name = "acl-${var.basename}-default"
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
  subnet_ids = aws_subnet.public_az[*].id

  tags = {
    Name = "acl-${var.basename}-public"
  }
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
  subnet_ids = aws_subnet.private_az[*].id

  tags = {
    Name = "acl-${var.basename}-private"
  }
}

/*
                                   _
                         __ _  ___| |      ___  ___  ___
                        / _` |/ __| |_____/ __|/ _ \/ __|
                       | (_| | (__| |_____\__ \  __/ (__
                        \__,_|\___|_|     |___/\___|\___|
*/

resource "aws_network_acl" "secure" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.secure_az[*].id

  tags = {
    Name = "acl-${var.basename}-secure"
  }
}
