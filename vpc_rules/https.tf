/*
 _     _   _
| |__ | |_| |_ _ __  ___
| '_ \| __| __| '_ \/ __|
| | | | |_| |_| |_) \__ \
|_| |_|\__|\__| .__/|___/
              |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

resource "aws_network_acl_rule" "pub_rx_https_ipv4" {
  network_acl_id = data.aws_network_acls.public.ids
  rule_number    = 6301
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 443    # https
  to_port        = 443    # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_https_ipv6" {
  network_acl_id  = data.aws_network_acls.public.ids
  rule_number     = 6302
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 443    # https
  to_port         = 443    # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_https_ipv4" {
  network_acl_id = data.aws_network_acls.public.ids
  rule_number    = 7301
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 443    # https
  to_port        = 443    # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_https_ipv6" {
  network_acl_id  = data.aws_network_acls.public.ids
  rule_number     = 7302
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 443    # https
  to_port         = 443    # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_https_ipv4" {
  network_acl_id = data.aws_network_acls.private.ids
  rule_number    = 8301
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 443    # https
  to_port        = 443    # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_https_ipv6" {
  network_acl_id  = data.aws_network_acls.private.ids
  rule_number     = 8302
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 443    # https
  to_port         = 443    # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_https_ipv4" {
  network_acl_id = data.aws_network_acls.private.ids
  rule_number    = 9301
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 443    # https
  to_port        = 443    # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_https_ipv6" {
  network_acl_id  = data.aws_network_acls.private.ids
  rule_number     = 9302
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 443    # https
  to_port         = 443    # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_rx_https_ipv4" {
  network_acl_id = data.aws_network_acls.secure.ids
  rule_number    = 10301
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 443    # https
  to_port        = 443    # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_rx_https_ipv6" {
  network_acl_id  = data.aws_network_acls.secure.ids
  rule_number     = 10302
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 443    # https
  to_port         = 443    # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_tx_https_ipv4" {
  network_acl_id = data.aws_network_acls.secure.ids
  rule_number    = 11301
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 443    # https
  to_port        = 443    # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_tx_https_ipv6" {
  network_acl_id  = data.aws_network_acls.secure.ids
  rule_number     = 11302
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 443    # https
  to_port         = 443    # https
  ipv6_cidr_block = "::/0"
}

resource "aws_security_group_rule" "pub_rx_https_ipv4" {
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 443    # https
  to_port           = 443    # https
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub_rx_https_ipv6" {
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 443    # https
  to_port           = 443    # https
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "priv_rx_https_ipv4" {
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 443    # https
  to_port           = 443    # https
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "priv_rx_https_ipv6" {
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 443    # https
  to_port           = 443    # https
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "sec_rx_https_ipv4" {
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 443    # https
  to_port           = 443    # https
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sec_rx_https_ipv6" {
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 443    # https
  to_port           = 443    # https
  ipv6_cidr_blocks  = ["::/0"]
}
