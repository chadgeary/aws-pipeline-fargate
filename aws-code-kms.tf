resource "aws_kms_key" "aws-kmscmk-code" {
  description             = "KMS CMK for code"
  key_usage               = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation     = "true"
  tags                    = {
    Name                  = "${var.aws_prefix}-kmscmk-code-${random_string.aws-suffix.result}"
  }
  policy                  = <<EOF
{
  "Id": "aws-kmscmk-code",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable CodeBuild Use",
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
          "kms:ViaService": "codebuild.${var.aws_region}.amazonaws.com"
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

resource "aws_kms_alias" "aws-kmscmk-code-alias" {
  name                    = "alias/${var.aws_prefix}-kmscmk-code-${random_string.aws-suffix.result}"
  target_key_id           = aws_kms_key.aws-kmscmk-code.key_id
}
