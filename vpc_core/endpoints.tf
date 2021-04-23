/*
                _             _       _
  ___ _ __   __| |_ __   ___ (_)_ __ | |_ ___
 / _ \ '_ \ / _` | '_ \ / _ \| | '_ \| __/ __|
|  __/ | | | (_| | |_) | (_) | | | | | |_\__ \
 \___|_| |_|\__,_| .__/ \___/|_|_| |_|\__|___/
                 |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint

/*
                                       _     _ _
                           _ __  _   _| |__ | (_) ___
                          | '_ \| | | | '_ \| | |/ __|
                          | |_) | |_| | |_) | | | (__
                          | .__/ \__,_|_.__/|_|_|\___|
                          |_|
*/

resource "aws_vpc_endpoint" "pub_ec2messages" {
  service_name = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_id       = aws_vpc.main.id
  subnet_ids   = aws_subnet.public_az[*].id

  tags = {
    Name = "vpce-${var.basename}-pub-ec2msgs"
  }
}

resource "aws_vpc_endpoint" "pub_ssm" {
  service_name = "com.amazonaws.${var.aws_region}.ssm"
  vpc_id       = aws_vpc.main.id
  subnet_ids   = aws_subnet.public_az[*].id

  tags = {
    Name = "vpce-${var.basename}-pub-ssm"
  }
}

resource "aws_vpc_endpoint" "pub_ssmmessages" {
  service_name = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_id       = aws_vpc.main.id
  subnet_ids   = aws_subnet.public_az[*].id

  tags = {
    Name = "vpce-${var.basename}-pub-ssmmsgs"
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

resource "aws_vpc_endpoint" "priv_ec2messages" {
  service_name = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_id       = aws_vpc.main.id
  subnet_ids   = aws_subnet.private_az[*].id

  tags = {
    Name = "vpce-${var.basename}-priv-ec2msgs"
  }
}

resource "aws_vpc_endpoint" "priv_ssm" {
  service_name = "com.amazonaws.${var.aws_region}.ssm"
  vpc_id       = aws_vpc.main.id
  subnet_ids   = aws_subnet.private_az[*].id

  tags = {
    Name = "vpce-${var.basename}-priv-ssm"
  }
}

resource "aws_vpc_endpoint" "priv_ssmmessages" {
  service_name = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_id       = aws_vpc.main.id
  subnet_ids   = aws_subnet.private_az[*].id

  tags = {
    Name = "vpce-${var.basename}-priv-ssmmsgs"
  }
}

/*
                          ___  ___  ___ _   _ _ __ ___
                         / __|/ _ \/ __| | | | '__/ _ \
                         \__ \  __/ (__| |_| | | |  __/
                         |___/\___|\___|\__,_|_|  \___|
*/

resource "aws_vpc_endpoint" "sec_ec2messages" {
  service_name = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_id       = aws_vpc.main.id
  subnet_ids   = aws_subnet.secure_az[*].id

  tags = {
    Name = "vpce-${var.basename}-sec-ec2msgs"
  }
}

resource "aws_vpc_endpoint" "sec_ssm" {
  service_name = "com.amazonaws.${var.aws_region}.ssm"
  vpc_id       = aws_vpc.main.id
  subnet_ids   = aws_subnet.secure_az[*].id

  tags = {
    Name = "vpce-${var.basename}-sec-ssm"
  }
}

resource "aws_vpc_endpoint" "sec_ssmmessages" {
  service_name = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_id       = aws_vpc.main.id
  subnet_ids   = aws_subnet.secure_az[*].id

  tags = {
    Name = "vpce-${var.basename}-sec-ssmmsgs"
  }
}
