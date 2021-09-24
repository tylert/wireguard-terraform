/*
                _             _       _
  ___ _ __   __| |_ __   ___ (_)_ __ | |_ ___
 / _ \ '_ \ / _` | '_ \ / _ \| | '_ \| __/ __|
|  __/ | | | (_| | |_) | (_) | | | | | |_\__ \
 \___|_| |_|\__,_| .__/ \___/|_|_| |_|\__|___/
                 |_|
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint
# https://www.terraform.io/docs/language/functions/concat.html

# https://crishantha.medium.com/handling-vpc-endpoints-ac192b0361a5

/*
   ____ _____    ___     ____                                    ____  ____
  / ___|___ /   ( _ )   |  _ \ _   _ _ __   __ _ _ __ ___   ___ |  _ \| __ )
  \___ \ |_ \   / _ \/\ | | | | | | | '_ \ / _` | '_ ` _ \ / _ \| | | |  _ \
   ___) |__) | | (_>  < | |_| | |_| | | | | (_| | | | | | | (_) | |_| | |_) |
  |____/____/   \___/\/ |____/ \__, |_| |_|\__,_|_| |_| |_|\___/|____/|____/
                               |___/
*/

# There is no additional charge for using Gateway VPC Endpoints so just shut up
# and use them.

# https://www.sentiatechblog.com/a-cost-benefit-analysis-of-vpc-interface-endpoints
# https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/vpc-endpoints-dynamodb.html

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  vpc_endpoint_type = "Gateway"
  route_table_ids   = concat(aws_route_table.public_az[*].id, aws_route_table.private_az[*].id, aws_route_table.secure_az[*].id)

  tags = {
    Name = "vpce-${var.basename}-s3"
  }
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.dynamodb"

  vpc_endpoint_type = "Gateway"
  route_table_ids   = concat(aws_route_table.public_az[*].id, aws_route_table.private_az[*].id, aws_route_table.secure_az[*].id)

  tags = {
    Name = "vpce-${var.basename}-dynamodb"
  }
}

/*
                               ____ ____  __  __
                              / ___/ ___||  \/  |
                              \___ \___ \| |\/| |
                               ___) |__) | |  | |
                              |____/____/|_|  |_|
*/

# https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-vpc.html
# https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-interface.html#vpce-interface-limitations

resource "aws_vpc_endpoint" "secure_ec2_msgs" {
  count        = true == var.create_private_endpoints ? 1 : 0
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.ec2messages"

  vpc_endpoint_type   = "Interface"
  private_dns_enabled = false
  subnet_ids          = aws_subnet.secure_az[*].id
  security_group_ids  = [aws_security_group.secure.id]

  tags = {
    Name = "vpce-${var.basename}-sec-ec2-msgs"
  }
}

resource "aws_vpc_endpoint" "secure_ssm" {
  count        = true == var.create_private_endpoints ? 1 : 0
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.ssm"

  vpc_endpoint_type   = "Interface"
  private_dns_enabled = false
  subnet_ids          = aws_subnet.secure_az[*].id
  security_group_ids  = [aws_security_group.secure.id]

  tags = {
    Name = "vpce-${var.basename}-sec-ssm"
  }
}

resource "aws_vpc_endpoint" "secure_ssm_msgs" {
  count        = true == var.create_private_endpoints ? 1 : 0
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.ssmmessages"

  vpc_endpoint_type   = "Interface"
  private_dns_enabled = false
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

# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/interface-vpc-endpoints.html
# https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-vpc.html

# resource "aws_vpc_endpoint" "secure_ec2" {
#   count        = true == var.create_private_endpoints ? 1 : 0
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${var.aws_region}.ec2"

#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = false
#   subnet_ids          = aws_subnet.secure_az[*].id
#   security_group_ids  = [aws_security_group.secure.id]

#   tags = {
#     Name = "vpce-${var.basename}-sec-ec2"
#   }
# }

/*
                               _  ____  __ ____
                              | |/ /  \/  / ___|
                              | ' /| |\/| \___ \
                              | . \| |  | |___) |
                              |_|\_\_|  |_|____/
*/

# https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-vpc.html

# resource "aws_vpc_endpoint" "secure_kms" {
#   count        = true == var.create_private_endpoints ? 1 : 0
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${var.aws_region}.kms"

#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = false
#   subnet_ids          = aws_subnet.secure_az[*].id
#   security_group_ids  = [aws_security_group.secure.id]

#   tags = {
#     Name = "vpce-${var.basename}-sec-kms"
#   }
# }

# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/cloudwatch-logs-and-interface-VPC.html
