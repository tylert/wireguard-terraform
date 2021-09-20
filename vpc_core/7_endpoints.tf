/*
                _             _       _
  ___ _ __   __| |_ __   ___ (_)_ __ | |_ ___
 / _ \ '_ \ / _` | '_ \ / _ \| | '_ \| __/ __|
|  __/ | | | (_| | |_) | (_) | | | | | |_\__ \
 \___|_| |_|\__,_| .__/ \___/|_|_| |_|\__|___/
                 |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint

# https://aws.amazon.com/premiumsupport/knowledge-center/ec2-systems-manager-vpc-endpoints/
# https://crishantha.medium.com/handling-vpc-endpoints-ac192b0361a5

/*
                                       _     _ _
                           _ __  _   _| |__ | (_) ___
                          | '_ \| | | | '_ \| | |/ __|
                          | |_) | |_| | |_) | | | (__
                          | .__/ \__,_|_.__/|_|_|\___|
                          |_|
*/

resource "aws_vpc_endpoint" "public_s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.public_az[*].id

  tags = {
    Name = "vpce-${var.basename}-pub-s3"
  }
}

resource "aws_vpc_endpoint" "public_ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.public.id]
  subnet_ids          = aws_subnet.public_az[*].id

  tags = {
    Name = "vpce-${var.basename}-pub-ssm"
  }
}

resource "aws_vpc_endpoint" "public_ec2_msgs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.public.id]
  subnet_ids          = aws_subnet.public_az[*].id

  tags = {
    Name = "vpce-${var.basename}-pub-ec2-msgs"
  }
}

resource "aws_vpc_endpoint" "public_ssm_msgs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.public.id]
  subnet_ids          = aws_subnet.public_az[*].id

  tags = {
    Name = "vpce-${var.basename}-pub-ssm-msgs"
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

resource "aws_vpc_endpoint" "private_s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private_az[*].id

  tags = {
    Name = "vpce-${var.basename}-priv-s3"
  }
}

resource "aws_vpc_endpoint" "private_ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.private.id]
  subnet_ids          = aws_subnet.private_az[*].id

  tags = {
    Name = "vpce-${var.basename}-priv-ssm"
  }
}

resource "aws_vpc_endpoint" "private_ec2_msgs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.private.id]
  subnet_ids          = aws_subnet.private_az[*].id

  tags = {
    Name = "vpce-${var.basename}-priv-ec2-msgs"
  }
}

resource "aws_vpc_endpoint" "private_ssm_msgs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.private.id]
  subnet_ids          = aws_subnet.private_az[*].id

  tags = {
    Name = "vpce-${var.basename}-priv-ssm-msgs"
  }
}

/*
                          ___  ___  ___ _   _ _ __ ___
                         / __|/ _ \/ __| | | | '__/ _ \
                         \__ \  __/ (__| |_| | | |  __/
                         |___/\___|\___|\__,_|_|  \___|
*/

resource "aws_vpc_endpoint" "secure_s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.secure_az[*].id

  tags = {
    Name = "vpce-${var.basename}-sec-s3"
  }
}

resource "aws_vpc_endpoint" "secure_ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.secure.id]
  subnet_ids          = aws_subnet.secure_az[*].id

  tags = {
    Name = "vpce-${var.basename}-sec-ssm"
  }
}

resource "aws_vpc_endpoint" "secure_ec2_msgs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.secure.id]
  subnet_ids          = aws_subnet.secure_az[*].id

  tags = {
    Name = "vpce-${var.basename}-sec-ec2-msgs"
  }
}

resource "aws_vpc_endpoint" "secure_ssm_msgs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.secure.id]
  subnet_ids          = aws_subnet.secure_az[*].id

  tags = {
    Name = "vpce-${var.basename}-sec-ssm-msgs"
  }
}
