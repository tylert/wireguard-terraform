/*
 _       _
(_)_ __ | |_ _ __ __ _     __   ___ __   ___
| | '_ \| __| '__/ _` |____\ \ / / '_ \ / __|
| | | | | |_| | | (_| |_____\ V /| |_) | (__
|_|_| |_|\__|_|  \__,_|      \_/ | .__/ \___|
                                 |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule

resource "aws_network_acl_rule" "pub_rx_vpc_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 6001
  egress         = false
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = 0      # ignored
  to_port        = 0      # ignored
  cidr_block     = data.aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "pub_rx_vpc_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 6002
  egress          = false
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = 0      # ignored
  to_port         = 0      # ignored
  ipv6_cidr_block = data.aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "pub_tx_vpc_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 7001
  egress         = true
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = 0      # ignored
  to_port        = 0      # ignored
  cidr_block     = data.aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "pub_tx_vpc_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 7002
  egress          = true
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = 0      # ignored
  to_port         = 0      # ignored
  ipv6_cidr_block = data.aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "priv_rx_vpc_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 8001
  egress         = false
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = 0      # ignored
  to_port        = 0      # ignored
  cidr_block     = data.aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "priv_rx_vpc_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 8002
  egress          = false
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = 0      # ignored
  to_port         = 0      # ignored
  ipv6_cidr_block = data.aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "priv_tx_vpc_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 9001
  egress         = true
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = 0      # ignored
  to_port        = 0      # ignored
  cidr_block     = data.aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "priv_tx_vpc_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 9002
  egress          = true
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = 0      # ignored
  to_port         = 0      # ignored
  ipv6_cidr_block = data.aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "sec_rx_vpc_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 10001
  egress         = false
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = 0      # ignored
  to_port        = 0      # ignored
  cidr_block     = data.aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "sec_rx_vpc_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 10002
  egress          = false
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = 0      # ignored
  to_port         = 0      # ignored
  ipv6_cidr_block = data.aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "sec_tx_vpc_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 11001
  egress         = true
  rule_action    = "allow"
  protocol       = "all"  # -1
  from_port      = 0      # ignored
  to_port        = 0      # ignored
  cidr_block     = data.aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "sec_tx_vpc_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 11002
  egress          = true
  rule_action     = "allow"
  protocol        = "all"  # -1
  from_port       = 0      # ignored
  to_port         = 0      # ignored
  ipv6_cidr_block = data.aws_vpc.main.ipv6_cidr_block
}

/*
 _       _                           _
(_)_ __ | |_ ___ _ __      ___ _   _| |__
| | '_ \| __/ _ \ '__|____/ __| | | | '_ \
| | | | | ||  __/ | |_____\__ \ |_| | |_) |
|_|_| |_|\__\___|_|       |___/\__,_|_.__/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

resource "aws_security_group_rule" "pub_rx_self" {
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  self              = true
}

resource "aws_security_group_rule" "priv_rx_self" {
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  self              = true
}

resource "aws_security_group_rule" "sec_rx_self" {
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  self              = true
}

/*
 _       _                 _   _
(_)_ __ | |_ ___ _ __     | |_(_) ___ _ __
| | '_ \| __/ _ \ '__|____| __| |/ _ \ '__|
| | | | | ||  __/ | |_____| |_| |  __/ |
|_|_| |_|\__\___|_|        \__|_|\___|_|
*/

resource "aws_security_group_rule" "pub_rx_priv" {
  security_group_id        = data.aws_security_group.public.id
  type                     = "ingress"
  protocol                 = -1  # all
  from_port                = 0   # ignored
  to_port                  = 0   # ignored
  source_security_group_id = data.aws_security_group.private.id
}

resource "aws_security_group_rule" "priv_rx_pub" {
  security_group_id        = data.aws_security_group.private.id
  type                     = "ingress"
  protocol                 = -1  # all
  from_port                = 0   # ignored
  to_port                  = 0   # ignored
  source_security_group_id = data.aws_security_group.public.id
}

resource "aws_security_group_rule" "priv_rx_sec" {
  security_group_id        = data.aws_security_group.private.id
  type                     = "ingress"
  protocol                 = -1  # all
  from_port                = 0   # ignored
  to_port                  = 0   # ignored
  source_security_group_id = data.aws_security_group.secure.id
}

resource "aws_security_group_rule" "sec_rx_priv" {
  security_group_id        = data.aws_security_group.secure.id
  type                     = "ingress"
  protocol                 = -1  # all
  from_port                = 0   # ignored
  to_port                  = 0   # ignored
  source_security_group_id = data.aws_security_group.private.id
}

/*
  ___  __ _ _ __ ___  ___ ___
 / _ \/ _` | '__/ _ \/ __/ __|
|  __/ (_| | | |  __/\__ \__ \
 \___|\__, |_|  \___||___/___/
      |___/
*/

resource "aws_security_group_rule" "pub_tx_ipv4" {
  security_group_id = data.aws_security_group.public.id
  type              = "egress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub_tx_ipv6" {
  security_group_id = data.aws_security_group.public.id
  type              = "egress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "priv_tx_ipv4" {
  security_group_id = data.aws_security_group.private.id
  type              = "egress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "priv_tx_ipv6" {
  security_group_id = data.aws_security_group.private.id
  type              = "egress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "sec_tx_ipv4" {
  security_group_id = data.aws_security_group.secure.id
  type              = "egress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sec_tx_ipv6" {
  security_group_id = data.aws_security_group.secure.id
  type              = "egress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  ipv6_cidr_blocks  = ["::/0"]
}
