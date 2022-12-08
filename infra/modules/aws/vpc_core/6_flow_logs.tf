/*
  __ _                 _
 / _| | _____      __ | | ___   __ _ ___
| |_| |/ _ \ \ /\ / / | |/ _ \ / _` / __|
|  _| | (_) \ V  V /  | | (_) | (_| \__ \
|_| |_|\___/ \_/\_/   |_|\___/ \__, |___/
                               |___/
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log

resource "aws_s3_bucket" "logs" {
  bucket        = "meh" # change forces new resource
  acl           = "private"
  force_destroy = false

  versioning {
    enabled = false
  }

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = {
    Name = "s3-${var.basename}-fl"
  }
}

# Make sure that we only ever store encrypted stuff in this bucket...
# http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingServerSideEncryption.html

resource "aws_s3_bucket_policy" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  policy = <<EOF
{
  "Id": "PutObjPolicy",
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
      "Resource": "arn:aws:s3:::${var.flow_logs_bucket_name}/*",
      "Sid": "DenyIncorrectEncryptionHeader"
    },
    {
      "Action": "s3:PutObject",
      "Condition": {
        "Null": {
          "s3:x-amz-server-side-encryption": "true"
        }
      },
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "arn:aws:s3:::${var.flow_logs_bucket_name}/*",
      "Sid": "DenyUnEncryptedObjectUploads"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_flow_log" "main" {
  vpc_id       = aws_vpc.main.id
  traffic_type = "ALL"

  log_destination_type     = "s3"
  log_destination          = aws_s3_bucket.logs.arn
  max_aggregation_interval = var.aggregation_interval

  tags = {
    Name = "fl-${var.basename}"
  }
}
