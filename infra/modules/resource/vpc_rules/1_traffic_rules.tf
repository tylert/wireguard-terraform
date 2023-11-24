/*
 _              __  __ _                   _
| |_ _ __ __ _ / _|/ _(_) ___   _ __ _   _| | ___  ___
| __| '__/ _` | |_| |_| |/ __| | '__| | | | |/ _ \/ __|
| |_| | | (_| |  _|  _| | (__  | |  | |_| | |  __/\__ \
 \__|_|  \__,_|_| |_| |_|\___| |_|   \__,_|_|\___||___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule

/*
                         _ _   _     _
               __      _(_) |_| |__ (_)_ __   __   ___ __   ___
               \ \ /\ / / | __| '_ \| | '_ \  \ \ / / '_ \ / __|
                \ V  V /| | |_| | | | | | | |  \ V /| |_) | (__
                 \_/\_/ |_|\__|_| |_|_|_| |_|   \_/ | .__/ \___|
                                                    |_|
*/

resource "aws_network_acl_rule" "public_rx_vpc_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 17001
  egress         = false
  rule_action    = "allow"
  protocol       = -1 # all
  # from_port      = 0  # ignored
  # to_port        = 0  # ignored
  cidr_block = data.aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "public_rx_vpc_ipv6" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 17002
  egress         = false
  rule_action    = "allow"
  protocol       = -1 # all
  # from_port       = 0  # ignored
  # to_port         = 0  # ignored
  ipv6_cidr_block = data.aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "public_tx_vpc_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 18001
  egress         = true
  rule_action    = "allow"
  protocol       = -1 # all
  # from_port      = 0  # ignored
  # to_port        = 0  # ignored
  cidr_block = data.aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "public_tx_vpc_ipv6" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 18002
  egress         = true
  rule_action    = "allow"
  protocol       = -1 # all
  # from_port       = 0  # ignored
  # to_port         = 0  # ignored
  ipv6_cidr_block = data.aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "private_rx_vpc_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 19001
  egress         = false
  rule_action    = "allow"
  protocol       = -1 # all
  # from_port      = 0  # ignored
  # to_port        = 0  # ignored
  cidr_block = data.aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "private_rx_vpc_ipv6" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 19002
  egress         = false
  rule_action    = "allow"
  protocol       = -1 # all
  # from_port       = 0  # ignored
  # to_port         = 0  # ignored
  ipv6_cidr_block = data.aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "private_tx_vpc_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 20001
  egress         = true
  rule_action    = "allow"
  protocol       = -1 # all
  # from_port      = 0  # ignored
  # to_port        = 0  # ignored
  cidr_block = data.aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "private_tx_vpc_ipv6" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 20002
  egress         = true
  rule_action    = "allow"
  protocol       = -1 # all
  # from_port       = 0  # ignored
  # to_port         = 0  # ignored
  ipv6_cidr_block = data.aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "secure_rx_vpc_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 21001
  egress         = false
  rule_action    = "allow"
  protocol       = -1 # all
  # from_port      = 0  # ignored
  # to_port        = 0  # ignored
  cidr_block = data.aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "secure_rx_vpc_ipv6" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 21002
  egress         = false
  rule_action    = "allow"
  protocol       = -1 # all
  # from_port       = 0  # ignored
  # to_port         = 0  # ignored
  ipv6_cidr_block = data.aws_vpc.main.ipv6_cidr_block
}

resource "aws_network_acl_rule" "secure_tx_vpc_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 22001
  egress         = true
  rule_action    = "allow"
  protocol       = -1 # all
  # from_port      = 0  # ignored
  # to_port        = 0  # ignored
  cidr_block = data.aws_vpc.main.cidr_block
}

resource "aws_network_acl_rule" "secure_tx_vpc_ipv6" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 22002
  egress         = true
  rule_action    = "allow"
  protocol       = -1 # all
  # from_port       = 0  # ignored
  # to_port         = 0  # ignored
  ipv6_cidr_block = data.aws_vpc.main.ipv6_cidr_block
}

/*
           _          _                                _     _____
          | |__   ___| |___      _____  ___ _ __      / \   |__  /___
          | '_ \ / _ \ __\ \ /\ / / _ \/ _ \ '_ \    / _ \    / // __|
          | |_) |  __/ |_ \ V  V /  __/  __/ | | |  / ___ \  / /_\__ \
          |_.__/ \___|\__| \_/\_/ \___|\___|_| |_| /_/   \_\/____|___/
*/

resource "aws_vpc_security_group_ingress_rule" "public_rx_self" {
  security_group_id = data.aws_security_group.public.id
  ip_protocol       = -1 # all
  # from_port                    = 0  # ignored
  # to_port                      = 0  # ignored
  description                  = "From public subnets"
  referenced_security_group_id = data.aws_security_group.public.id

  tags = {
    Name = "sgr-${var.basename}-pub-pub"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_rx_self" {
  security_group_id = data.aws_security_group.private.id
  ip_protocol       = -1 # all
  # from_port                    = 0  # ignored
  # to_port                      = 0  # ignored
  description                  = "From private subnets"
  referenced_security_group_id = data.aws_security_group.private.id

  tags = {
    Name = "sgr-${var.basename}-priv-priv"
  }
}

resource "aws_vpc_security_group_ingress_rule" "secure_rx_self" {
  security_group_id = data.aws_security_group.secure.id
  ip_protocol       = -1 # all
  # from_port                    = 0  # ignored
  # to_port                      = 0  # ignored
  description                  = "From secure subnets"
  referenced_security_group_id = data.aws_security_group.secure.id

  tags = {
    Name = "sgr-${var.basename}-sec-sec"
  }
}

/*
          _          _                             _   _
         | |__   ___| |___      _____  ___ _ __   | |_(_) ___ _ __ ___
         | '_ \ / _ \ __\ \ /\ / / _ \/ _ \ '_ \  | __| |/ _ \ '__/ __|
         | |_) |  __/ |_ \ V  V /  __/  __/ | | | | |_| |  __/ |  \__ \
         |_.__/ \___|\__| \_/\_/ \___|\___|_| |_|  \__|_|\___|_|  |___/
*/

resource "aws_vpc_security_group_ingress_rule" "public_rx_private" {
  security_group_id = data.aws_security_group.public.id
  ip_protocol       = -1 # all
  # from_port                    = 0  # ignored
  # to_port                      = 0  # ignored
  description                  = "From private subnets"
  referenced_security_group_id = data.aws_security_group.private.id

  tags = {
    Name = "sgr-${var.basename}-pub-priv"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_rx_public" {
  security_group_id = data.aws_security_group.private.id
  ip_protocol       = -1 # all
  # from_port                    = 0  # ignored
  # to_port                      = 0  # ignored
  description                  = "From public subnets"
  referenced_security_group_id = data.aws_security_group.public.id

  tags = {
    Name = "sgr-${var.basename}-priv-pub"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_rx_secure" {
  security_group_id = data.aws_security_group.private.id
  ip_protocol       = -1 # all
  # from_port                    = 0  # ignored
  # to_port                      = 0  # ignored
  description                  = "From secure subnets"
  referenced_security_group_id = data.aws_security_group.secure.id

  tags = {
    Name = "sgr-${var.basename}-priv-sec"
  }
}

resource "aws_vpc_security_group_ingress_rule" "secure_rx_private" {
  security_group_id = data.aws_security_group.secure.id
  ip_protocol       = -1 # all
  # from_port                    = 0  # ignored
  # to_port                      = 0  # ignored
  description                  = "From private subnets"
  referenced_security_group_id = data.aws_security_group.private.id

  tags = {
    Name = "sgr-${var.basename}-sec-priv"
  }
}

/*
                           ___  __ _ _ __ ___  ___ ___
                          / _ \/ _` | '__/ _ \/ __/ __|
                         |  __/ (_| | | |  __/\__ \__ \
                          \___|\__, |_|  \___||___/___/
                               |___/
*/

resource "aws_vpc_security_group_egress_rule" "public_tx_ipv4" {
  security_group_id = data.aws_security_group.public.id
  ip_protocol       = -1 # all
  # from_port         = 0  # ignored
  # to_port           = 0  # ignored
  description = "To anywhere"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "sgr-${var.basename}-pub-all-ipv4"
  }
}

resource "aws_vpc_security_group_egress_rule" "public_tx_ipv6" {
  security_group_id = data.aws_security_group.public.id
  ip_protocol       = -1 # all
  # from_port         = 0  # ignored
  # to_port           = 0  # ignored
  description = "To anywhere"
  cidr_ipv6   = "::/0"

  tags = {
    Name = "sgr-${var.basename}-pub-all-ipv6"
  }
}

resource "aws_vpc_security_group_egress_rule" "private_tx_ipv4" {
  security_group_id = data.aws_security_group.private.id
  ip_protocol       = -1 # all
  # from_port         = 0  # ignored
  # to_port           = 0  # ignored
  description = "To anywhere"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "sgr-${var.basename}-priv-all-ipv4"
  }
}

resource "aws_vpc_security_group_egress_rule" "private_tx_ipv6" {
  security_group_id = data.aws_security_group.private.id
  ip_protocol       = -1 # all
  # from_port         = 0  # ignored
  # to_port           = 0  # ignored
  description = "To anywhere"
  cidr_ipv6   = "::/0"

  tags = {
    Name = "sgr-${var.basename}-priv-all-ipv6"
  }
}

resource "aws_vpc_security_group_egress_rule" "secure_tx_ipv4" {
  security_group_id = data.aws_security_group.secure.id
  ip_protocol       = -1 # all
  # from_port         = 0  # ignored
  # to_port           = 0  # ignored
  description = "To anywhere"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "sgr-${var.basename}-sec-all-ipv4"
  }
}

resource "aws_vpc_security_group_egress_rule" "secure_tx_ipv6" {
  security_group_id = data.aws_security_group.secure.id
  ip_protocol       = -1 # all
  # from_port         = 0  # ignored
  # to_port           = 0  # ignored
  description = "To anywhere"
  cidr_ipv6   = "::/0"

  tags = {
    Name = "sgr-${var.basename}-sec-all-ipv6"
  }
}
