# Note that EC2 Instance Connect is only supported on Amazon Linux 2 and Ubuntu.
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-set-up.html
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/interface-vpc-endpoints.html

# SSM requires you to use the following IAM instance profile magic...

# The AWS managed role...
#   "EC2 role for SSM for Quick-Setup"
#   arn:aws:iam::123456789012:role/AmazonSSMRoleForInstancesQuickSetup
#   arn:aws:iam::123456789012:instance-profile/AmazonSSMRoleForInstancesQuickSetup

# Which contains the following managed roles...
# AmazonSSMManagedInstanceCore

# {
#     "Statement": [
#         {
#             "Action": [
#                 "ssm:DescribeAssociation",
#                 "ssm:GetDeployablePatchSnapshotForInstance",
#                 "ssm:GetDocument",
#                 "ssm:DescribeDocument",
#                 "ssm:GetManifest",
#                 "ssm:GetParameter",
#                 "ssm:GetParameters",
#                 "ssm:ListAssociations",
#                 "ssm:ListInstanceAssociations",
#                 "ssm:PutInventory",
#                 "ssm:PutComplianceItems",
#                 "ssm:PutConfigurePackageResult",
#                 "ssm:UpdateAssociationStatus",
#                 "ssm:UpdateInstanceAssociationStatus",
#                 "ssm:UpdateInstanceInformation"
#             ],
#             "Effect": "Allow",
#             "Resource": "*"
#         },
#         {
#             "Action": [
#                 "ssmmessages:CreateControlChannel",
#                 "ssmmessages:CreateDataChannel",
#                 "ssmmessages:OpenControlChannel",
#                 "ssmmessages:OpenDataChannel"
#             ],
#             "Effect": "Allow",
#             "Resource": "*"
#         },
#         {
#             "Action": [
#                 "ec2messages:AcknowledgeMessage",
#                 "ec2messages:DeleteMessage",
#                 "ec2messages:FailMessage",
#                 "ec2messages:GetEndpoint",
#                 "ec2messages:GetMessages",
#                 "ec2messages:SendReply"
#             ],
#             "Effect": "Allow",
#             "Resource": "*"
#         }
#     ],
#     "Version": "2012-10-17"
# }

# +
# AmazonSSMPatchAssociation

# {
#     "Statement": [
#         {
#             "Action": "ssm:DescribeEffectivePatchesForPatchBaseline",
#             "Effect": "Allow",
#             "Resource": "arn:aws:ssm:*:*:patchbaseline/*"
#         },
#         {
#             "Action": "ssm:GetPatchBaseline",
#             "Effect": "Allow",
#             "Resource": "arn:aws:ssm:*:*:patchbaseline/*"
#         },
#         {
#             "Action": "tag:GetResources",
#             "Effect": "Allow",
#             "Resource": "*"
#         },
#         {
#             "Action": "ssm:DescribePatchBaselines",
#             "Effect": "Allow",
#             "Resource": "*"
#         }
#     ],
#     "Version": "2012-10-17"
# }

/*
                               ____ ____  __  __
                              / ___/ ___||  \/  |
                              \___ \___ \| |\/| |
                               ___) |__) | |  | |
                              |____/____/|_|  |_|
*/

# resource "aws_vpc_endpoint" "secure_ec2_msgs" {
#   count        = true == var.create_private_endpoints ? 1 : 0
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${data.aws_region.current.name}.ec2messages"

#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = false
#   subnet_ids          = aws_subnet.secure_az[*].id
#   security_group_ids  = [aws_security_group.secure.id]

#   tags = {
#     Name = "vpce-${var.basename}-sec-ec2-msgs"
#   }
# }

# resource "aws_vpc_endpoint" "secure_ssm" {
#   count        = true == var.create_private_endpoints ? 1 : 0
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${data.aws_region.current.name}.ssm"

#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = false
#   subnet_ids          = aws_subnet.secure_az[*].id
#   security_group_ids  = [aws_security_group.secure.id]

#   tags = {
#     Name = "vpce-${var.basename}-sec-ssm"
#   }
# }

# resource "aws_vpc_endpoint" "secure_ssm_msgs" {
#   count        = true == var.create_private_endpoints ? 1 : 0
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"

#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = false
#   subnet_ids          = aws_subnet.secure_az[*].id
#   security_group_ids  = [aws_security_group.secure.id]

#   tags = {
#     Name = "vpce-${var.basename}-sec-ssm-msgs"
#   }
# }

/*
                                _____ ____ ____
                               | ____/ ___|___ \
                               |  _|| |     __) |
                               | |__| |___ / __/
                               |_____\____|_____|
*/

# resource "aws_vpc_endpoint" "secure_ec2" {
#   count        = true == var.create_private_endpoints ? 1 : 0
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${data.aws_region.current.name}.ec2"

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

# resource "aws_vpc_endpoint" "secure_kms" {
#   count        = true == var.create_private_endpoints ? 1 : 0
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${data.aws_region.current.name}.kms"

#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = false
#   subnet_ids          = aws_subnet.secure_az[*].id
#   security_group_ids  = [aws_security_group.secure.id]

#   tags = {
#     Name = "vpce-${var.basename}-sec-kms"
#   }
# }
