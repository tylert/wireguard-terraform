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
  name        = "sg-${var.basename}-public"  # Group Name / supports name_prefix
  description = "sg-${var.basename}-public"

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
  name        = "sg-${var.basename}-private"  # Group Name / supports name_prefix
  description = "sg-${var.basename}-private"

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
  name        = "sg-${var.basename}-secure"  # Group Name / supports name_prefix
  description = "sg-${var.basename}-secure"

  tags = {
    Name = "sg-${var.basename}-secure"
  }
}
