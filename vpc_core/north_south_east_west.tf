/*
                         _ _   _     _
               __      _(_) |_| |__ (_)_ __   __   ___ __   ___
               \ \ /\ / / | __| '_ \| | '_ \  \ \ / / '_ \ / __|
                \ V  V /| | |_| | | | | | | |  \ V /| |_) | (__
                 \_/\_/ |_|\__|_| |_|_|_| |_|   \_/ | .__/ \___|
                                                    |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule

resource "aws_network_acl_rule" "pub_rx_vpc_ipv4" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 17001
  egress         = false
  rule_action    = "allow"
  protocol       = "all" # -1
  from_port      = 0     # ignored
  to_port        = 0     # ignored
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "pub_rx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 17002
  egress          = false
  rule_action     = "allow"
  protocol        = "all" # -1
  from_port       = 0     # ignored
  to_port         = 0     # ignored
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "pub_tx_vpc_ipv4" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 18001
  egress         = true
  rule_action    = "allow"
  protocol       = "all" # -1
  from_port      = 0     # ignored
  to_port        = 0     # ignored
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "pub_tx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.public.id
  rule_number     = 18002
  egress          = true
  rule_action     = "allow"
  protocol        = "all" # -1
  from_port       = 0     # ignored
  to_port         = 0     # ignored
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "priv_rx_vpc_ipv4" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 19001
  egress         = false
  rule_action    = "allow"
  protocol       = "all" # -1
  from_port      = 0     # ignored
  to_port        = 0     # ignored
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "priv_rx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 19002
  egress          = false
  rule_action     = "allow"
  protocol        = "all" # -1
  from_port       = 0     # ignored
  to_port         = 0     # ignored
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "priv_tx_vpc_ipv4" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 20001
  egress         = true
  rule_action    = "allow"
  protocol       = "all" # -1
  from_port      = 0     # ignored
  to_port        = 0     # ignored
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "priv_tx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.private.id
  rule_number     = 20002
  egress          = true
  rule_action     = "allow"
  protocol        = "all" # -1
  from_port       = 0     # ignored
  to_port         = 0     # ignored
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "sec_rx_vpc_ipv4" {
  network_acl_id = aws_network_acl.secure.id
  rule_number    = 21001
  egress         = false
  rule_action    = "allow"
  protocol       = "all" # -1
  from_port      = 0     # ignored
  to_port        = 0     # ignored
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "sec_rx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 21002
  egress          = false
  rule_action     = "allow"
  protocol        = "all" # -1
  from_port       = 0     # ignored
  to_port         = 0     # ignored
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "sec_tx_vpc_ipv4" {
  network_acl_id = aws_network_acl.secure.id
  rule_number    = 22001
  egress         = true
  rule_action    = "allow"
  protocol       = "all" # -1
  from_port      = 0     # ignored
  to_port        = 0     # ignored
  cidr_block     = aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "sec_tx_vpc_ipv6" {
  network_acl_id  = aws_network_acl.secure.id
  rule_number     = 22002
  egress          = true
  rule_action     = "allow"
  protocol        = "all" # -1
  from_port       = 0     # ignored
  to_port         = 0     # ignored
  ipv6_cidr_block = aws_vpc.main.ipv6_cidr_block
}

/*
                                                  _     _____
                 __ _  ___ _ __ ___  ___ ___     / \   |__  /___
                / _` |/ __| '__/ _ \/ __/ __|   / _ \    / // __|
               | (_| | (__| | | (_) \__ \__ \  / ___ \  / /_\__ \
                \__,_|\___|_|  \___/|___/___/ /_/   \_\/____|___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

resource "aws_security_group_rule" "pub_rx_self" {
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = -1 # all
  from_port         = 0  # ignored
  to_port           = 0  # ignored
  self              = true
}

resource "aws_security_group_rule" "priv_rx_self" {
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = -1 # all
  from_port         = 0  # ignored
  to_port           = 0  # ignored
  self              = true
}

resource "aws_security_group_rule" "sec_rx_self" {
  security_group_id = aws_security_group.secure.id
  type              = "ingress"
  protocol          = -1 # all
  from_port         = 0  # ignored
  to_port           = 0  # ignored
  self              = true
}

/*
      _          _                             _
     | |__   ___| |___      _____  ___ _ __   | | __ _ _   _  ___ _ __ ___
     | '_ \ / _ \ __\ \ /\ / / _ \/ _ \ '_ \  | |/ _` | | | |/ _ \ '__/ __|
     | |_) |  __/ |_ \ V  V /  __/  __/ | | | | | (_| | |_| |  __/ |  \__ \
     |_.__/ \___|\__| \_/\_/ \___|\___|_| |_| |_|\__,_|\__, |\___|_|  |___/
                                                       |___/
*/

resource "aws_security_group_rule" "pub_rx_priv" {
  security_group_id        = aws_security_group.public.id
  type                     = "ingress"
  protocol                 = -1 # all
  from_port                = 0  # ignored
  to_port                  = 0  # ignored
  source_security_group_id = aws_security_group.private.id
}

resource "aws_security_group_rule" "priv_rx_pub" {
  security_group_id        = aws_security_group.private.id
  type                     = "ingress"
  protocol                 = -1 # all
  from_port                = 0  # ignored
  to_port                  = 0  # ignored
  source_security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "priv_rx_sec" {
  security_group_id        = aws_security_group.private.id
  type                     = "ingress"
  protocol                 = -1 # all
  from_port                = 0  # ignored
  to_port                  = 0  # ignored
  source_security_group_id = aws_security_group.secure.id
}

resource "aws_security_group_rule" "sec_rx_priv" {
  security_group_id        = aws_security_group.secure.id
  type                     = "ingress"
  protocol                 = -1 # all
  from_port                = 0  # ignored
  to_port                  = 0  # ignored
  source_security_group_id = aws_security_group.private.id
}

/*
                           ___  __ _ _ __ ___  ___ ___
                          / _ \/ _` | '__/ _ \/ __/ __|
                         |  __/ (_| | | |  __/\__ \__ \
                          \___|\__, |_|  \___||___/___/
                               |___/
*/

resource "aws_security_group_rule" "pub_tx_ipv4" {
  security_group_id = aws_security_group.public.id
  type              = "egress"
  protocol          = -1 # all
  from_port         = 0  # ignored
  to_port           = 0  # ignored
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub_tx_ipv6" {
  security_group_id = aws_security_group.public.id
  type              = "egress"
  protocol          = -1 # all
  from_port         = 0  # ignored
  to_port           = 0  # ignored
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "priv_tx_ipv4" {
  security_group_id = aws_security_group.private.id
  type              = "egress"
  protocol          = -1 # all
  from_port         = 0  # ignored
  to_port           = 0  # ignored
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "priv_tx_ipv6" {
  security_group_id = aws_security_group.private.id
  type              = "egress"
  protocol          = -1 # all
  from_port         = 0  # ignored
  to_port           = 0  # ignored
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "sec_tx_ipv4" {
  security_group_id = aws_security_group.secure.id
  type              = "egress"
  protocol          = -1 # all
  from_port         = 0  # ignored
  to_port           = 0  # ignored
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sec_tx_ipv6" {
  security_group_id = aws_security_group.secure.id
  type              = "egress"
  protocol          = -1 # all
  from_port         = 0  # ignored
  to_port           = 0  # ignored
  ipv6_cidr_blocks  = ["::/0"]
}
