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
    rule_no    = 100
    action     = "allow"
    protocol   = -1  # all
    from_port  = 0  # ignored
    to_port    = 0  # ignored
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    rule_no         = 101
    action          = "allow"
    protocol        = -1  # all
    from_port       = 0  # ignored
    to_port         = 0  # ignored
    ipv6_cidr_block = "::/0"
  }

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = -1  # all
    from_port  = 0  # ignored
    to_port    = 0  # ignored
    cidr_block = "0.0.0.0/0"
  }

  egress {
    rule_no         = 101
    action          = "allow"
    protocol        = -1  # all
    from_port       = 0  # ignored
    to_port         = 0  # ignored
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
    Name = "${var.basename}-acl-sec"
  }
}

# NACL Rule Numbers

#  0xxx:  RFU public ingress
#  1xxx:  RFU public egress
#  2xxx:  RFU private ingress
#  3xxx:  RFU private egress
#  4xxx:  RFU secure ingress
#  5xxx:  RFU secure egress

#  6xxx:  general public ingress
#  7xxx:  general public egress
#  8xxx:  general private ingress
#  9xxx:  general private egress
# 10xxx:  general secure ingress
# 11xxx:  general secure egress

# xx0Nx:  ICMP
# xx1Nx:  traffic within our VPC
# xx2Nx:  ephemeral (TCP, UDP)
# xx3Nx:  management services (SSH, VNC, RDP, etc.)
# xx4Nx:  application services (HTTPS, HTTP, etc.)

# xxxx0:  IPv4
# xxxx1:  IPv6

/*
                             _
                            (_) ___ _ __ ___  _ __
                            | |/ __| '_ ` _ \| '_ \
                            | | (__| | | | | | |_) |
                            |_|\___|_| |_| |_| .__/
                                             |_|
*/

resource "aws_network_acl_rule" "pub_rx_icmpv4" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 6000
  egress         = false
  rule_action    = "allow"
  protocol       = "icmp"  # 1
  icmp_type      = -1  # all
  icmp_code      = -1  # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_icmpv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 6001
  egress          = false
  rule_action     = "allow"
  protocol        = 58  # icmpv6
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_icmpv4" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 7000
  egress         = true
  rule_action    = "allow"
  protocol       = "icmp"  # 1
  icmp_type      = -1  # all
  icmp_code      = -1  # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_icmpv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 7001
  egress          = true
  rule_action     = "allow"
  protocol        = 58  # icmpv6
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_icmpv4" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 8000
  egress          = false
  rule_action     = "allow"
  protocol        = "icmp"  # 1
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  cidr_block      = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_icmpv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 8001
  egress          = false
  rule_action     = "allow"
  protocol        = 58  # icmpv6
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_icmpv4" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 9000
  egress          = true
  rule_action     = "allow"
  protocol        = "icmp"  # 1
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  cidr_block      = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_icmpv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 9001
  egress          = true
  rule_action     = "allow"
  protocol        = 58  # icmpv6
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_rx_icmpv4" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 10000
  egress          = false
  rule_action     = "allow"
  protocol        = "icmp"  # 1
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  cidr_block      = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_rx_icmpv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 10001
  egress          = false
  rule_action     = "allow"
  protocol        = 58  # icmpv6
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_tx_icmpv4" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 11000
  egress          = true
  rule_action     = "allow"
  protocol        = "icmp"  # 1
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  cidr_block      = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_tx_icmpv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 11001
  egress          = true
  rule_action     = "allow"
  protocol        = 58  # icmpv6
  icmp_type       = -1  # all
  icmp_code       = -1  # all
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
  network_acl_id = aws_network_acl.public.id
  rule_number    = 6100
  egress         = false
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = 0  # ignored
  to_port        = 0  # ignored
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "pub_rx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 6101
  egress          = false
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = 0  # ignored
  to_port         = 0  # ignored
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "pub_tx_vpc_ipv4" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 7100
  egress         = true
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = 0  # ignored
  to_port        = 0  # ignored
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "pub_tx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 7101
  egress          = true
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = 0  # ignored
  to_port         = 0  # ignored
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "priv_rx_vpc_ipv4" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 8100
  egress         = false
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = 0  # ignored
  to_port        = 0  # ignored
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "priv_rx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 8101
  egress          = false
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = 0  # ignored
  to_port         = 0  # ignored
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "priv_tx_vpc_ipv4" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 9100
  egress         = true
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = 0  # ignored
  to_port        = 0  # ignored
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "priv_tx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 9101
  egress          = true
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = 0  # ignored
  to_port         = 0  # ignored
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "sec_rx_vpc_ipv4" {
  network_acl_id = aws_network_acl.secure.id
  rule_number    = 10100
  egress         = false
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = 0  # ignored
  to_port        = 0  # ignored
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "sec_rx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 10101
  egress          = false
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = 0  # ignored
  to_port         = 0  # ignored
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "sec_tx_vpc_ipv4" {
  network_acl_id = aws_network_acl.secure.id
  rule_number    = 11100
  egress         = true
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = 0  # ignored
  to_port        = 0  # ignored
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "sec_tx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 11101
  egress          = true
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = 0  # ignored
  to_port         = 0  # ignored
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
  network_acl_id = aws_network_acl.public.id
  rule_number    = 6200
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 6201
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_tcp_ipv4" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 7200
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 7201
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_tcp_ipv4" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 8200
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 8201
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_tcp_ipv4" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 9200
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 9201
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_rx_ephem_tcp_ipv4" {
  network_acl_id = aws_network_acl.secure.id
  rule_number    = 10200
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_rx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 10201
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_tx_ephem_tcp_ipv4" {
  network_acl_id = aws_network_acl.secure.id
  rule_number    = 11200
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_tx_ephem_tcp_ipv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 11201
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 1024
  to_port         = 65535
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
  network_acl_id = aws_network_acl.public.id
  rule_number    = 6210
  egress         = false
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 6211
  egress          = false
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_udp_ipv4" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 7210
  egress         = true
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 7211
  egress          = true
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_udp_ipv4" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 8210
  egress         = false
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 8211
  egress          = false
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_udp_ipv4" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 9210
  egress         = true
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 9211
  egress          = true
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_rx_ephem_udp_ipv4" {
  network_acl_id = aws_network_acl.secure.id
  rule_number    = 10210
  egress         = false
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_rx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 10211
  egress          = false
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_tx_ephem_udp_ipv4" {
  network_acl_id = aws_network_acl.secure.id
  rule_number    = 11210
  egress         = true
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_tx_ephem_udp_ipv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 11211
  egress          = true
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = 1024
  to_port         = 65535
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
  network_acl_id = aws_network_acl.public.id
  rule_number    = 6300
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22  # ssh
  to_port        = 22  # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_ssh_ipv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 6301
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22  # ssh
  to_port         = 22  # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_ssh_ipv4" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 7300
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22  # ssh
  to_port        = 22  # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_ssh_ipv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 7301
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22  # ssh
  to_port         = 22  # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_ssh_ipv4" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 8300
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22  # ssh
  to_port        = 22  # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_ssh_ipv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 8301
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22  # ssh
  to_port         = 22  # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_ssh_ipv4" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 9300
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22  # ssh
  to_port        = 22  # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_ssh_ipv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 9301
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22  # ssh
  to_port         = 22  # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_rx_ssh_ipv4" {
  network_acl_id = aws_network_acl.secure.id
  rule_number    = 10300
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22  # ssh
  to_port        = 22  # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_rx_ssh_ipv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 10301
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22  # ssh
  to_port         = 22  # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_tx_ssh_ipv4" {
  network_acl_id = aws_network_acl.secure.id
  rule_number    = 11300
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22  # ssh
  to_port        = 22  # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_tx_ssh_ipv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 11301
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22  # ssh
  to_port         = 22  # ssh
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
  network_acl_id = aws_network_acl.public.id
  rule_number    = 6400
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 443  # https
  to_port        = 443  # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_https_ipv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 6401
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 443  # https
  to_port         = 443  # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_https_ipv4" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 7400
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 443  # https
  to_port        = 443  # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_https_ipv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 7401
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 443  # https
  to_port         = 443  # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_https_ipv4" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 8400
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 443  # https
  to_port        = 443  # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_https_ipv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 8401
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 443  # https
  to_port         = 443  # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_https_ipv4" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 9400
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 443  # https
  to_port        = 443  # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_https_ipv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 9401
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 443  # https
  to_port         = 443  # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_rx_https_ipv4" {
  network_acl_id = aws_network_acl.secure.id
  rule_number    = 10400
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 443  # https
  to_port        = 443  # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_rx_https_ipv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 10401
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 443  # https
  to_port         = 443  # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_tx_https_ipv4" {
  network_acl_id = aws_network_acl.secure.id
  rule_number    = 11400
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 443  # https
  to_port        = 443  # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_tx_https_ipv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 11401
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 443  # https
  to_port         = 443  # https
  ipv6_cidr_block = "::/0"
}
