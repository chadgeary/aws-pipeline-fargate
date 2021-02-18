data "archive_file" "aws-code-archive" {
  type                    = "zip"
  source_dir              = "${path.module}/code-archive/"
  output_path             = "${path.module}/code-archive.zip"
}
