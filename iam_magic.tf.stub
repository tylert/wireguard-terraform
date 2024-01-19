# https://stackoverflow.com/questions/46324062/in-aws-iam-what-is-the-purpose-use-of-the-path-variable
# https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy

resource "aws_iam_group" "administrators" {
  name = "administrators"
  path = "/"
}

resource "aws_iam_user" "otto" {
  name = "otto"
  path = "/"

  # tags = {
  #   Name = "iam-${var.basename}-otto"
  # }
}

resource "aws_iam_user_group_membership" "administrators" {
  user   = aws_iam_user.otto
  groups = aws_iam_group.administrators

  depends_on = [aws_iam_user.otto]
}

resource "aws_iam_access_key" "new" {
  user   = "otto"
  status = "Active" # or Inactive
}

resource "aws_iam_policy_attachment" "administrators" {
  name       = "administrators-attach"
  groups     = aws_iam_group.administrators.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "admin_role" {
  assume_role_policy = foo
  description        = ""
}

resource "" "" {
  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:iam::SUBACCTNO:role/builders"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "" "" {
  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::MAINACCTNO:root"
      }
    }
  ],
  "Version": "2012-10-17"
}
EOF
}
