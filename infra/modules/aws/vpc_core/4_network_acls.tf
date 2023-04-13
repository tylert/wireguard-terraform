/*
            _                      _                 _
 _ __   ___| |___      _____  _ __| | __   __ _  ___| |___
| '_ \ / _ \ __\ \ /\ / / _ \| '__| |/ /  / _` |/ __| / __|
| | | |  __/ |_ \ V  V / (_) | |  |   <  | (_| | (__| \__ \
|_| |_|\___|\__| \_/\_/ \___/|_|  |_|\_\  \__,_|\___|_|___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_association

/*
                            _       __             _ _
                         __| | ___ / _| __ _ _   _| | |_
                        / _` |/ _ \ |_ / _` | | | | | __|
                       | (_| |  __/  _| (_| | |_| | | |_
                        \__,_|\___|_|  \__,_|\__,_|_|\__|
*/

# Creating a new VPC forces the creation of a new default NACL.
# We want to tag it with something that indicates which VPC it belongs with.
# However, when you try to tag it with Terraform, the rules get flushed.
# Just put back the rules that got flushed so we're left with a stock one.
# We will simply ignore this resource as it is not required for our use case.

resource "aws_default_network_acl" "main" {
  count                  = true == var.preserve_default_rules ? 1 : 0
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = -1 # all
    from_port  = 0  # ignored
    to_port    = 0  # ignored
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    rule_no         = 101
    action          = "allow"
    protocol        = -1 # all
    from_port       = 0  # ignored
    to_port         = 0  # ignored
    ipv6_cidr_block = "::/0"
  }

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = -1 # all
    from_port  = 0  # ignored
    to_port    = 0  # ignored
    cidr_block = "0.0.0.0/0"
  }

  egress {
    rule_no         = 101
    action          = "allow"
    protocol        = -1 # all
    from_port       = 0  # ignored
    to_port         = 0  # ignored
    ipv6_cidr_block = "::/0"
  }

  tags = {
    Name = "acl-${var.basename}-def"
  }
}

# This resource can be selected if you are working under a restriction to not
# have any rules in your default NACL even if you aren't using it but still
# want to tag the resource to denote which VPC it belongs with.

resource "aws_default_network_acl" "main_tainted" {
  count                  = false == var.preserve_default_rules ? 1 : 0
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  tags = {
    Name = "acl-${var.basename}-def"
  }
}

/*
                                       _     _ _
                           _ __  _   _| |__ | (_) ___
                          | '_ \| | | | '_ \| | |/ __|
                          | |_) | |_| | |_) | | | (__
                          | .__/ \__,_|_.__/|_|_|\___|
                          |_|
*/

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "acl-${var.basename}-pub"
  }
}

resource "aws_network_acl_association" "public" {
  count          = length(aws_subnet.public_az)
  network_acl_id = aws_network_acl.public.id
  subnet_id      = element(aws_subnet.public_az[*].id, count.index)
}

/*
                                   _            _
                        _ __  _ __(_)_   ____ _| |_ ___
                       | '_ \| '__| \ \ / / _` | __/ _ \
                       | |_) | |  | |\ V / (_| | ||  __/
                       | .__/|_|  |_| \_/ \__,_|\__\___|
                       |_|
*/

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "acl-${var.basename}-priv"
  }
}

resource "aws_network_acl_association" "private" {
  count          = length(aws_subnet.private_az)
  network_acl_id = aws_network_acl.private.id
  subnet_id      = element(aws_subnet.private_az[*].id, count.index)
}

/*
                          ___  ___  ___ _   _ _ __ ___
                         / __|/ _ \/ __| | | | '__/ _ \
                         \__ \  __/ (__| |_| | | |  __/
                         |___/\___|\___|\__,_|_|  \___|
*/

resource "aws_network_acl" "secure" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "acl-${var.basename}-sec"
  }
}

resource "aws_network_acl_association" "secure" {
  count          = length(aws_subnet.secure_az)
  network_acl_id = aws_network_acl.secure.id
  subnet_id      = element(aws_subnet.secure_az[*].id, count.index)
}
