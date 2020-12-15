/*
            _                                    _
  ___ _ __ | |__   ___ _ __ ___        _   _  __| |_ __
 / _ \ '_ \| '_ \ / _ \ '_ ` _ \ _____| | | |/ _` | '_ \
|  __/ |_) | | | |  __/ | | | | |_____| |_| | (_| | |_) |
 \___| .__/|_| |_|\___|_| |_| |_|      \__,_|\__,_| .__/
     |_|                                          |_|
*/

# https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html#nacl-ephemeral-ports

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule

resource "aws_network_acl_rule" "pub_rx_ephem_udp_ipv4" {
  network_acl_id = data.aws_network_acls.public[0].id
  rule_number    = 6211
  egress         = false
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_ephem_udp_ipv6" {
  network_acl_id  = data.aws_network_acls.public[0].id
  rule_number     = 6212
  egress          = false
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_udp_ipv4" {
  network_acl_id = data.aws_network_acls.public[0].id
  rule_number    = 7211
  egress         = true
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_ephem_udp_ipv6" {
  network_acl_id  = data.aws_network_acls.public[0].id
  rule_number     = 7212
  egress          = true
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_udp_ipv4" {
  network_acl_id = data.aws_network_acls.private[0].id
  rule_number    = 8211
  egress         = false
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_ephem_udp_ipv6" {
  network_acl_id  = data.aws_network_acls.private[0].id
  rule_number     = 8212
  egress          = false
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_udp_ipv4" {
  network_acl_id = data.aws_network_acls.private[0].id
  rule_number    = 9211
  egress         = true
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_ephem_udp_ipv6" {
  network_acl_id  = data.aws_network_acls.private[0].id
  rule_number     = 9212
  egress          = true
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_rx_ephem_udp_ipv4" {
  network_acl_id = data.aws_network_acls.secure[0].id
  rule_number    = 10211
  egress         = false
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_rx_ephem_udp_ipv6" {
  network_acl_id  = data.aws_network_acls.secure[0].id
  rule_number     = 10212
  egress          = false
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_tx_ephem_udp_ipv4" {
  network_acl_id = data.aws_network_acls.secure[0].id
  rule_number    = 11211
  egress         = true
  rule_action    = "allow"
  protocol       = "udp"  # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_tx_ephem_udp_ipv6" {
  network_acl_id  = data.aws_network_acls.secure[0].id
  rule_number     = 11212
  egress          = true
  rule_action     = "allow"
  protocol        = "udp"  # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}
