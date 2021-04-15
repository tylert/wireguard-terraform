/*
 _                   _
(_)_ __  _ __  _   _| |_ ___
| | '_ \| '_ \| | | | __/ __|
| | | | | |_) | |_| | |_\__ \
|_|_| |_| .__/ \__,_|\__|___/
        |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_acls
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group

data "aws_vpc" "main" {
  tags = {
    Name = "vpc-${var.basename}"
  }
}

data "aws_network_acls" "public" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "acl-${var.basename}-pub"
  }
}

data "aws_network_acls" "private" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "acl-${var.basename}-priv"
  }
}

data "aws_network_acls" "secure" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "acl-${var.basename}-sec"
  }
}

data "aws_security_group" "public" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "sg-${var.basename}-pub"
  }
}

data "aws_security_group" "private" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "sg-${var.basename}-priv"
  }
}

data "aws_security_group" "secure" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "sg-${var.basename}-sec"
  }
}
