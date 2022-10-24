/*
                            _
__      ____ _   _ __ _   _| | ___  ___
\ \ /\ / / _` | | '__| | | | |/ _ \/ __|
 \ V  V / (_| | | |  | |_| | |  __/\__ \
  \_/\_/ \__, | |_|   \__,_|_|\___||___/
         |___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

/*
                                              _
                       ___  __ _   _ __ _   _| | ___  ___
                      / __|/ _` | | '__| | | | |/ _ \/ __|
                      \__ \ (_| | | |  | |_| | |  __/\__ \
                      |___/\__, | |_|   \__,_|_|\___||___/
                           |___/
*/

resource "aws_security_group_rule" "public_rx_wg_ipv4" {
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = "udp"              # 17
  from_port         = var.wireguard_port # wireguard
  to_port           = var.wireguard_port # wireguard
  cidr_blocks       = ["0.0.0.0/0"]
  description       = ""

  # XXX FIXME TODO The sgr resource doesn't support tags yet!!!
  # tags = {
  #   Name = ""
  # }
}

resource "aws_security_group_rule" "public_rx_wg_ipv6" {
  security_group_id = data.aws_security_group.public.id
  type              = "ingress"
  protocol          = "udp"              # 17
  from_port         = var.wireguard_port # wireguard
  to_port           = var.wireguard_port # wireguard
  ipv6_cidr_blocks  = ["::/0"]
  description       = ""

  # XXX FIXME TODO The sgr resource doesn't support tags yet!!!
  # tags = {
  #   Name = ""
  # }
}

resource "aws_security_group_rule" "private_rx_wg_ipv4" {
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = "udp"              # 17
  from_port         = var.wireguard_port # wireguard
  to_port           = var.wireguard_port # wireguard
  cidr_blocks       = ["0.0.0.0/0"]
  description       = ""

  # XXX FIXME TODO The sgr resource doesn't support tags yet!!!
  # tags = {
  #   Name = ""
  # }
}

resource "aws_security_group_rule" "private_rx_wg_ipv6" {
  security_group_id = data.aws_security_group.private.id
  type              = "ingress"
  protocol          = "udp"              # 17
  from_port         = var.wireguard_port # wireguard
  to_port           = var.wireguard_port # wireguard
  ipv6_cidr_blocks  = ["::/0"]
  description       = ""

  # XXX FIXME TODO The sgr resource doesn't support tags yet!!!
  # tags = {
  #   Name = ""
  # }
}

resource "aws_security_group_rule" "secure_rx_wg_ipv4" {
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = "udp"              # 17
  from_port         = var.wireguard_port # wireguard
  to_port           = var.wireguard_port # wireguard
  cidr_blocks       = ["0.0.0.0/0"]
  description       = ""

  # XXX FIXME TODO The sgr resource doesn't support tags yet!!!
  # tags = {
  #   Name = ""
  # }
}

resource "aws_security_group_rule" "secure_rx_wg_ipv6" {
  security_group_id = data.aws_security_group.secure.id
  type              = "ingress"
  protocol          = "udp"              # 17
  from_port         = var.wireguard_port # wireguard
  to_port           = var.wireguard_port # wireguard
  ipv6_cidr_blocks  = ["::/0"]
  description       = ""

  # XXX FIXME TODO The sgr resource doesn't support tags yet!!!
  # tags = {
  #   Name = ""
  # }
}
