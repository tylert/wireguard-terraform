/*
            _                          _
  ___ _ __ | |__   ___ _ __ ___       | |_ ___ _ __
 / _ \ '_ \| '_ \ / _ \ '_ ` _ \ _____| __/ __| '_ \
|  __/ |_) | | | |  __/ | | | | |_____| || (__| |_) |
 \___| .__/|_| |_|\___|_| |_| |_|      \__\___| .__/
     |_|                                      |_|
*/

# https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html#nacl-ephemeral-ports

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule

resource "aws_network_acl_rule" "pub_rx_ephem_tcp_ipv4" {
  network_acl_id = data.aws_network_acls.public[0].id
  rule_number    = 6201
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_ephem_tcp_ipv6" {
  network_acl_id  = data.aws_network_acls.public[0].id
  rule_number     = 6202
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_tcp_ipv4" {
  network_acl_id = data.aws_network_acls.public[0].id
  rule_number    = 7201
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_tcp_ipv6" {
  network_acl_id  = data.aws_network_acls.public[0].id
  rule_number     = 7202
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_tcp_ipv4" {
  network_acl_id = data.aws_network_acls.private[0].id
  rule_number    = 8201
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_tcp_ipv6" {
  network_acl_id  = data.aws_network_acls.private[0].id
  rule_number     = 8202
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_tcp_ipv4" {
  network_acl_id = data.aws_network_acls.private[0].id
  rule_number    = 9201
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_tcp_ipv6" {
  network_acl_id  = data.aws_network_acls.private[0].id
  rule_number     = 9202
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_rx_ephem_tcp_ipv4" {
  network_acl_id = data.aws_network_acls.secure[0].id
  rule_number    = 10201
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_rx_ephem_tcp_ipv6" {
  network_acl_id  = data.aws_network_acls.secure[0].id
  rule_number     = 10202
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_tx_ephem_tcp_ipv4" {
  network_acl_id = data.aws_network_acls.secure[0].id
  rule_number    = 11201
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_tx_ephem_tcp_ipv6" {
  network_acl_id  = data.aws_network_acls.secure[0].id
  rule_number     = 11202
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}
