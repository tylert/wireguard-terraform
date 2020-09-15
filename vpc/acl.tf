# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule

# https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateNetworkAclEntry.html
# https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html#nacl-ephemeral-ports

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
    action     = "allow"
    protocol   = "-1"
    from_port  = "0"
    to_port    = "0"
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    rule_no         = "101"
    action          = "allow"
    protocol        = "-1"
    from_port       = "0"
    to_port         = "0"
    ipv6_cidr_block = "::/0"
  }

  egress {
    rule_no    = "100"
    action     = "allow"
    protocol   = "-1"
    from_port  = "0"
    to_port    = "0"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    rule_no         = "101"
    action          = "allow"
    protocol        = "-1"
    from_port       = "0"
    to_port         = "0"
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
  subnet_ids = aws_subnet.public_az[*].id

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
  subnet_ids = aws_subnet.private_az[*].id

  tags = {
    Name = "${var.basename}-acl-priv"
  }
}

# NACL Rule Numbers

# 5xxx:  public ingress
# 6xxx:  public egress
# 7xxx:  private ingress
# 8xxx:  private egress

# x0xx:  ICMP
# x1xx:  traffic within our VPC
# x2xx:  ephemeral TCP
# x3xx:  ephemeral UDP
# x4xx:  https
# x5xx:  ssh

# xxx0:  IPv4
# xxx1:  IPv6

/*
                             _
                            (_) ___ _ __ ___  _ __
                            | |/ __| '_ ` _ \| '_ \
                            | | (__| | | | | | |_) |
                            |_|\___|_| |_| |_| .__/
                                             |_|
*/

resource "aws_network_acl_rule" "pub_rx_icmpv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "5000"
  egress         = false
  rule_action    = "allow"
  protocol       = "icmp"  # 1
  icmp_type      = "-1"  # all
  icmp_code      = "-1"  # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_icmpv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "5001"
  egress          = false
  rule_action     = "allow"
  protocol        = "icmpv6"  $ 58
  icmp_type       = "-1"  # all
  icmp_code       = "-1"  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_icmpv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "6000"
  egress         = true
  rule_action    = "allow"
  protocol       = "icmp"  # 1
  icmp_type      = "-1"  # all
  icmp_code      = "-1"  # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_icmpv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "6001"
  egress          = true
  rule_action     = "allow"
  protocol        = "icmpv6"  $ 58
  icmp_type       = "-1"  # all
  icmp_code       = "-1"  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_icmpv4" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "7000"
  egress          = false
  rule_action     = "allow"
  protocol        = "icmp"  # 1
  icmp_type       = "-1"  # all
  icmp_code       = "-1"  # all
  cidr_block      = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_icmpv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "7001"
  egress          = false
  rule_action     = "allow"
  protocol        = "icmpv6"  $ 58
  icmp_type       = "-1"  # all
  icmp_code       = "-1"  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_icmpv4" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "8000"
  egress          = true
  rule_action     = "allow"
  protocol        = "icmp"  # 1
  icmp_type       = "-1"  # all
  icmp_code       = "-1"  # all
  cidr_block      = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_icmpv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "8001"
  egress          = true
  rule_action     = "allow"
  protocol        = "icmpv6"  $ 58
  icmp_type       = "-1"  # all
  icmp_code       = "-1"  # all
  ipv6_cidr_block = "::/0"
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
  rule_number    = "5100"
  egress         = false
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = "0"
  to_port        = "0"
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "pub_rx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "5101"
  egress          = false
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = "0"
  to_port         = "0"
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "pub_tx_vpc_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "6100"
  egress         = true
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = "0"
  to_port        = "0"
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "pub_tx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "6101"
  egress          = true
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = "0"
  to_port         = "0"
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "priv_rx_vpc_ipv4" {
  network_acl_id = aws_network_acl.private
  rule_number    = "7100"
  egress         = false
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = "0"
  to_port        = "0"
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "priv_rx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "7101"
  egress          = false
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = "0"
  to_port         = "0"
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "priv_tx_vpc_ipv4" {
  network_acl_id = aws_network_acl.private
  rule_number    = "8100"
  egress         = true
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = "0"
  to_port        = "0"
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "priv_tx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "8101"
  egress          = true
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = "0"
  to_port         = "0"
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
  rule_number    = "5200"
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = "1024"
  to_port        = "65535"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "5201"
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "1024"
  to_port         = "65535"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_tcp_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "6200"
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = "1024"
  to_port        = "65535"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "6201"
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "1024"
  to_port         = "65535"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_tcp_ipv4" {
  network_acl_id = aws_network_acl.private
  rule_number    = "7200"
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = "1024"
  to_port        = "65535"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "7201"
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "1024"
  to_port         = "65535"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_tcp_ipv4" {
  network_acl_id = aws_network_acl.private
  rule_number    = "8200"
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = "1024"
  to_port        = "65535"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "8201"
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "1024"
  to_port         = "65535"
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
  rule_number    = "5300"
  egress         = false
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = "1024"
  to_port        = "65535"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "5301"
  egress          = false
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = "1024"
  to_port         = "65535"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_udp_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "6300"
  egress         = true
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = "1024"
  to_port        = "65535"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "6301"
  egress          = true
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = "1024"
  to_port         = "65535"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_udp_ipv4" {
  network_acl_id = aws_network_acl.private
  rule_number    = "7300"
  egress         = false
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = "1024"
  to_port        = "65535"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "7301"
  egress          = false
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = "1024"
  to_port         = "65535"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_udp_ipv4" {
  network_acl_id = aws_network_acl.private
  rule_number    = "8300"
  egress         = true
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = "1024"
  to_port        = "65535"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "8301"
  egress          = true
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = "1024"
  to_port         = "65535"
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
  rule_number    = "5400"
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = "443"
  to_port        = "443"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_https_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "5401"
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "443"
  to_port         = "443"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_https_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "6400"
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = "443"
  to_port        = "443"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_https_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "6401"
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "443"
  to_port         = "443"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_https_ipv4" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "7400"
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "443"
  to_port         = "443"
  cidr_block      = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_https_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "7401"
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "443"
  to_port         = "443"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_https_ipv4" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "8400"
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "443"
  to_port         = "443"
  cidr_block      = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_https_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "8401"
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "443"
  to_port         = "443"
  ipv6_cidr_block = "::/0"
}

/*
                                         _
                                 ___ ___| |__
                                / __/ __| '_ \
                                \__ \__ \ | | |
                                |___/___/_| |_|
*/

resource "aws_network_acl_rule" "pub_rx_ssh_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "5500"
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = "22"
  to_port        = "22"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_ssh_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "5501"
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "22"
  to_port         = "22"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_ssh_ipv4" {
  network_acl_id = aws_network_acl.public
  rule_number    = "6500"
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = "22"
  to_port        = "22"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_ssh_ipv6" {
  network_acl_id  = aws_network_acl.public
  rule_number     = "6501"
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "22"
  to_port         = "22"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_ssh_ipv4" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "7500"
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "22"
  to_port         = "22"
  cidr_block      = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_ssh_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "7501"
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "22"
  to_port         = "22"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_ssh_ipv4" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "8500"
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "22"
  to_port         = "22"
  cidr_block      = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_ssh_ipv6" {
  network_acl_id  = aws_network_acl.private
  rule_number     = "8501"
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = "22"
  to_port         = "22"
  ipv6_cidr_block = "::/0"
}
