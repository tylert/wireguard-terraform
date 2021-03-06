/*
         _       _              __  __ _
 ___ ___| |__   | |_ _ __ __ _ / _|/ _(_) ___
/ __/ __| '_ \  | __| '__/ _` | |_| |_| |/ __|
\__ \__ \ | | | | |_| | | (_| |  _|  _| | (__
|___/___/_| |_|  \__|_|  \__,_|_| |_| |_|\___|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

/*
                                   _              _
                  _ __   __ _  ___| |  _ __ _   _| | ___  ___
                 | '_ \ / _` |/ __| | | '__| | | | |/ _ \/ __|
                 | | | | (_| | (__| | | |  | |_| | |  __/\__ \
                 |_| |_|\__,_|\___|_| |_|   \__,_|_|\___||___/
*/

resource "aws_network_acl_rule" "pub_rx_ssh_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 17401
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22     # ssh
  to_port        = 22     # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_rx_ssh_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 17402
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22     # ssh
  to_port         = 22     # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "pub_tx_ssh_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 18401
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22     # ssh
  to_port        = 22     # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "pub_tx_ssh_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 18402
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22     # ssh
  to_port         = 22     # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_rx_ssh_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 19401
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22     # ssh
  to_port        = 22     # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_rx_ssh_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 19402
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22     # ssh
  to_port         = 22     # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "priv_tx_ssh_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 20401
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22     # ssh
  to_port        = 22     # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "priv_tx_ssh_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 20402
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22     # ssh
  to_port         = 22     # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_rx_ssh_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 21401
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22     # ssh
  to_port        = 22     # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_rx_ssh_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 21402
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22     # ssh
  to_port         = 22     # ssh
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "sec_tx_ssh_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 22401
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp"  # 6
  from_port      = 22     # ssh
  to_port        = 22     # ssh
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "sec_tx_ssh_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 22402
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp"  # 6
  from_port       = 22     # ssh
  to_port         = 22     # ssh
  ipv6_cidr_block = "::/0"
}

/*
                                              _
                       ___  __ _   _ __ _   _| | ___  ___
                      / __|/ _` | | '__| | | | |/ _ \/ __|
                      \__ \ (_| | | |  | |_| | |  __/\__ \
                      |___/\__, | |_|   \__,_|_|\___||___/
                           |___/
*/

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
