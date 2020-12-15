/*
         _
 ___ ___| |__
/ __/ __| '_ \
\__ \__ \ | | |
|___/___/_| |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

resource "aws_network_acl_rule" "pub_rx_ssh_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 6401
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22     # ssh
  to_port        = 22     # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_ssh_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 6402
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22     # ssh
  to_port         = 22     # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_ssh_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 7401
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22     # ssh
  to_port        = 22     # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_ssh_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 7402
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22     # ssh
  to_port         = 22     # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_ssh_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 8401
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22     # ssh
  to_port        = 22     # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_ssh_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 8402
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22     # ssh
  to_port         = 22     # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_ssh_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 9401
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22     # ssh
  to_port        = 22     # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_ssh_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 9402
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22     # ssh
  to_port         = 22     # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_rx_ssh_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 10401
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22     # ssh
  to_port        = 22     # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_rx_ssh_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 10402
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22     # ssh
  to_port         = 22     # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_tx_ssh_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 11401
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22     # ssh
  to_port        = 22     # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_tx_ssh_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 11402
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22     # ssh
  to_port         = 22     # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_security_group_rule" "pub_rx_ssh_ipv4" {
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 22     # ssh
  to_port           = 22     # ssh
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub_rx_ssh_ipv6" {
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 22     # ssh
  to_port           = 22     # ssh
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "priv_rx_ssh_ipv4" {
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 22     # ssh
  to_port           = 22     # ssh
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "priv_rx_ssh_ipv6" {
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 22     # ssh
  to_port           = 22     # ssh
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "sec_rx_ssh_ipv4" {
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 22     # ssh
  to_port           = 22     # ssh
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sec_rx_ssh_ipv6" {
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 22     # ssh
  to_port           = 22     # ssh
  ipv6_cidr_blocks  = ["::/0"]
}
