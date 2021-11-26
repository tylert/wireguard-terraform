# terraform {
#   backend "s3" {
#     region         = "ca-central-1"
#     bucket         = "froopyland_state_bucket"
#     key            = "global/terraform.tfstate"
#     encrypt        = true
#     acl            = "private"
#     dynamodb_table = "terraform_lock"
#   }
# }

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy

resource "aws_dynamodb_table" "tf_lock" {
  name     = "dydb-${var.basename}-tflock"
  hash_key = "LockID" # change forces new resource

  billing_mode   = "PROVISIONED" # or "PAY_PER_REQUEST" and skip read_capacity and write_capacity
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "dydb-${var.basename}-tflock"
  }
}

resource "aws_s3_bucket" "tf_state" {
  bucket        = "s3-${var.basename}-tfstate" # change forces new resource
  acl           = "private"
  force_destroy = false

  versioning {
    enabled = true
  }

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags {
    Name = "s3-${var.basename}-tfstate"
  }
}

# Make sure that we only ever store encrypted state stuff in this bucket...
#   http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingServerSideEncryption.html

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
      "Resource": "arn:aws:s3:::${var.tf_state_bucket_name}/*",
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
      "Resource": "arn:aws:s3:::${var.tf_state_bucket_name}/*",
      "Sid": "DenyUnEncryptedObjectUploads"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}
