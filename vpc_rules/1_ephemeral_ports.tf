/*
            _                                   _                    _
  ___ _ __ | |__   ___ _ __ ___   ___ _ __ __ _| |  _ __   ___  _ __| |_ ___
 / _ \ '_ \| '_ \ / _ \ '_ ` _ \ / _ \ '__/ _` | | | '_ \ / _ \| '__| __/ __|
|  __/ |_) | | | |  __/ | | | | |  __/ | | (_| | | | |_) | (_) | |  | |_\__ \
 \___| .__/|_| |_|\___|_| |_| |_|\___|_|  \__,_|_| | .__/ \___/|_|   \__|___/
     |_|                                           |_|
*/

# https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html#nacl-ephemeral-ports
# https://en.wikipedia.org/wiki/Ephemeral_port

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule

/*
                     _                          _
                    | |_ ___ _ __    _ __ _   _| | ___  ___
                    | __/ __| '_ \  | '__| | | | |/ _ \/ __|
                    | || (__| |_) | | |  | |_| | |  __/\__ \
                     \__\___| .__/  |_|   \__,_|_|\___||___/
                            |_|
*/

resource "aws_network_acl_rule" "public_rx_ephem_tcp_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 17201
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp" # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_rx_ephem_tcp_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 17202
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp" # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "public_tx_ephem_tcp_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 18201
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp" # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_tx_ephem_tcp_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 18202
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp" # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_rx_ephem_tcp_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 19201
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp" # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_rx_ephem_tcp_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 19202
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp" # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_tx_ephem_tcp_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 20201
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp" # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_tx_ephem_tcp_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 20202
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp" # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_rx_ephem_tcp_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 21201
  egress         = false
  rule_action    = "allow"
  protocol       = "tcp" # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_rx_ephem_tcp_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 21202
  egress          = false
  rule_action     = "allow"
  protocol        = "tcp" # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_tx_ephem_tcp_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 22201
  egress         = true
  rule_action    = "allow"
  protocol       = "tcp" # 6
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_tx_ephem_tcp_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 22202
  egress          = true
  rule_action     = "allow"
  protocol        = "tcp" # 6
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

/*
                             _                    _
                   _   _  __| |_ __    _ __ _   _| | ___  ___
                  | | | |/ _` | '_ \  | '__| | | | |/ _ \/ __|
                  | |_| | (_| | |_) | | |  | |_| | |  __/\__ \
                   \__,_|\__,_| .__/  |_|   \__,_|_|\___||___/
                              |_|
*/

resource "aws_network_acl_rule" "public_rx_ephem_udp_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 17211
  egress         = false
  rule_action    = "allow"
  protocol       = "udp" # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_rx_ephem_udp_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 17212
  egress          = false
  rule_action     = "allow"
  protocol        = "udp" # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "public_tx_ephem_udp_ipv4" {
  network_acl_id = join("", data.aws_network_acls.public.ids)
  rule_number    = 18211
  egress         = true
  rule_action    = "allow"
  protocol       = "udp" # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_tx_ephem_udp_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.public.ids)
  rule_number     = 18212
  egress          = true
  rule_action     = "allow"
  protocol        = "udp" # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_rx_ephem_udp_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 19211
  egress         = false
  rule_action    = "allow"
  protocol       = "udp" # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_rx_ephem_udp_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 19212
  egress          = false
  rule_action     = "allow"
  protocol        = "udp" # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_tx_ephem_udp_ipv4" {
  network_acl_id = join("", data.aws_network_acls.private.ids)
  rule_number    = 20211
  egress         = true
  rule_action    = "allow"
  protocol       = "udp" # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_tx_ephem_udp_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.private.ids)
  rule_number     = 20212
  egress          = true
  rule_action     = "allow"
  protocol        = "udp" # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_rx_ephem_udp_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 21211
  egress         = false
  rule_action    = "allow"
  protocol       = "udp" # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_rx_ephem_udp_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 21212
  egress          = false
  rule_action     = "allow"
  protocol        = "udp" # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "secure_tx_ephem_udp_ipv4" {
  network_acl_id = join("", data.aws_network_acls.secure.ids)
  rule_number    = 22211
  egress         = true
  rule_action    = "allow"
  protocol       = "udp" # 17
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "secure_tx_ephem_udp_ipv6" {
  network_acl_id  = join("", data.aws_network_acls.secure.ids)
  rule_number     = 22212
  egress          = true
  rule_action     = "allow"
  protocol        = "udp" # 17
  from_port       = 1024
  to_port         = 65535
  ipv6_cidr_block = "::/0"
}
