/*
 _     _   _                          _
| |__ | |_| |_ _ __  ___   _ __ _   _| | ___  ___
| '_ \| __| __| '_ \/ __| | '__| | | | |/ _ \/ __|
| | | | |_| |_| |_) \__ \ | |  | |_| | |  __/\__ \
|_| |_|\__|\__| .__/|___/ |_|   \__,_|_|\___||___/
              |_|
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

resource "aws_network_acl_rule" "public_rx_https_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 17301
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp" # 6
  from_port      = 443   # https
  to_port        = 443   # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_rx_https_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 17302
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp" # 6
  from_port       = 443   # https
  to_port         = 443   # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "public_tx_https_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 18301
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp" # 6
  from_port      = 443   # https
  to_port        = 443   # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_tx_https_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 18302
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp" # 6
  from_port       = 443   # https
  to_port         = 443   # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_rx_https_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 19301
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp" # 6
  from_port      = 443   # https
  to_port        = 443   # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_rx_https_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 19302
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp" # 6
  from_port       = 443   # https
  to_port         = 443   # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_tx_https_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 20301
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp" # 6
  from_port      = 443   # https
  to_port        = 443   # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_tx_https_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 20302
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp" # 6
  from_port       = 443   # https
  to_port         = 443   # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_rx_https_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 21301
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp" # 6
  from_port      = 443   # https
  to_port        = 443   # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_rx_https_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 21302
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp" # 6
  from_port       = 443   # https
  to_port         = 443   # https
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_tx_https_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 22301
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp" # 6
  from_port      = 443   # https
  to_port        = 443   # https
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_tx_https_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 22302
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp" # 6
  from_port       = 443   # https
  to_port         = 443   # https
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

resource "aws_security_group_rule" "public_rx_https_ipv4" {
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp" # 6
  from_port         = 443   # https
  to_port           = 443   # https
  cidr_blocks       = var.external_ipv4_addrs
  description       = ""

  # XXX FIXME TODO The sgr resource doesn't support tags yet!!!
  # tags = {
  #   Name = "sgr-${var.basename}-pub-https-ipv4"
  # }
}

# XXX FIXME TODO https://github.com/hashicorp/terraform-provider-aws/issues/20104#issuecomment-1315912353
resource "aws_ec2_tag" "public_rx_https_ipv4" {
  resource_id = aws_security_group_rule.public_rx_https_ipv4.security_group_rule_id
  key         = "Name"
  value       = "sgr-${var.basename}-pub-https-ipv4"
}

resource "aws_security_group_rule" "public_rx_https_ipv6" {
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp" # 6
  from_port         = 443   # https
  to_port           = 443   # https
  ipv6_cidr_blocks  = var.external_ipv6_addrs
  description       = ""

  # XXX FIXME TODO The sgr resource doesn't support tags yet!!!
  # tags = {
  #   Name = "sgr-${var.basename}-pub-https-ipv6"
  # }
}

# XXX FIXME TODO https://github.com/hashicorp/terraform-provider-aws/issues/20104#issuecomment-1315912353
resource "aws_ec2_tag" "public_rx_https_ipv6" {
  resource_id = aws_security_group_rule.public_rx_https_ipv6.security_group_rule_id
  key         = "Name"
  value       = "sgr-${var.basename}-pub-https-ipv6"
}

resource "aws_security_group_rule" "private_rx_https_ipv4" {
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp" # 6
  from_port         = 443   # https
  to_port           = 443   # https
  cidr_blocks       = var.external_ipv4_addrs
  description       = ""

  # XXX FIXME TODO The sgr resource doesn't support tags yet!!!
  # tags = {
  #   Name = "sgr-${var.basename}-priv-https-ipv4"
  # }
}

# XXX FIXME TODO https://github.com/hashicorp/terraform-provider-aws/issues/20104#issuecomment-1315912353
resource "aws_ec2_tag" "private_rx_https_ipv4" {
  resource_id = aws_security_group_rule.private_rx_https_ipv4.security_group_rule_id
  key         = "Name"
  value       = "sgr-${var.basename}-priv-https-ipv4"
}

resource "aws_security_group_rule" "private_rx_https_ipv6" {
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp" # 6
  from_port         = 443   # https
  to_port           = 443   # https
  ipv6_cidr_blocks  = var.external_ipv6_addrs
  description       = ""

  # XXX FIXME TODO The sgr resource doesn't support tags yet!!!
  # tags = {
  #   Name = "sgr-${var.basename}-priv-https-ipv6"
  # }
}

# XXX FIXME TODO https://github.com/hashicorp/terraform-provider-aws/issues/20104#issuecomment-1315912353
resource "aws_ec2_tag" "private_rx_https_ipv6" {
  resource_id = aws_security_group_rule.private_rx_https_ipv6.security_group_rule_id
  key         = "Name"
  value       = "sgr-${var.basename}-priv-https-ipv6"
}

resource "aws_security_group_rule" "secure_rx_https_ipv4" {
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = "tcp" # 6
  from_port         = 443   # https
  to_port           = 443   # https
  cidr_blocks       = var.external_ipv4_addrs
  description       = ""

  # XXX FIXME TODO The sgr resource doesn't support tags yet!!!
  # tags = {
  #   Name = "sgr-${var.basename}-sec-https-ipv4"
  # }
}

# XXX FIXME TODO https://github.com/hashicorp/terraform-provider-aws/issues/20104#issuecomment-1315912353
resource "aws_ec2_tag" "secure_rx_https_ipv4" {
  resource_id = aws_security_group_rule.secure_rx_https_ipv4.security_group_rule_id
  key         = "Name"
  value       = "sgr-${var.basename}-sec-https-ipv4"
}

resource "aws_security_group_rule" "secure_rx_https_ipv6" {
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = "tcp" # 6
  from_port         = 443   # https
  to_port           = 443   # https
  ipv6_cidr_blocks  = var.external_ipv6_addrs
  description       = ""

  # XXX FIXME TODO The sgr resource doesn't support tags yet!!!
  # tags = {
  #   Name = "sgr-${var.basename}-sec-https-ipv6"
  # }
}

# XXX FIXME TODO https://github.com/hashicorp/terraform-provider-aws/issues/20104#issuecomment-1315912353
resource "aws_ec2_tag" "secure_rx_https_ipv6" {
  resource_id = aws_security_group_rule.secure_rx_https_ipv6.security_group_rule_id
  key         = "Name"
  value       = "sgr-${var.basename}-sec-https-ipv6"
}
