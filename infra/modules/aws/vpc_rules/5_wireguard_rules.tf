/*
                            _
__      ____ _   _ __ _   _| | ___  ___
\ \ /\ / / _` | | '__| | | | |/ _ \/ __|
 \ V  V / (_| | | |  | |_| | |  __/\__ \
  \_/\_/ \__, | |_|   \__,_|_|\___||___/
         |___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule

/*
                                   _              _
                  _ __   __ _  ___| |  _ __ _   _| | ___  ___
                 | '_ \ / _` |/ __| | | '__| | | | |/ _ \/ __|
                 | | | | (_| | (__| | | |  | |_| | |  __/\__ \
                 |_| |_|\__,_|\___|_| |_|   \__,_|_|\___||___/
*/

resource "aws_network_acl_rule" "public_rx_wg_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 17221
  egress         = false
  rule_action    = "allow"
  protocol       = 17          # udp
  from_port      = var.wg_port # 51820
  to_port        = var.wg_port # 51820
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_rx_wg_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 17222
  egress          = false
  rule_action     = "allow"
  protocol        = 17          # udp
  from_port       = var.wg_port # 51820
  to_port         = var.wg_port # 51820
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "public_tx_wg_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 18221
  egress         = true
  rule_action    = "allow"
  protocol       = 17          # udp
  from_port      = var.wg_port # 51820
  to_port        = var.wg_port # 51820
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_tx_wg_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 18222
  egress          = true
  rule_action     = "allow"
  protocol        = 17          # udp
  from_port       = var.wg_port # 51820
  to_port         = var.wg_port # 51820
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_rx_wg_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 19221
  egress         = false
  rule_action    = "allow"
  protocol       = 17          # udp
  from_port      = var.wg_port # 51820
  to_port        = var.wg_port # 51820
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_rx_wg_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 19222
  egress          = false
  rule_action     = "allow"
  protocol        = 17          # udp
  from_port       = var.wg_port # 51820
  to_port         = var.wg_port # 51820
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_tx_wg_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 20221
  egress         = true
  rule_action    = "allow"
  protocol       = 17          # udp
  from_port      = var.wg_port # 51820
  to_port        = var.wg_port # 51820
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_tx_wg_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 20222
  egress          = true
  rule_action     = "allow"
  protocol        = 17          # udp
  from_port       = var.wg_port # 51820
  to_port         = var.wg_port # 51820
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_rx_wg_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 21221
  egress         = false
  rule_action    = "allow"
  protocol       = 17          # udp
  from_port      = var.wg_port # 51820
  to_port        = var.wg_port # 51820
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_rx_wg_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 21222
  egress          = false
  rule_action     = "allow"
  protocol        = 17          # udp
  from_port       = var.wg_port # 51820
  to_port         = var.wg_port # 51820
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_tx_wg_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 22221
  egress         = true
  rule_action    = "allow"
  protocol       = 17          # udp
  from_port      = var.wg_port # 51820
  to_port        = var.wg_port # 51820
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_tx_wg_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 22222
  egress          = true
  rule_action     = "allow"
  protocol        = 17          # udp
  from_port       = var.wg_port # 51820
  to_port         = var.wg_port # 51820
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

resource "aws_vpc_security_group_rule_ingress" "public_rx_wg_ipv4" {
  count             = length(var.external_ipv4_addrs)
  security_group_id = data.aws_security_group.public.id
  ip_protocol       = 17          # udp
  from_port         = var.wg_port # 51820
  to_port           = var.wg_port # 51820
  description       = "Wireguard peering"
  cidr_ipv4         = element(var.external_ipv4_addrs[*], count.index)

  tags = {
    Name = "sgr-${var.basename}-pub-dst${count.index}-wg-ipv4"
  }
}

resource "aws_vpc_security_group_rule_ingress" "public_rx_wg_ipv6" {
  count             = length(var.external_ipv6_addrs)
  security_group_id = data.aws_security_group.public.id
  ip_protocol       = 17          # udp
  from_port         = var.wg_port # 51820
  to_port           = var.wg_port # 51820
  description       = "Wireguard peering"
  cidr_ipv6         = element(var.external_ipv6_addrs[*], count.index)

  tags = {
    Name = "sgr-${var.basename}-pub-dst${count.index}-wg-ipv6"
  }
}

resource "aws_vpc_security_group_rule_ingress" "private_rx_wg_ipv4" {
  count             = length(var.external_ipv4_addrs)
  security_group_id = data.aws_security_group.private.id
  ip_protocol       = 17          # udp
  from_port         = var.wg_port # 51820
  to_port           = var.wg_port # 51820
  description       = "Wireguard peering"
  cidr_ipv4         = element(var.external_ipv4_addrs[*], count.index)

  tags = {
    Name = "sgr-${var.basename}-priv-dst${count.index}-wg-ipv4"
  }
}

resource "aws_vpc_security_group_rule_ingress" "private_rx_wg_ipv6" {
  count             = length(var.external_ipv6_addrs)
  security_group_id = data.aws_security_group.private.id
  ip_protocol       = 17          # udp
  from_port         = var.wg_port # 51820
  to_port           = var.wg_port # 51820
  description       = "Wireguard peering"
  cidr_ipv6         = element(var.external_ipv6_addrs[*], count.index)

  tags = {
    Name = "sgr-${var.basename}-priv-dst${count.index}-wg-ipv6"
  }
}

resource "aws_vpc_security_group_rule_ingress" "secure_rx_wg_ipv4" {
  count             = length(var.external_ipv4_addrs)
  security_group_id = data.aws_security_group.secure.id
  ip_protocol       = 17          # udp
  from_port         = var.wg_port # 51820
  to_port           = var.wg_port # 51820
  description       = "Wireguard peering"
  cidr_ipv4         = element(var.external_ipv4_addrs[*], count.index)

  tags = {
    Name = "sgr-${var.basename}-sec-dst${count.index}-wg-ipv4"
  }
}

resource "aws_vpc_security_group_rule_ingress" "secure_rx_wg_ipv6" {
  count             = length(var.external_ipv6_addrs)
  security_group_id = data.aws_security_group.secure.id
  ip_protocol       = 17          # udp
  from_port         = var.wg_port # 51820
  to_port           = var.wg_port # 51820
  description       = "Wireguard peering"
  cidr_ipv6         = element(var.external_ipv6_addrs[*], count.index)

  tags = {
    Name = "sgr-${var.basename}-sec-dst${count.index}-wg-ipv6"
  }
}
