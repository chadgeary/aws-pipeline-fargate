resource "aws_s3_bucket" "aws-s3-code-bucket" {
  bucket                  = "${var.aws_prefix}-code-bucket-${random_string.aws-suffix.result}"
  acl                     = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.aws-kmscmk-s3.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  force_destroy           = true
  policy                  = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "KMS Manager",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${data.aws_iam_user.aws-kmsmanager.arn}"]
      },
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${var.aws_prefix}-code-bucket-${random_string.aws-suffix.result}",
        "arn:aws:s3:::${var.aws_prefix}-code-bucket-${random_string.aws-suffix.result}/*"
      ]
    },
    {
      "Sid": "Codepipe",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${aws_iam_role.aws-codepipe-role.arn}"]
      },
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject",
        "s3:PutObjectACL"
      ],
      "Resource": ["arn:aws:s3:::${var.aws_prefix}-code-bucket-${random_string.aws-suffix.result}","arn:aws:s3:::${var.aws_prefix}-code-bucket-${random_string.aws-suffix.result}/*"]
    },
    {
      "Sid": "Codebuild",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${aws_iam_role.aws-codebuild-role.arn}"]
      },
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject",
        "s3:PutObjectACL"
      ],
      "Resource": ["arn:aws:s3:::${var.aws_prefix}-code-bucket-${random_string.aws-suffix.result}","arn:aws:s3:::${var.aws_prefix}-code-bucket-${random_string.aws-suffix.result}/*"]
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "aws-s3-code-bucket-pub-access" {
  bucket                  = aws_s3_bucket.aws-s3-code-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "aws-s3-code-bucket-archive-object" {
  bucket                  = aws_s3_bucket.aws-s3-code-bucket.id
  key                     = "code-archive.zip"
  content_base64          = filebase64(data.archive_file.aws-code-archive.output_path)
  kms_key_id              = aws_kms_key.aws-kmscmk-s3.arn
}
