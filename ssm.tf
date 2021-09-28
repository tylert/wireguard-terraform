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
