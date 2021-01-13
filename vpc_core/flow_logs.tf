/*
  __ _                    _
 / _| | _____      __    | | ___   __ _ ___
| |_| |/ _ \ \ /\ / /____| |/ _ \ / _` / __|
|  _| | (_) \ V  V /_____| | (_) | (_| \__ \
|_| |_|\___/ \_/\_/      |_|\___/ \__, |___/
                                  |___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log

resource "aws_iam_role" "main" {
  name = "${var.basename}-role"

  tags = {
    Name = "${var.basename}-role"
  }

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role_policy" "main" {
  name = "${var.basename}-policy"
  role = aws_iam_role.main.id

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "${var.basename}-loggroup"
  retention_in_days = 7  # default???

  tags = {
    Name = "${var.basename}-loggroup"
  }
}

resource "aws_flow_log" "main" {
  vpc_id                   = aws_vpc.main.id
  traffic_type             = "ALL"
  log_destination          = aws_cloudwatch_log_group.main.arn
  iam_role_arn             = aws_iam_role.main.arn
  max_aggregation_interval = 600

  tags = {
    Name = "${var.basename}-flowlog"
  }
}
