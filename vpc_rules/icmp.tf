/*
 _
(_) ___ _ __ ___  _ __
| |/ __| '_ ` _ \| '_ \
| | (__| | | | | | |_) |
|_|\___|_| |_| |_| .__/
                 |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

resource "aws_network_acl_rule" "pub_rx_icmpv4" {
  network_acl_id = data.aws_network_acls.public.ids
  rule_number    = 6101
  egress         = false
  rule_action    = "allow"
  protocol       = "icmp"  # 1
  icmp_type      = -1      # all
  icmp_code      = -1      # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_icmpv6" {
  network_acl_id  = data.aws_network_acls.public.ids
  rule_number     = 6102
  egress          = false
  rule_action     = "allow"
  protocol        = 58  # icmpv6
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_icmpv4" {
  network_acl_id = data.aws_network_acls.public.ids
  rule_number    = 7101
  egress         = true
  rule_action    = "allow"
  protocol       = "icmp"  # 1
  icmp_type      = -1      # all
  icmp_code      = -1      # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_icmpv6" {
  network_acl_id  = data.aws_network_acls.public.ids
  rule_number     = 7102
  egress          = true
  rule_action     = "allow"
  protocol        = 58  # icmpv6
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_icmpv4" {
  network_acl_id = data.aws_network_acls.private.ids
  rule_number    = 8101
  egress         = false
  rule_action    = "allow"
  protocol       = "icmp"  # 1
  icmp_type      = -1      # all
  icmp_code      = -1      # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_icmpv6" {
  network_acl_id  = data.aws_network_acls.private.ids
  rule_number     = 8102
  egress          = false
  rule_action     = "allow"
  protocol        = 58  # icmpv6
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_icmpv4" {
  network_acl_id = data.aws_network_acls.private.ids
  rule_number    = 9101
  egress         = true
  rule_action    = "allow"
  protocol       = "icmp"  # 1
  icmp_type      = -1      # all
  icmp_code      = -1      # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_icmpv6" {
  network_acl_id  = data.aws_network_acls.private.ids
  rule_number     = 9102
  egress          = true
  rule_action     = "allow"
  protocol        = 58  # icmpv6
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_rx_icmpv4" {
  network_acl_id = data.aws_network_acls.secure.ids
  rule_number    = 10101
  egress         = false
  rule_action    = "allow"
  protocol       = "icmp"  # 1
  icmp_type      = -1      # all
  icmp_code      = -1      # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_rx_icmpv6" {
  network_acl_id  = data.aws_network_acls.secure.ids
  rule_number     = 10102
  egress          = false
  rule_action     = "allow"
  protocol        = 58  # icmpv6
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_tx_icmpv4" {
  network_acl_id = data.aws_network_acls.secure.ids
  rule_number    = 11101
  egress         = true
  rule_action    = "allow"
  protocol       = "icmp"  # 1
  icmp_type      = -1      # all
  icmp_code      = -1      # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_tx_icmpv6" {
  network_acl_id  = data.aws_network_acls.secure.ids
  rule_number     = 11102
  egress          = true
  rule_action     = "allow"
  protocol        = 58  # icmpv6
  icmp_type       = -1  # all
  icmp_code       = -1  # all
  ipv6_cidr_block = "::/0"
}

resource "aws_security_group_rule" "pub_rx_icmpv4" {
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = "icmp"  # 1
  from_port         = -1      # all
  to_port           = -1      # all
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub_rx_icmpv6" {
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = 58  # icmpv6
  from_port         = -1  # all
  to_port           = -1  # all
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "priv_rx_icmpv4" {
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = "icmp"  # 1
  from_port         = -1      # all
  to_port           = -1      # all
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "priv_rx_icmpv6" {
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = 58  # icmpv6
  from_port         = -1  # all
  to_port           = -1  # all
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "sec_rx_icmpv4" {
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = "icmp"  # 1
  from_port         = -1      # all
  to_port           = -1      # all
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sec_rx_icmpv6" {
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = 58  # icmpv6
  from_port         = -1  # all
  to_port           = -1  # all
  ipv6_cidr_blocks  = ["::/0"]
}
