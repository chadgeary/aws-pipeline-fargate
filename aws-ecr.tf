resource "aws_ecr_repository" "aws-repo" {
  name                     = "${var.aws_prefix}-repo-${random_string.aws-suffix.result}"
  image_tag_mutability     = "MUTABLE"
  encryption_configuration {
    encryption_type          = "KMS"
    kms_key                  = aws_kms_key.aws-kmscmk-ecr.arn
  }
}
