/*
                          _ _
 ___  ___  ___ _   _ _ __(_) |_ _   _    __ _ _ __ ___  _   _ _ __  ___
/ __|/ _ \/ __| | | | '__| | __| | | |  / _` | '__/ _ \| | | | '_ \/ __|
\__ \  __/ (__| |_| | |  | | |_| |_| | | (_| | | | (_) | |_| | |_) \__ \
|___/\___|\___|\__,_|_|  |_|\__|\__, |  \__, |_|  \___/ \__,_| .__/|___/
                                |___/   |___/                |_|
*/

# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/default_security_group
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/security_group

/*
                            _       __             _ _
                         __| | ___ / _| __ _ _   _| | |_
                        / _` |/ _ \ |_ / _` | | | | | __|
                       | (_| |  __/  _| (_| | |_| | | |_
                        \__,_|\___|_|  \__,_|\__,_|_|\__|
*/

# Creating a new VPC forces the creation of a new default SG.
# We want to tag it with something that indicates which VPC it belongs with.
# However, when you try to tag it with Terraform, the rules get flushed.
# Just put back the rules that got flushed so we're left with a stock one.
# We will simply ignore this resource as it is not required for our use case.

resource "aws_default_security_group" "main" {
  count  = true == var.preserve_default_rules ? 1 : 0
  vpc_id = aws_vpc.main.id

  ingress {
    protocol  = -1 # all
    from_port = 0  # ignored
    to_port   = 0  # ignored
    self      = true
  }

  egress {
    protocol    = -1 # all
    from_port   = 0  # ignored
    to_port     = 0  # ignored
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol         = -1 # all
    from_port        = 0  # ignored
    to_port          = 0  # ignored
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-${var.basename}-def"
  }
}

# This resource can be selected if you are working under a restriction to not
# have any rules in your default SG even if you aren't using it but still want
# to tag the resource to denote which VPC it belongs with.

resource "aws_default_security_group" "main_tainted" {
  count  = false == var.preserve_default_rules ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sg-${var.basename}-def"
  }
}

# The "name" in the sg resource is "Security group name" in the web console columns.
# The "description" in the sg resource is "Description" in the web console columns.
# The tag "Name" in the sg resource is "Name" in the web console columns.

/*
                                       _     _ _
                           _ __  _   _| |__ | (_) ___
                          | '_ \| | | | '_ \| | |/ __|
                          | |_) | |_| | |_) | | | (__
                          | .__/ \__,_|_.__/|_|_|\___|
                          |_|
*/

resource "aws_security_group" "public" {
  vpc_id                 = aws_vpc.main.id                 # change forces new resource
  name                   = "public"                        # change forces new resource
  description            = "vpc-${var.basename} public sg" # change forces new resource
  revoke_rules_on_delete = false

  tags = {
    Name = "sg-${var.basename}-pub"
  }
}

/*
                                   _            _
                        _ __  _ __(_)_   ____ _| |_ ___
                       | '_ \| '__| \ \ / / _` | __/ _ \
                       | |_) | |  | |\ V / (_| | ||  __/
                       | .__/|_|  |_| \_/ \__,_|\__\___|
                       |_|
*/

resource "aws_security_group" "private" {
  vpc_id                 = aws_vpc.main.id                  # change forces new resource
  name                   = "private"                        # change forces new resource
  description            = "vpc-${var.basename} private sg" # change forces new resource
  revoke_rules_on_delete = false

  tags = {
    Name = "sg-${var.basename}-priv"
  }
}

/*
                          ___  ___  ___ _   _ _ __ ___
                         / __|/ _ \/ __| | | | '__/ _ \
                         \__ \  __/ (__| |_| | | |  __/
                         |___/\___|\___|\__,_|_|  \___|
*/

resource "aws_security_group" "secure" {
  vpc_id                 = aws_vpc.main.id                 # change forces new resource
  name                   = "secure"                        # change forces new resource
  description            = "vpc-${var.basename} secure sg" # change forces new resource
  revoke_rules_on_delete = false

  tags = {
    Name = "sg-${var.basename}-sec"
  }
}
