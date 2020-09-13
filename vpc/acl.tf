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

resource "aws_default_network_acl" "main" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  ingress {
    rule_no    = "100"
    protocol   = "-1"
    from_port  = "0"
    to_port    = "0"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    rule_no         = "101"
    protocol        = "-1"
    from_port       = "0"
    to_port         = "0"
    action          = "allow"
    ipv6_cidr_block = "::/0"
  }

  egress {
    rule_no    = "100"
    protocol   = "-1"
    from_port  = "0"
    to_port    = "0"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    rule_no         = "101"
    protocol        = "-1"
    from_port       = "0"
    to_port         = "0"
    action          = "allow"
    ipv6_cidr_block = "::/0"
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

/*
                  _       _
                 (_)_ __ | |_ _ __ __ _     __   ___ __   ___
                 | | '_ \| __| '__/ _` |____\ \ / / '_ \ / __|
                 | | | | | |_| | | (_| |_____\ V /| |_) | (__
                 |_|_| |_|\__|_|  \__,_|      \_/ | .__/ \___|
                                                  |_|
*/

resource "aws_network_acl_rule" "pub_rx_vpc_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "1000"
  egress         = false
  protocol       = "-1"
  from_port      = "0"
  to_port        = "0"
  rule_action    = "allow"
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "pub_rx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "1001"
  egress          = false
  protocol        = "-1"
  from_port       = "0"
  to_port         = "0"
  rule_action     = "allow"
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "pub_tx_vpc_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "2000"
  egress         = true
  protocol       = "-1"
  from_port      = "0"
  to_port        = "0"
  rule_action    = "allow"
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "pub_tx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "2001"
  egress          = true
  protocol        = "-1"
  from_port       = "0"
  to_port         = "0"
  rule_action     = "allow"
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "priv_rx_vpc_ipv4" {
  network_acl_id = aws_network_acl.private
  rule_number    = "3000"
  egress         = false
  protocol       = "-1"
  from_port      = "0"
  to_port        = "0"
  rule_action    = "allow"
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "priv_rx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "3001"
  egress          = false
  protocol        = "-1"
  from_port       = "0"
  to_port         = "0"
  rule_action     = "allow"
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "priv_tx_vpc_ipv4" {
  network_acl_id = aws_network_acl.private
  rule_number    = "4000"
  egress         = true
  protocol       = "-1"
  from_port      = "0"
  to_port        = "0"
  rule_action    = "allow"
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "priv_tx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "4001"
  egress          = true
  protocol        = "-1"
  from_port       = "0"
  to_port         = "0"
  rule_action     = "allow"
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

/*
                         _                          _
               ___ _ __ | |__   ___ _ __ ___       | |_ ___ _ __
              / _ \ '_ \| '_ \ / _ \ '_ ` _ \ _____| __/ __| '_ \
             |  __/ |_) | | | |  __/ | | | | |_____| || (__| |_) |
              \___| .__/|_| |_|\___|_| |_| |_|      \__\___| .__/
                  |_|                                      |_|
*/

resource "aws_network_acl_rule" "pub_rx_ephem_tcp_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "1100"
  egress         = false
  protocol       = "tcp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "1101"
  egress          = false
  protocol        = "tcp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_tcp_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "2100"
  egress         = true
  protocol       = "tcp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "2101"
  egress          = true
  protocol        = "tcp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_tcp_ipv4" {
  network_acl_id = aws_network_acl.private
  rule_number    = "3100"
  egress         = false
  protocol       = "tcp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "3101"
  egress          = false
  protocol        = "tcp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_tcp_ipv4" {
  network_acl_id = aws_network_acl.private
  rule_number    = "4100"
  egress         = true
  protocol       = "tcp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "4101"
  egress          = true
  protocol        = "tcp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

/*
                       _                                    _
             ___ _ __ | |__   ___ _ __ ___        _   _  __| |_ __
            / _ \ '_ \| '_ \ / _ \ '_ ` _ \ _____| | | |/ _` | '_ \
           |  __/ |_) | | | |  __/ | | | | |_____| |_| | (_| | |_) |
            \___| .__/|_| |_|\___|_| |_| |_|      \__,_|\__,_| .__/
                |_|                                          |_|
*/

resource "aws_network_acl_rule" "pub_rx_ephem_udp_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "1200"
  egress         = false
  protocol       = "udp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "1201"
  egress          = false
  protocol        = "udp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_udp_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "2200"
  egress         = true
  protocol       = "udp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "2201"
  egress          = true
  protocol        = "udp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_udp_ipv4" {
  network_acl_id = aws_network_acl.private
  rule_number    = "3200"
  egress         = false
  protocol       = "udp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "3201"
  egress          = false
  protocol        = "udp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_udp_ipv4" {
  network_acl_id = aws_network_acl.private
  rule_number    = "4200"
  egress         = true
  protocol       = "udp"
  from_port      = "1024"
  to_port        = "65535"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "4201"
  egress          = true
  protocol        = "udp"
  from_port       = "1024"
  to_port         = "65535"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

/*
                            _     _   _
                           | |__ | |_| |_ _ __  ___
                           | '_ \| __| __| '_ \/ __|
                           | | | | |_| |_| |_) \__ \
                           |_| |_|\__|\__| .__/|___/
                                         |_|
*/

resource "aws_network_acl_rule" "pub_rx_https_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "1300"
  egress         = false
  protocol       = "tcp"
  from_port      = "443"
  to_port        = "443"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_https_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "1301"
  egress          = false
  protocol        = "tcp"
  from_port       = "443"
  to_port         = "443"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_https_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "2300"
  egress         = true
  protocol       = "tcp"
  from_port      = "443"
  to_port        = "443"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_https_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "2301"
  egress          = true
  protocol        = "tcp"
  from_port       = "443"
  to_port         = "443"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_https_ipv4" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "3300"
  egress          = false
  protocol        = "tcp"
  from_port       = "443"
  to_port         = "443"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_https_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "3301"
  egress          = false
  protocol        = "tcp"
  from_port       = "443"
  to_port         = "443"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_https_ipv4" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "4300"
  egress          = true
  protocol        = "tcp"
  from_port       = "443"
  to_port         = "443"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_https_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "4301"
  egress          = true
  protocol        = "tcp"
  from_port       = "443"
  to_port         = "443"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}
