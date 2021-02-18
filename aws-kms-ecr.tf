resource "aws_kms_key" "aws-kmscmk-ecr" {
  description             = "KMS CMK for ECR"
  key_usage               = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation     = "true"
  tags                    = {
    Name                  = "${var.aws_prefix}-kmscmk-ecr-${random_string.aws-suffix.result}"
  }
  policy                  = <<EOF
{
  "Id": "aws-kmscmk-ecr",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable ECR Repo Use",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "${data.aws_caller_identity.aws-account.account_id}",
          "kms:ViaService": "ecr.${var.aws_region}.amazonaws.com"
        }
      }
    },
    {
      "Sid": "Enable KMS Manager Use",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_iam_user.aws-kmsmanager.arn}"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_kms_alias" "aws-kmscmk-ecr-alias" {
  name                    = "alias/${var.aws_prefix}-kmscmk-ecr-${random_string.aws-suffix.result}"
  target_key_id           = aws_kms_key.aws-kmscmk-ecr.key_id
}
