/*
 ____   ____              _
/ ___| / ___|  _ __ _   _| | ___  ___
\___ \| |  _  | '__| | | | |/ _ \/ __|
 ___) | |_| | | |  | |_| | |  __/\__ \
|____/ \____| |_|   \__,_|_|\___||___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

# Allow all outbound traffic to go anywhere from any subnets
# Allow all inbound traffic to freely-enter the "same-tier" subnets
# Allow all inbound traffic to freely-enter the "different-tier" subnets
# Allow all inbound ICMP, HTTPS, SSH traffic to freely-enter all subnets

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
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub_tx_ipv6" {
  security_group_id = aws_security_group.public.id
  type              = "egress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "priv_tx_ipv4" {
  security_group_id = aws_security_group.private.id
  type              = "egress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "priv_tx_ipv6" {
  security_group_id = aws_security_group.private.id
  type              = "egress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "sec_tx_ipv4" {
  security_group_id = aws_security_group.secure.id
  type              = "egress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sec_tx_ipv6" {
  security_group_id = aws_security_group.secure.id
  type              = "egress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  ipv6_cidr_blocks  = ["::/0"]
}

/*
                   _       _                           _
                  (_)_ __ | |_ ___ _ __      ___ _   _| |__
                  | | '_ \| __/ _ \ '__|____/ __| | | | '_ \
                  | | | | | ||  __/ | |_____\__ \ |_| | |_) |
                  |_|_| |_|\__\___|_|       |___/\__,_|_.__/
*/

resource "aws_security_group_rule" "pub_rx_self" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  self              = true
}

resource "aws_security_group_rule" "priv_rx_self" {
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = -1  # all
  from_port         = 0   # ignored
  to_port           = 0   # ignored
  self              = true
}

resource "aws_security_group_rule" "sec_rx_self" {
  security_group_id = aws_security_group.secure.id
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
  security_group_id        = aws_security_group.public.id
  type                     = "ingress"
  protocol                 = -1  # all
  from_port                = 0   # ignored
  to_port                  = 0   # ignored
  source_security_group_id = aws_security_group.private.id
}

resource "aws_security_group_rule" "priv_rx_pub" {
  security_group_id        = aws_security_group.private.id
  type                     = "ingress"
  protocol                 = -1  # all
  from_port                = 0   # ignored
  to_port                  = 0   # ignored
  source_security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "priv_rx_sec" {
  security_group_id        = aws_security_group.private.id
  type                     = "ingress"
  protocol                 = -1  # all
  from_port                = 0   # ignored
  to_port                  = 0   # ignored
  source_security_group_id = aws_security_group.secure.id
}

resource "aws_security_group_rule" "sec_rx_priv" {
  security_group_id        = aws_security_group.secure.id
  type                     = "ingress"
  protocol                 = -1  # all
  from_port                = 0   # ignored
  to_port                  = 0   # ignored
  source_security_group_id = aws_security_group.private.id
}

/*
                             _
                            (_) ___ _ __ ___  _ __
                            | |/ __| '_ ` _ \| '_ \
                            | | (__| | | | | | |_) |
                            |_|\___|_| |_| |_| .__/
                                             |_|
*/

resource "aws_security_group_rule" "pub_rx_icmpv4" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  protocol          = "icmp"  # 1
  from_port         = -1      # all
  to_port           = -1      # all
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub_rx_icmpv6" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  protocol          = 58  # icmpv6
  from_port         = -1  # all
  to_port           = -1  # all
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "priv_rx_icmpv4" {
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = "icmp"  # 1
  from_port         = -1      # all
  to_port           = -1      # all
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "priv_rx_icmpv6" {
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = 58  # icmpv6
  from_port         = -1  # all
  to_port           = -1  # all
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "sec_rx_icmpv4" {
  security_group_id = aws_security_group.secure.id
  type              = "ingress"
  protocol          = "icmp"  # 1
  from_port         = -1      # all
  to_port           = -1      # all
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sec_rx_icmpv6" {
  security_group_id = aws_security_group.secure.id
  type              = "ingress"
  protocol          = 58  # icmpv6
  from_port         = -1  # all
  to_port           = -1  # all
  ipv6_cidr_blocks  = ["::/0"]
}

/*
                            _     _   _
                           | |__ | |_| |_ _ __  ___
                           | '_ \| __| __| '_ \/ __|
                           | | | | |_| |_| |_) \__ \
                           |_| |_|\__|\__| .__/|___/
                                         |_|
*/

resource "aws_security_group_rule" "pub_rx_https_ipv4" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 443    # https
  to_port           = 443    # https
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub_rx_https_ipv6" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 443    # https
  to_port           = 443    # https
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "priv_rx_https_ipv4" {
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 443    # https
  to_port           = 443    # https
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "priv_rx_https_ipv6" {
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 443    # https
  to_port           = 443    # https
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "sec_rx_https_ipv4" {
  security_group_id = aws_security_group.secure.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 443    # https
  to_port           = 443    # https
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sec_rx_https_ipv6" {
  security_group_id = aws_security_group.secure.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 443    # https
  to_port           = 443    # https
  ipv6_cidr_blocks  = ["::/0"]
}

/*
                                         _
                                 ___ ___| |__
                                / __/ __| '_ \
                                \__ \__ \ | | |
                                |___/___/_| |_|
*/

resource "aws_security_group_rule" "pub_rx_ssh_ipv4" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 22     # ssh
  to_port           = 22     # ssh
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub_rx_ssh_ipv6" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 22     # ssh
  to_port           = 22     # ssh
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "priv_rx_ssh_ipv4" {
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 22     # ssh
  to_port           = 22     # ssh
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "priv_rx_ssh_ipv6" {
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 22     # ssh
  to_port           = 22     # ssh
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "sec_rx_ssh_ipv4" {
  security_group_id = aws_security_group.secure.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 22     # ssh
  to_port           = 22     # ssh
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sec_rx_ssh_ipv6" {
  security_group_id = aws_security_group.secure.id
  type              = "ingress"
  protocol          = "tcp"  # 6
  from_port         = 22     # ssh
  to_port           = 22     # ssh
  ipv6_cidr_blocks  = ["::/0"]
}
