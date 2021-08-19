/*
                 _       _     _
__   ____ _ _ __(_) __ _| |__ | | ___  ___
\ \ / / _` | '__| |/ _` | '_ \| |/ _ \/ __|
 \ V / (_| | |  | | (_| | |_) | |  __/\__ \
  \_/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
*/

variable "aws_region" {
  type        = string
  description = "AWS region in which to launch all non-global resources"
  # there should be no default for this variable
}

variable "basename" {
  type        = string
  description = "Tag prefix to use for all related resources (e.g.:  test1)"
  # there should be no default for this variable
}

/*
     _       _
  __| | __ _| |_ __ _
 / _` |/ _` | __/ _` |
| (_| | (_| | || (_| |
 \__,_|\__,_|\__\__,_|
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
