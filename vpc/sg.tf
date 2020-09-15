# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

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

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol  = "-1"
    from_port = "0"
    to_port   = "0"
    self      = true
  }

  egress {
    protocol    = "-1"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = "0"
    to_port          = "0"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.basename}-sg-def"
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
  name        = "${var.basename}-sg-pub" # Group Name / supports name_prefix
  description = "${var.basename}-sg-pub"

  tags = {
    Name = "${var.basename}-sg-pub"
  }
}

resource "aws_security_group_rule" "ingress_public" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  protocol          = "-1"
  from_port         = "0"
  to_port           = "0"
  self              = true
}

resource "aws_security_group_rule" "egress_public_ipv4" {
  security_group_id = aws_security_group.public.id
  type              = "egress"
  protocol          = "-1"
  from_port         = "0"
  to_port           = "0"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_public_ipv6" {
  security_group_id = aws_security_group.public.id
  type              = "egress"
  protocol          = "-1"
  from_port         = "0"
  to_port           = "0"
  ipv6_cidr_blocks  = ["::/0"]
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
  name        = "${var.basename}-sg-priv" # Group Name / supports name_prefix
  description = "${var.basename}-sg-priv"

  tags = {
    Name = "${var.basename}-sg-priv"
  }
}

resource "aws_security_group_rule" "ingress_private" {
  security_group_id        = aws_security_group.private.id
  type                     = "ingress"
  protocol                 = "-1"
  from_port                = "0"
  to_port                  = "0"
  source_security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "egress_private_ipv4" {
  security_group_id = aws_security_group.private.id
  type              = "egress"
  protocol          = "-1"
  from_port         = "0"
  to_port           = "0"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_private_ipv6" {
  security_group_id = aws_security_group.private.id
  type              = "egress"
  protocol          = "-1"
  from_port         = "0"
  to_port           = "0"
  ipv6_cidr_blocks  = ["::/0"]
}

/*
                         _
 ___  __ _       ___ ___| |__
/ __|/ _` |_____/ __/ __| '_ \
\__ \ (_| |_____\__ \__ \ | | |
|___/\__, |     |___/___/_| |_|
     |___/
*/

resource "aws_security_group" "ssh" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.basename}-sg-ssh" # Group Name / supports name_prefix
  description = "${var.basename}-sg-ssh"

  tags = {
    Name = "${var.basename}-sg-ssh"
  }
}

resource "aws_security_group_rule" "ingress_ssh_ipv4" {
  security_group_id = aws_security_group.ssh.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "22"
  to_port           = "22"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_ssh_ipv6" {
  security_group_id = aws_security_group.ssh.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "22"
  to_port           = "22"
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "egress_ssh_ipv4" {
  security_group_id = aws_security_group.ssh.id
  type              = "egress"
  protocol          = "-1"
  from_port         = "0"
  to_port           = "0"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_ssh_ipv6" {
  security_group_id = aws_security_group.ssh.id
  type              = "egress"
  protocol          = "-1"
  from_port         = "0"
  to_port           = "0"
  ipv6_cidr_blocks  = ["::/0"]
}
