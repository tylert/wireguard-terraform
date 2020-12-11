/*
                          _ _
 ___  ___  ___ _   _ _ __(_) |_ _   _    __ _ _ __ ___  _   _ _ __  ___
/ __|/ _ \/ __| | | | '__| | __| | | |  / _` | '__/ _ \| | | | '_ \/ __|
\__ \  __/ (__| |_| | |  | | |_| |_| | | (_| | | | (_) | |_| | |_) \__ \
|___/\___|\___|\__,_|_|  |_|\__|\__, |  \__, |_|  \___/ \__,_| .__/|___/
                                |___/   |___/                |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group

/*
                                             _       __
                         ___  __ _        __| | ___ / _|
                        / __|/ _` |_____ / _` |/ _ \ |_
                        \__ \ (_| |_____| (_| |  __/  _|
                        |___/\__, |      \__,_|\___|_|
                             |___/
*/

# Creating a new VPC forces the creation of a new default SG.
# We want to tag it with something that indicates which VPC it belongs to.
# However, when you try to tag it with Terraform, the rules get flushed.
# Just put back the rules that got flushed so we're left with a stock one.
# We will simply ignore this resource as it is not required for our use case.

resource "aws_default_security_group" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol  = -1  # all
    from_port = 0   # ignored
    to_port   = 0   # ignored
    self      = true
  }

  egress {
    protocol    = -1  # all
    from_port   = 0   # ignored
    to_port     = 0   # ignored
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol         = -1  # all
    from_port        = 0   # ignored
    to_port          = 0   # ignored
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-${var.basename}-default"
  }
}

/*
                                                   _
                       ___  __ _       _ __  _   _| |__
                      / __|/ _` |_____| '_ \| | | | '_ \
                      \__ \ (_| |_____| |_) | |_| | |_) |
                      |___/\__, |     | .__/ \__,_|_.__/
                           |___/      |_|
*/

resource "aws_security_group" "public" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.basename}-sg-pub"  # Group Name / supports name_prefix
  description = "${var.basename}-sg-pub"

  tags = {
    Name = "sg-${var.basename}-public"
  }
}

/*
                                                  _
                       ___  __ _       _ __  _ __(_)_   __
                      / __|/ _` |_____| '_ \| '__| \ \ / /
                      \__ \ (_| |_____| |_) | |  | |\ V /
                      |___/\__, |     | .__/|_|  |_| \_/
                           |___/      |_|
*/

resource "aws_security_group" "private" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.basename}-sg-priv"  # Group Name / supports name_prefix
  description = "${var.basename}-sg-priv"

  tags = {
    Name = "sg-${var.basename}-private"
  }
}

/*
                         ___  __ _       ___  ___  ___
                        / __|/ _` |_____/ __|/ _ \/ __|
                        \__ \ (_| |_____\__ \  __/ (__
                        |___/\__, |     |___/\___|\___|
                             |___/
*/

resource "aws_security_group" "secure" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.basename}-sg-sec"  # Group Name / supports name_prefix
  description = "${var.basename}-sg-sec"

  tags = {
    Name = "sg-${var.basename}-secure"
  }
}

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
