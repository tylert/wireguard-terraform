/*
                _             _       _
  ___ _ __   __| |_ __   ___ (_)_ __ | |_ ___
 / _ \ '_ \ / _` | '_ \ / _ \| | '_ \| __/ __|
|  __/ | | | (_| | |_) | (_) | | | | | |_\__ \
 \___|_| |_|\__,_| .__/ \___/|_|_| |_|\__|___/
                 |_|
*/

# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/vpc_endpoint
# https://www.terraform.io/docs/language/functions/concat.html

# https://crishantha.medium.com/handling-vpc-endpoints-ac192b0361a5
# https://www.sentiatechblog.com/a-cost-benefit-analysis-of-vpc-interface-endpoints
# https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/vpc-endpoints-dynamodb.html
# https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/vpc-endpoints-dynamodb-tutorial.html
# https://docs.aws.amazon.com/vpc/latest/userguide/route-table-options.html
# https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-interface.html#vpce-interface-limitations
# https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-vpc.html
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/cloudwatch-logs-and-interface-VPC.html

/*
     _                                       _ _        ___         _____
  __| |_   _ _ __   __ _ _ __ ___   ___   __| | |__    ( _ )    ___|___ /
 / _` | | | | '_ \ / _` | '_ ` _ \ / _ \ / _` | '_ \   / _ \/\ / __| |_ \
| (_| | |_| | | | | (_| | | | | | | (_) | (_| | |_) | | (_>  < \__ \___) |
 \__,_|\__, |_| |_|\__,_|_| |_| |_|\___/ \__,_|_.__/   \___/\/ |___/____/
       |___/
*/

# There is no additional charge for using Gateway VPC Endpoints so just shut up
# and use them.

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"

  vpc_endpoint_type = "Gateway"
  route_table_ids   = concat(aws_route_table.public_az[*].id, aws_route_table.private_az[*].id, aws_route_table.secure_az[*].id)

  tags = {
    Name = "vpce-${var.basename}-dynamodb"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

  vpc_endpoint_type = "Gateway"
  route_table_ids   = concat(aws_route_table.public_az[*].id, aws_route_table.private_az[*].id, aws_route_table.secure_az[*].id)

  tags = {
    Name = "vpce-${var.basename}-s3"
  }
}
