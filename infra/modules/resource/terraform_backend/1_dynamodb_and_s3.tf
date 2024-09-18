/*
     _                                       _ _        ___         _____
  __| |_   _ _ __   __ _ _ __ ___   ___   __| | |__    ( _ )    ___|___ /
 / _` | | | | '_ \ / _` | '_ ` _ \ / _ \ / _` | '_ \   / _ \/\ / __| |_ \
| (_| | |_| | | | | (_| | | | | | | (_) | (_| | |_) | | (_>  < \__ \___) |
 \__,_|\__, |_| |_|\__,_|_| |_| |_|\___/ \__,_|_.__/   \___/\/ |___/____/
       |___/
*/

# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/dynamodb_table
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/s3_bucket
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/s3_bucket_acl
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/s3_bucket_ownership_controls
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/s3_bucket_policy
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration
# https://search.opentofu.org/provider/opentofu/aws/latest/docs/resources/s3_bucket_versioning

# XXX FIXME TODO  Do UUIDv5(DNS,ACCTID) stuff with BASE58(UUIDv5(DNS,ACCTID)) instead???
# https://search.opentofu.org/provider/opentofu/external/latest

resource "aws_dynamodb_table" "tf_lock" {
  name     = "tf-${var.basename}-${uuidv5("dns", data.aws_caller_identity.current.account_id)}" # change forces new resource
  hash_key = "LockID"                                                                           # change forces new resource

  billing_mode   = "PROVISIONED" # or "PAY_PER_REQUEST" and skip read_capacity and write_capacity
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "tf-${var.basename}-${uuidv5("dns", data.aws_caller_identity.current.account_id)}"
  }
}

resource "aws_s3_bucket" "tf_state" {
  bucket        = "tf-${var.basename}-${uuidv5("dns", data.aws_caller_identity.current.account_id)}" # change forces new resource
  force_destroy = false

  tags {
    Name = "tf-${var.basename}-${uuidv5("dns", data.aws_caller_identity.current.account_id)}"
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id # change forces new resource

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id # change forces new resource
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.tf_state]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id # change forces new resource

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Make sure that we only ever store encrypted stuff in this bucket...
# http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingServerSideEncryption.html

resource "aws_s3_bucket_policy" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id # change forces new resource

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
      "Resource": "${aws_s3_bucket.tf_state.arn}/*",
      "Sid": "DenyIncorrectEncryptionHeader"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}
