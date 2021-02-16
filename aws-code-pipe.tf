resource "aws_codepipeline" "aws-codepipe" {
  name                    = "${var.aws_prefix}-codepipe-${random_string.aws-suffix.result}"
  role_arn                = aws_iam_role.aws-codepipe-role.arn
  artifact_store {
    location                = aws_s3_bucket.aws-s3-code-bucket.bucket
    type                    = "S3"
    encryption_key {
      id                      = aws_kms_key.aws-kmscmk-s3.arn
      type                    = "KMS"
    }
  }
  stage {
    name = "Source"
    action {
      name                    = "Source"
      category                = "Source"
      owner                   = "AWS"
      provider                = "S3"
      output_artifacts        = ["source_output"]
      version                 = "1"
      configuration           = {
        S3Bucket                = aws_s3_bucket.aws-s3-code-bucket.bucket
        S3ObjectKey             = "code-archive.zip"
        PollForSourceChanges    = "Yes"
      }
    }
  }
  stage {
    name = "Build"
    action {
      name                    = "Build"
      category                = "Build"
      owner                   = "AWS"
      provider                = "CodeBuild"
      input_artifacts         = ["source_output"]
      output_artifacts        = ["build_output"]
      version                 = "1"
      configuration           = {
        ProjectName             = "${var.aws_prefix}-codebuild-${random_string.aws-suffix.result}"
      }
    }
  }
}
