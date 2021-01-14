# https://stackoverflow.com/questions/46324062/in-aws-iam-what-is-the-purpose-use-of-the-path-variable
# https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy

/*
resource "aws_iam_group" "admin_group" {
  name = "builders"
  path = "/"
}

resource "aws_iam_user" "new_user" {
  name = "otto"
  path = "/"

  tags = {
    Name = "iam-${var.basename}"
  }
}

resource "aws_iam_access_key" "new" {
  user   = "otto"
  status = "Active"  # or Inactive
}

resource "aws_iam_role" "admin_role" {
}

resource "" "" {
  name = ""
  role = ""

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}
*/
