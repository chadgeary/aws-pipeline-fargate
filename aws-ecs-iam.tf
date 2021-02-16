resource "aws_iam_role" "aws-ecs-role" {
  name                        = "${var.aws_prefix}-ecsrole-${random_string.aws-suffix.result}"
  assume_role_policy          = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "ECS"
    }
  ]
}
EOF
}

data "aws_iam_policy" "aws-ecs-exec-policy" {
  arn                     = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "aws-lambda-iam-attach-1" {
  role                    = aws_iam_role.aws-ecs-role.name
  policy_arn              = data.aws_iam_policy.aws-ecs-exec-policy.arn
}
