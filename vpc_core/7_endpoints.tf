/*
                _             _       _
  ___ _ __   __| |_ __   ___ (_)_ __ | |_ ___
 / _ \ '_ \ / _` | '_ \ / _ \| | '_ \| __/ __|
|  __/ | | | (_| | |_) | (_) | | | | | |_\__ \
 \___|_| |_|\__,_| .__/ \___/|_|_| |_|\__|___/
                 |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint

# https://crishantha.medium.com/handling-vpc-endpoints-ac192b0361a5

/*
   ____ _____    ___     ____                                    ____  ____
  / ___|___ /   ( _ )   |  _ \ _   _ _ __   __ _ _ __ ___   ___ |  _ \| __ )
  \___ \ |_ \   / _ \/\ | | | | | | | '_ \ / _` | '_ ` _ \ / _ \| | | |  _ \
   ___) |__) | | (_>  < | |_| | |_| | | | | (_| | | | | | | (_) | |_| | |_) |
  |____/____/   \___/\/ |____/ \__, |_| |_|\__,_|_| |_| |_|\___/|____/|____/
                               |___/
*/

resource "aws_vpc_endpoint" "private_s3" {
  count        = true == var.create_private_endpoints ? 1 : 0
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private_az[*].id

  tags = {
    Name = "vpce-${var.basename}-priv-s3"
  }
}

resource "aws_vpc_endpoint" "secure_s3" {
  count        = true == var.create_private_endpoints ? 1 : 0
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.secure_az[*].id

  tags = {
    Name = "vpce-${var.basename}-sec-s3"
  }
}

/*
                               ____ ____  __  __
                              / ___/ ___||  \/  |
                              \___ \___ \| |\/| |
                               ___) |__) | |  | |
                              |____/____/|_|  |_|
*/

# https://aws.amazon.com/premiumsupport/knowledge-center/ec2-systems-manager-vpc-endpoints/

resource "aws_vpc_endpoint" "private_ssm" {
  count        = true == var.create_private_endpoints ? 1 : 0
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.ssm"

  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_az[*].id
  security_group_ids  = [aws_security_group.private.id]

  tags = {
    Name = "vpce-${var.basename}-priv-ssm"
  }
}

resource "aws_vpc_endpoint" "private_ec2_msgs" {
  count        = true == var.create_private_endpoints ? 1 : 0
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.ec2messages"

  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_az[*].id
  security_group_ids  = [aws_security_group.private.id]

  tags = {
    Name = "vpce-${var.basename}-priv-ec2-msgs"
  }
}

resource "aws_vpc_endpoint" "private_ssm_msgs" {
  count        = true == var.create_private_endpoints ? 1 : 0
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.ssmmessages"

  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_az[*].id
  security_group_ids  = [aws_security_group.private.id]

  tags = {
    Name = "vpce-${var.basename}-priv-ssm-msgs"
  }
}

resource "aws_vpc_endpoint" "secure_ssm" {
  count        = true == var.create_private_endpoints ? 1 : 0
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.ssm"

  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.secure_az[*].id
  security_group_ids  = [aws_security_group.secure.id]

  tags = {
    Name = "vpce-${var.basename}-sec-ssm"
  }
}

resource "aws_vpc_endpoint" "secure_ec2_msgs" {
  count        = true == var.create_private_endpoints ? 1 : 0
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.ec2messages"

  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.secure_az[*].id
  security_group_ids  = [aws_security_group.secure.id]

  tags = {
    Name = "vpce-${var.basename}-sec-ec2-msgs"
  }
}

resource "aws_vpc_endpoint" "secure_ssm_msgs" {
  count        = true == var.create_private_endpoints ? 1 : 0
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.ssmmessages"

  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.secure_az[*].id
  security_group_ids  = [aws_security_group.secure.id]

  tags = {
    Name = "vpce-${var.basename}-sec-ssm-msgs"
  }
}

/*
                                _____ ____ ____
                               | ____/ ___|___ \
                               |  _|| |     __) |
                               | |__| |___ / __/
                               |_____\____|_____|
*/

# resource "aws_vpc_endpoint" "private_ec2" {
#   count        = true == var.create_private_endpoints ? 1 : 0
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${var.aws_region}.ec2"

#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true
#   subnet_ids          = aws_subnet.private_az[*].id
#   security_group_ids  = [aws_security_group.private.id]

#   tags = {
#     Name = "vpce-${var.basename}-priv-ec2"
#   }
# }

# resource "aws_vpc_endpoint" "secure_ec2" {
#   count        = true == var.create_private_endpoints ? 1 : 0
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${var.aws_region}.ec2"

#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true
#   subnet_ids          = aws_subnet.secure_az[*].id
#   security_group_ids  = [aws_security_group.secure.id]

#   tags = {
#     Name = "vpce-${var.basename}-sec-ec2"
#   }
# }
