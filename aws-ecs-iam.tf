resource "aws_iam_role" "aws-ecs-role" {
  name                        = "${var.aws_prefix}-ecsrole-${random_string.aws-suffix.result}"
  assume_role_policy          = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
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

resource "aws_iam_role_policy_attachment" "aws-ecs-iam-attach-1" {
  role                    = aws_iam_role.aws-ecs-role.name
  policy_arn              = data.aws_iam_policy.aws-ecs-exec-policy.arn
}

resource "aws_iam_policy" "aws-ecs-policy" {
  name              = "${var.aws_prefix}-ecs-policy-${random_string.aws-suffix.result}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws-ecs-iam-attach-2" {
  role                    = aws_iam_role.aws-ecs-role.name
  policy_arn              = aws_iam_policy.aws-ecs-policy.arn
}
