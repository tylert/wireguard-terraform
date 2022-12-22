/*
                            _
__      ____ _   _ __ _   _| | ___  ___
\ \ /\ / / _` | | '__| | | | |/ _ \/ __|
 \ V  V / (_| | | |  | |_| | |  __/\__ \
  \_/\_/ \__, | |_|   \__,_|_|\___||___/
         |___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag

/*
                                   _              _
                  _ __   __ _  ___| |  _ __ _   _| | ___  ___
                 | '_ \ / _` |/ __| | | '__| | | | |/ _ \/ __|
                 | | | | (_| | (__| | | |  | |_| | |  __/\__ \
                 |_| |_|\__,_|\___|_| |_|   \__,_|_|\___||___/
*/

resource "aws_network_acl_rule" "public_rx_wg_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 17211
  egress         = false
  rule_action    = "allow"
  protocol       = 17          # udp
  from_port      = var.wg_port # 51820
  to_port        = var.wg_port # 51820
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_rx_wg_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 17212
  egress          = false
  rule_action     = "allow"
  protocol        = 17          # udp
  from_port       = var.wg_port # 51820
  to_port         = var.wg_port # 51820
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "public_tx_wg_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 18211
  egress         = true
  rule_action    = "allow"
  protocol       = 17          # udp
  from_port      = var.wg_port # 51820
  to_port        = var.wg_port # 51820
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_tx_wg_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 18212
  egress          = true
  rule_action     = "allow"
  protocol        = 17          # udp
  from_port       = var.wg_port # 51820
  to_port         = var.wg_port # 51820
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_rx_wg_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 19211
  egress         = false
  rule_action    = "allow"
  protocol       = 17          # udp
  from_port      = var.wg_port # 51820
  to_port        = var.wg_port # 51820
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_rx_wg_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 19212
  egress          = false
  rule_action     = "allow"
  protocol        = 17          # udp
  from_port       = var.wg_port # 51820
  to_port         = var.wg_port # 51820
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_tx_wg_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 20211
  egress         = true
  rule_action    = "allow"
  protocol       = 17          # udp
  from_port      = var.wg_port # 51820
  to_port        = var.wg_port # 51820
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_tx_wg_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 20212
  egress          = true
  rule_action     = "allow"
  protocol        = 17          # udp
  from_port       = var.wg_port # 51820
  to_port         = var.wg_port # 51820
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_rx_wg_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 21211
  egress         = false
  rule_action    = "allow"
  protocol       = 17          # udp
  from_port      = var.wg_port # 51820
  to_port        = var.wg_port # 51820
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_rx_wg_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 21212
  egress          = false
  rule_action     = "allow"
  protocol        = 17          # udp
  from_port       = var.wg_port # 51820
  to_port         = var.wg_port # 51820
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_tx_wg_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 22211
  egress         = true
  rule_action    = "allow"
  protocol       = 17          # udp
  from_port      = var.wg_port # 51820
  to_port        = var.wg_port # 51820
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_tx_wg_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 22212
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

resource "aws_security_group_rule" "public_rx_wg_ipv4" {
  count             = length(var.external_ipv4_addrs)
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = 17          # udp
  from_port         = var.wg_port # 51820
  to_port           = var.wg_port # 51820
  cidr_blocks       = var.external_ipv4_addrs[count.index]
  description       = "WG"
}

# XXX FIXME TODO  The sgr resource doesn't support tags yet!!!
# https://github.com/hashicorp/terraform-provider-aws/issues/20104#issuecomment-1315912353
resource "aws_ec2_tag" "public_rx_wg_ipv4" {
  count       = length(var.external_ipv4_addrs)
  resource_id = aws_security_group_rule.public_rx_wg_ipv4[count.index].security_group_rule_id
  key         = "Name"
  value       = "sgr-${var.basename}-pub-wg-ipv4-no${count.index}"
}

resource "aws_security_group_rule" "public_rx_wg_ipv6" {
  count             = length(var.external_ipv6_addrs)
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = 17          # udp
  from_port         = var.wg_port # 51820
  to_port           = var.wg_port # 51820
  ipv6_cidr_blocks  = var.external_ipv6_addrs[count.index]
  description       = "WG"
}

# XXX FIXME TODO  The sgr resource doesn't support tags yet!!!
# https://github.com/hashicorp/terraform-provider-aws/issues/20104#issuecomment-1315912353
resource "aws_ec2_tag" "public_rx_wg_ipv6" {
  count       = length(var.external_ipv6_addrs)
  resource_id = aws_security_group_rule.public_rx_wg_ipv6[count.index].security_group_rule_id
  key         = "Name"
  value       = "sgr-${var.basename}-pub-wg-ipv6-no${count.index}"
}

resource "aws_security_group_rule" "private_rx_wg_ipv4" {
  count             = length(var.external_ipv4_addrs)
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = 17          # udp
  from_port         = var.wg_port # 51820
  to_port           = var.wg_port # 51820
  cidr_blocks       = var.external_ipv4_addrs[count.index]
  description       = "WG"
}

# XXX FIXME TODO  The sgr resource doesn't support tags yet!!!
# https://github.com/hashicorp/terraform-provider-aws/issues/20104#issuecomment-1315912353
resource "aws_ec2_tag" "private_rx_wg_ipv4" {
  count       = length(var.external_ipv4_addrs)
  resource_id = aws_security_group_rule.private_rx_wg_ipv4[count.index].security_group_rule_id
  key         = "Name"
  value       = "sgr-${var.basename}-priv-wg-ipv4-no${count.index}"
}

resource "aws_security_group_rule" "private_rx_wg_ipv6" {
  count             = length(var.external_ipv6_addrs)
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = 17          # udp
  from_port         = var.wg_port # 51820
  to_port           = var.wg_port # 51820
  ipv6_cidr_blocks  = var.external_ipv6_addrs[count.index]
  description       = "WG"
}

# XXX FIXME TODO  The sgr resource doesn't support tags yet!!!
# https://github.com/hashicorp/terraform-provider-aws/issues/20104#issuecomment-1315912353
resource "aws_ec2_tag" "private_rx_wg_ipv6" {
  count       = length(var.external_ipv6_addrs)
  resource_id = aws_security_group_rule.private_rx_wg_ipv6[count.index].security_group_rule_id
  key         = "Name"
  value       = "sgr-${var.basename}-priv-wg-ipv6-no${count.index}"
}

resource "aws_security_group_rule" "secure_rx_wg_ipv4" {
  count             = length(var.external_ipv4_addrs)
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = 17          # udp
  from_port         = var.wg_port # 51820
  to_port           = var.wg_port # 51820
  cidr_blocks       = var.external_ipv4_addrs[count.index]
  description       = "WG"
}

# XXX FIXME TODO  The sgr resource doesn't support tags yet!!!
# https://github.com/hashicorp/terraform-provider-aws/issues/20104#issuecomment-1315912353
resource "aws_ec2_tag" "secure_rx_wg_ipv4" {
  count       = length(var.external_ipv4_addrs)
  resource_id = aws_security_group_rule.secure_rx_wg_ipv4[count.index].security_group_rule_id
  key         = "Name"
  value       = "sgr-${var.basename}-sec-wg-ipv4-no${count.index}"
}

resource "aws_security_group_rule" "secure_rx_wg_ipv6" {
  count             = length(var.external_ipv6_addrs)
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = 17          # udp
  from_port         = var.wg_port # 51820
  to_port           = var.wg_port # 51820
  ipv6_cidr_blocks  = var.external_ipv6_addrs[count.index]
  description       = "WG"
}

# XXX FIXME TODO  The sgr resource doesn't support tags yet!!!
# https://github.com/hashicorp/terraform-provider-aws/issues/20104#issuecomment-1315912353
resource "aws_ec2_tag" "secure_rx_wg_ipv6" {
  count       = length(var.external_ipv6_addrs)
  resource_id = aws_security_group_rule.secure_rx_wg_ipv6[count.index].security_group_rule_id
  key         = "Name"
  value       = "sgr-${var.basename}-sec-wg-ipv6-no${count.index}"
}
