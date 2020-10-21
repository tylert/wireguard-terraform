provider "aws" {
  # required version set by module
  region = "${var.region}"
}

terraform {
  # required version set by module
  backend "s3" {
    region         = "ca-central-1"
    bucket         = "cace1-tf-marc-orthos"
    key            = "global/terraform.tfstate"
    encrypt        = true
    acl            = "private"
    dynamodb_table = "terraform_lock"
  }
}

resource "aws_iam_account_alias" "alias" {
  account_alias = "marcs-aws-playground"
}

resource "aws_dynamodb_table" "tf_lock" {
  name           = "${var.lock_table_name}"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "dynamodb-tf-lock"
  }
}

resource "aws_s3_bucket" "tf_state" {
  bucket        = "${var.state_bucket_name}" # supports bucket_prefix
  acl           = "private"
  force_destroy = false
  region        = "${var.region}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name = "s3-tf-state"
  }
}

# Make sure that we only ever store encrypted state stuff here
# http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingServerSideEncryption.html

resource "aws_s3_bucket_policy" "tf_state" {
  bucket = "${aws_s3_bucket.tf_state.id}"

  policy = <<POLICYEOF
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
      "Resource": "arn:aws:s3:::${var.state_bucket_name}/*",
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
      "Resource": "arn:aws:s3:::${var.state_bucket_name}/*",
      "Sid": "DenyUnEncryptedObjectUploads"
    }
  ],
  "Version": "2012-10-17"
}
POLICYEOF
}

resource "aws_iam_group" "administrators" {
  name = "Administrators"
  path = "/"              # default / XXX FIXME XXX
}

# XXX FIXME XXX Convert these to actual references to managed group policies

# arn:aws:iam::aws:policy/AdministratorAccess

/*
resource "aws_iam_group_policy_attachment" "administrator_access" {
  group = "${aws_iam_group.administrators.id}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
*/

resource "aws_iam_group_policy" "administrator_access" {
  name  = "AdministratorAccess"
  group = "${aws_iam_group.administrators.id}"

  policy = <<POLICYEOF
{
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
POLICYEOF
}

resource "aws_iam_group" "readonly" {
  name = "ReadOnly"
  path = "/"        # default / XXX FIXME XXX
}

# arn:aws:iam::aws:policy/ReadOnlyAccess

/*
resource "aws_iam_group_policy_attachment" "readonly_access" {
  group = "${aws_iam_group.readonly.id}"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
*/

resource "aws_iam_group_policy" "readonly_access" {
  name  = "ReadOnlyAccess"
  group = "${aws_iam_group.readonly.id}"

  policy = <<POLICYEOF
{
  "Statement": [
    {
      "Action": [
        "acm:Describe*",
        "acm:Get*",
        "acm:List*",
        "apigateway:GET",
        "application-autoscaling:Describe*",
        "appstream:Describe*",
        "appstream:Get*",
        "appstream:List*",
        "athena:Batch*",
        "athena:Get*",
        "athena:List*",
        "autoscaling:Describe*",
        "batch:Describe*",
        "batch:List*",
        "clouddirectory:BatchRead",
        "clouddirectory:Get*",
        "clouddirectory:List*",
        "clouddirectory:LookupPolicy",
        "cloudformation:Describe*",
        "cloudformation:Estimate*",
        "cloudformation:Get*",
        "cloudformation:List*",
        "cloudformation:Preview*",
        "cloudfront:Get*",
        "cloudfront:List*",
        "cloudhsm:Describe*",
        "cloudhsm:Get*",
        "cloudhsm:List*",
        "cloudsearch:Describe*",
        "cloudsearch:List*",
        "cloudtrail:Describe*",
        "cloudtrail:Get*",
        "cloudtrail:List*",
        "cloudtrail:LookupEvents",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "codebuild:BatchGet*",
        "codebuild:List*",
        "codecommit:BatchGet*",
        "codecommit:Get*",
        "codecommit:GitPull",
        "codecommit:List*",
        "codedeploy:BatchGet*",
        "codedeploy:Get*",
        "codedeploy:List*",
        "codepipeline:Get*",
        "codepipeline:List*",
        "codestar:Describe*",
        "codestar:Get*",
        "codestar:List*",
        "codestar:Verify*",
        "cognito-identity:Describe*",
        "cognito-identity:List*",
        "cognito-identity:Lookup*",
        "cognito-idp:AdminList*",
        "cognito-idp:Describe*",
        "cognito-idp:Get*",
        "cognito-idp:List*",
        "cognito-sync:Describe*",
        "cognito-sync:Get*",
        "cognito-sync:List*",
        "cognito-sync:QueryRecords",
        "config:Deliver*",
        "config:Describe*",
        "config:Get*",
        "config:List*",
        "connect:Describe*",
        "connect:Get*",
        "connect:List*",
        "datapipeline:Describe*",
        "datapipeline:EvaluateExpression",
        "datapipeline:Get*",
        "datapipeline:List*",
        "datapipeline:QueryObjects",
        "datapipeline:Validate*",
        "devicefarm:Get*",
        "devicefarm:List*",
        "directconnect:Confirm*",
        "directconnect:Describe*",
        "discovery:Describe*",
        "discovery:Get*",
        "discovery:List*",
        "dms:Describe*",
        "dms:List*",
        "dms:Test*",
        "ds:Check*",
        "ds:Describe*",
        "ds:Get*",
        "ds:List*",
        "ds:Verify*",
        "dynamodb:BatchGet*",
        "dynamodb:Describe*",
        "dynamodb:Get*",
        "dynamodb:List*",
        "dynamodb:Query",
        "dynamodb:Scan",
        "ec2:Describe*",
        "ec2:Get*",
        "ec2messages:Get*",
        "ecr:BatchCheck*",
        "ecr:BatchGet*",
        "ecr:Describe*",
        "ecr:Get*",
        "ecr:List*",
        "ecs:Describe*",
        "ecs:List*",
        "elasticache:Describe*",
        "elasticache:List*",
        "elasticbeanstalk:Check*",
        "elasticbeanstalk:Describe*",
        "elasticbeanstalk:List*",
        "elasticbeanstalk:Request*",
        "elasticbeanstalk:Retrieve*",
        "elasticbeanstalk:Validate*",
        "elasticfilesystem:Describe*",
        "elasticloadbalancing:Describe*",
        "elasticmapreduce:Describe*",
        "elasticmapreduce:List*",
        "elasticmapreduce:View*",
        "elastictranscoder:List*",
        "elastictranscoder:Read*",
        "es:Describe*",
        "es:ESHttpGet",
        "es:ESHttpHead",
        "es:List*",
        "events:Describe*",
        "events:List*",
        "events:Test*",
        "firehose:Describe*",
        "firehose:List*",
        "gamelift:Describe*",
        "gamelift:Get*",
        "gamelift:List*",
        "gamelift:RequestUploadCredentials",
        "gamelift:ResolveAlias",
        "gamelift:Search*",
        "glacier:Describe*",
        "glacier:Get*",
        "glacier:List*",
        "health:Describe*",
        "health:Get*",
        "health:List*",
        "iam:Generate*",
        "iam:Get*",
        "iam:List*",
        "iam:Simulate*",
        "importexport:Get*",
        "importexport:List*",
        "inspector:Describe*",
        "inspector:Get*",
        "inspector:List*",
        "inspector:LocalizeText",
        "inspector:Preview*",
        "iot:Describe*",
        "iot:Get*",
        "iot:List*",
        "kinesisanalytics:Describe*",
        "kinesisanalytics:Discover*",
        "kinesisanalytics:Get*",
        "kinesisanalytics:List*",
        "kinesis:Describe*",
        "kinesis:Get*",
        "kinesis:List*",
        "kms:Describe*",
        "kms:Get*",
        "kms:List*",
        "lambda:Get*",
        "lambda:List*",
        "lex:Get*",
        "lightsail:Download*",
        "lightsail:Get*",
        "lightsail:Is*",
        "logs:Describe*",
        "logs:FilterLogEvents",
        "logs:Get*",
        "logs:TestMetricFilter",
        "machinelearning:Describe*",
        "machinelearning:Get*",
        "mobileanalytics:Get*",
        "mobilehub:Get*",
        "mobilehub:List*",
        "mobilehub:Validate*",
        "mobilehub:Verify*",
        "mobiletargeting:Get*",
        "opsworks-cm:Describe*",
        "opsworks:Describe*",
        "opsworks:Get*",
        "organizations:Describe*",
        "organizations:List*",
        "polly:Describe*",
        "polly:Get*",
        "polly:List*",
        "polly:SynthesizeSpeech",
        "rds:Describe*",
        "rds:Download*",
        "rds:List*",
        "redshift:Describe*",
        "redshift:Get*",
        "redshift:View*",
        "rekognition:CompareFaces",
        "rekognition:Detect*",
        "rekognition:List*",
        "rekognition:Search*",
        "route53domains:Check*",
        "route53domains:Get*",
        "route53domains:List*",
        "route53domains:View*",
        "route53:Get*",
        "route53:List*",
        "route53:Test*",
        "s3:Get*",
        "s3:Head*",
        "s3:List*",
        "sdb:Get*",
        "sdb:List*",
        "sdb:Select*",
        "servicecatalog:Describe*",
        "servicecatalog:List*",
        "servicecatalog:Scan*",
        "servicecatalog:Search*",
        "ses:Describe*",
        "ses:Get*",
        "ses:List*",
        "ses:Verify*",
        "shield:Describe*",
        "shield:List*",
        "sns:Check*",
        "sns:Get*",
        "sns:List*",
        "sqs:Get*",
        "sqs:List*",
        "sqs:Receive*",
        "ssm:Describe*",
        "ssm:Get*",
        "ssm:List*",
        "states:Describe*",
        "states:GetExecutionHistory",
        "states:List*",
        "storagegateway:Describe*",
        "storagegateway:List*",
        "sts:Get*",
        "swf:Count*",
        "swf:Describe*",
        "swf:Get*",
        "swf:List*",
        "tag:Get*",
        "trustedadvisor:Describe*",
        "waf:Get*",
        "waf:List*",
        "waf-regional:Get*",
        "waf-regional:List*",
        "workdocs:CheckAlias",
        "workdocs:Describe*",
        "workdocs:Get*",
        "workmail:Describe*",
        "workmail:Get*",
        "workmail:List*",
        "workmail:Search*",
        "workspaces:Describe*",
        "xray:BatchGet*",
        "xray:Get*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
POLICYEOF
}
