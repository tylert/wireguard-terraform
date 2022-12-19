/*
  __ _                 _
 / _| | _____      __ | | ___   __ _ ___
| |_| |/ _ \ \ /\ / / | |/ _ \ / _` / __|
|  _| | (_) \ V  V /  | | (_) | (_| \__ \
|_| |_|\___/ \_/\_/   |_|\___/ \__, |___/
                               |___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log

resource "aws_s3_bucket" "flow_logs" {
  count         = true == var.flow_logs_enabled ? 1 : 0
  bucket        = "meh" # change forces new resource
  force_destroy = false

  tags = {
    Name = "s3-${var.basename}-fl"
  }
}

resource "aws_s3_bucket_acl" "flow_logs" {
  count  = true == var.flow_logs_enabled ? 1 : 0
  bucket = aws_s3_bucket.flow_logs[0].id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "flow_logs" {
  count  = true == var.flow_logs_enabled ? 1 : 0
  bucket = aws_s3_bucket.flow_logs[0].id
  versioning_configuration {
    status = "Disabled"
  }
}

# Make sure that we only ever store encrypted stuff in this bucket...
# http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingServerSideEncryption.html

resource "aws_s3_bucket_policy" "flow_logs" {
  count  = true == var.flow_logs_enabled ? 1 : 0
  bucket = aws_s3_bucket.flow_logs[0].id

  policy = <<EOF
{
  "Id": "PutObjectPolicy",
  "Statement": [
    {
      "Action": "s3:PutObject",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      },
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.flow_logs[0].arn}/*",
      "Sid": "DenyIncorrectEncryptionHeader"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_flow_log" "main" {
  count        = true == var.flow_logs_enabled ? 1 : 0
  vpc_id       = aws_vpc.main.id
  traffic_type = "ALL"

  log_destination_type     = "s3"
  log_destination          = aws_s3_bucket.flow_logs[0].arn
  max_aggregation_interval = var.flow_logs_max_aggregation_interval

  tags = {
    Name = "fl-${var.basename}"
  }
}
