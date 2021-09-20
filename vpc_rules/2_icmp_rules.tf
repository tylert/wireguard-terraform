/*
 _                                   _
(_) ___ _ __ ___  _ __    _ __ _   _| | ___  ___
| |/ __| '_ ` _ \| '_ \  | '__| | | | |/ _ \/ __|
| | (__| | | | | | |_) | | |  | |_| | |  __/\__ \
|_|\___|_| |_| |_| .__/  |_|   \__,_|_|\___||___/
                 |_|
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

resource "aws_network_acl_rule" "public_rx_icmpv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 17101
  egress         = false
  rule_action    = "allow"
  protocol       = "icmp" # 1
  icmp_type      = -1     # all
  icmp_code      = -1     # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_rx_icmpv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 17102
  egress          = false
  rule_action     = "allow"
  protocol        = 58 # icmpv6
  icmp_type       = -1 # all
  icmp_code       = -1 # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "public_tx_icmpv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 18101
  egress         = true
  rule_action    = "allow"
  protocol       = "icmp" # 1
  icmp_type      = -1     # all
  icmp_code      = -1     # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_tx_icmpv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 18102
  egress          = true
  rule_action     = "allow"
  protocol        = 58 # icmpv6
  icmp_type       = -1 # all
  icmp_code       = -1 # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_rx_icmpv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 19101
  egress         = false
  rule_action    = "allow"
  protocol       = "icmp" # 1
  icmp_type      = -1     # all
  icmp_code      = -1     # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_rx_icmpv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 19102
  egress          = false
  rule_action     = "allow"
  protocol        = 58 # icmpv6
  icmp_type       = -1 # all
  icmp_code       = -1 # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_tx_icmpv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 20101
  egress         = true
  rule_action    = "allow"
  protocol       = "icmp" # 1
  icmp_type      = -1     # all
  icmp_code      = -1     # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_tx_icmpv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 20102
  egress          = true
  rule_action     = "allow"
  protocol        = 58 # icmpv6
  icmp_type       = -1 # all
  icmp_code       = -1 # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_rx_icmpv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 21101
  egress         = false
  rule_action    = "allow"
  protocol       = "icmp" # 1
  icmp_type      = -1     # all
  icmp_code      = -1     # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_rx_icmpv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 21102
  egress          = false
  rule_action     = "allow"
  protocol        = 58 # icmpv6
  icmp_type       = -1 # all
  icmp_code       = -1 # all
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_tx_icmpv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 22101
  egress         = true
  rule_action    = "allow"
  protocol       = "icmp" # 1
  icmp_type      = -1     # all
  icmp_code      = -1     # all
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_tx_icmpv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 22102
  egress          = true
  rule_action     = "allow"
  protocol        = 58 # icmpv6
  icmp_type       = -1 # all
  icmp_code       = -1 # all
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

# XXX FIXME TODO https://github.com/hashicorp/terraform-provider-aws/issues/15982

# Don't worry if you see Error finding matching ingress Security Group Rule
# errors for the 3 ingress ICMPv6 rules here.  Terraform thinks these resources
# are missing, however AWS definitely has them.  Due to this bug, manual
# operations relating to these 3 rules may be required.

resource "aws_security_group_rule" "public_rx_icmpv4" {
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = "icmp" # 1
  from_port         = -1     # all
  to_port           = -1     # all
  cidr_blocks       = ["0.0.0.0/0"]
  description       = ""
}

resource "aws_security_group_rule" "public_rx_icmpv6" {
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = 58 # icmpv6
  from_port         = -1 # all
  to_port           = -1 # all
  ipv6_cidr_blocks  = ["::/0"]
  description       = ""
}

resource "aws_security_group_rule" "private_rx_icmpv4" {
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = "icmp" # 1
  from_port         = -1     # all
  to_port           = -1     # all
  cidr_blocks       = ["0.0.0.0/0"]
  description       = ""
}

resource "aws_security_group_rule" "private_rx_icmpv6" {
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = 58 # icmpv6
  from_port         = -1 # all
  to_port           = -1 # all
  ipv6_cidr_blocks  = ["::/0"]
  description       = ""
}

resource "aws_security_group_rule" "secure_rx_icmpv4" {
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = "icmp" # 1
  from_port         = -1     # all
  to_port           = -1     # all
  cidr_blocks       = ["0.0.0.0/0"]
  description       = ""
}

resource "aws_security_group_rule" "secure_rx_icmpv6" {
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = 58 # icmpv6
  from_port         = -1 # all
  to_port           = -1 # all
  ipv6_cidr_blocks  = ["::/0"]
  description       = ""
}
