/*
 _     _   _                          _
| |__ | |_| |_ _ __  ___   _ __ _   _| | ___  ___
| '_ \| __| __| '_ \/ __| | '__| | | | |/ _ \/ __|
| | | | |_| |_| |_) \__ \ | |  | |_| | |  __/\__ \
|_| |_|\__|\__| .__/|___/ |_|   \__,_|_|\___||___/
              |_|
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

resource "aws_network_acl_rule" "public_rx_https_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 17301
  egress         = false
  rule_action    = "allow"
  protocol       = 6              # tcp
  from_port      = var.https_port # 443
  to_port        = var.https_port # 443
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_rx_https_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 17302
  egress          = false
  rule_action     = "allow"
  protocol        = 6              # tcp
  from_port       = var.https_port # 443
  to_port         = var.https_port # 443
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "public_tx_https_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 18301
  egress         = true
  rule_action    = "allow"
  protocol       = 6              # tcp
  from_port      = var.https_port # 443
  to_port        = var.https_port # 443
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_tx_https_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 18302
  egress          = true
  rule_action     = "allow"
  protocol        = 6              # tcp
  from_port       = var.https_port # 443
  to_port         = var.https_port # 443
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_rx_https_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 19301
  egress         = false
  rule_action    = "allow"
  protocol       = 6              # tcp
  from_port      = var.https_port # 443
  to_port        = var.https_port # 443
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_rx_https_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 19302
  egress          = false
  rule_action     = "allow"
  protocol        = 6              # tcp
  from_port       = var.https_port # 443
  to_port         = var.https_port # 443
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_tx_https_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 20301
  egress         = true
  rule_action    = "allow"
  protocol       = 6              # tcp
  from_port      = var.https_port # 443
  to_port        = var.https_port # 443
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_tx_https_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 20302
  egress          = true
  rule_action     = "allow"
  protocol        = 6              # tcp
  from_port       = var.https_port # 443
  to_port         = var.https_port # 443
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_rx_https_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 21301
  egress         = false
  rule_action    = "allow"
  protocol       = 6              # tcp
  from_port      = var.https_port # 443
  to_port        = var.https_port # 443
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_rx_https_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 21302
  egress          = false
  rule_action     = "allow"
  protocol        = 6              # tcp
  from_port       = var.https_port # 443
  to_port         = var.https_port # 443
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_tx_https_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 22301
  egress         = true
  rule_action    = "allow"
  protocol       = 6              # tcp
  from_port      = var.https_port # 443
  to_port        = var.https_port # 443
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_tx_https_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 22302
  egress          = true
  rule_action     = "allow"
  protocol        = 6              # tcp
  from_port       = var.https_port # 443
  to_port         = var.https_port # 443
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

resource "aws_vpc_security_group_ingress_rule" "public_rx_https_ipv4" {
  count             = length(var.external_ipv4_addrs)
  security_group_id = data.aws_security_group.public.id
  cidr_ipv4         = element(var.external_ipv4_addrs[*], count.index)
  ip_protocol       = 6              # tcp
  from_port         = var.https_port # 443
  to_port           = var.https_port # 443
  description       = "Application requests"

  tags = {
    Name = "sgr-${var.basename}-pub-dst${count.index}-https-ipv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_rx_https_ipv6" {
  count             = length(var.external_ipv6_addrs)
  security_group_id = data.aws_security_group.public.id
  cidr_ipv6         = element(var.external_ipv6_addrs[*], count.index)
  ip_protocol       = 6              # tcp
  from_port         = var.https_port # 443
  to_port           = var.https_port # 443
  description       = "Application requests"

  tags = {
    Name = "sgr-${var.basename}-pub-dst${count.index}-https-ipv6"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_rx_https_ipv4" {
  count             = length(var.external_ipv4_addrs)
  security_group_id = data.aws_security_group.private.id
  cidr_ipv4         = element(var.external_ipv4_addrs[*], count.index)
  ip_protocol       = 6              # tcp
  from_port         = var.https_port # 443
  to_port           = var.https_port # 443
  description       = "Application requests"

  tags = {
    Name = "sgr-${var.basename}-priv-dst${count.index}-https-ipv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_rx_https_ipv6" {
  count             = length(var.external_ipv6_addrs)
  security_group_id = data.aws_security_group.private.id
  cidr_ipv6         = element(var.external_ipv6_addrs[*], count.index)
  ip_protocol       = 6              # tcp
  from_port         = var.https_port # 443
  to_port           = var.https_port # 443
  description       = "Application requests"

  tags = {
    Name = "sgr-${var.basename}-priv-dst${count.index}-https-ipv6"
  }
}

resource "aws_vpc_security_group_ingress_rule" "secure_rx_https_ipv4" {
  count             = length(var.external_ipv4_addrs)
  security_group_id = data.aws_security_group.secure.id
  cidr_ipv4         = element(var.external_ipv4_addrs[*], count.index)
  ip_protocol       = 6              # tcp
  from_port         = var.https_port # 443
  to_port           = var.https_port # 443
  description       = "Application requests"

  tags = {
    Name = "sgr-${var.basename}-sec-dst${count.index}-https-ipv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "secure_rx_https_ipv6" {
  count             = length(var.external_ipv6_addrs)
  security_group_id = data.aws_security_group.secure.id
  cidr_ipv6         = element(var.external_ipv6_addrs[*], count.index)
  ip_protocol       = 6              # tcp
  from_port         = var.https_port # 443
  to_port           = var.https_port # 443
  description       = "Application requests"

  tags = {
    Name = "sgr-${var.basename}-sec-dst${count.index}-https-ipv6"
  }
}
