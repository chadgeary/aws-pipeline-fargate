resource "aws_iam_policy" "aws-codepipe-policy" {
  name             = "${var.aws_prefix}-codepipe-policy-${random_string.aws-suffix.result}"
  policy = <<EOF
{
	"Statement": [{
			"Action": [
				"iam:PassRole"
			],
			"Resource": "*",
			"Effect": "Allow",
			"Condition": {
				"StringEqualsIfExists": {
					"iam:PassedToService": [
						"ecs-tasks.amazonaws.com"
					]
				}
			}
		},
		{
			"Action": [
				"codedeploy:CreateDeployment",
				"codedeploy:GetApplication",
				"codedeploy:GetApplicationRevision",
				"codedeploy:GetDeployment",
				"codedeploy:GetDeploymentConfig",
				"codedeploy:RegisterApplicationRevision"
			],
			"Resource": "*",
			"Effect": "Allow"
		},
		{
			"Action": [
				"elasticloadbalancing:*",
				"autoscaling:*",
				"cloudwatch:*",
				"ecs:*"
			],
			"Resource": "*",
			"Effect": "Allow"
		},
		{
			"Action": [
				"codebuild:BatchGetBuilds",
				"codebuild:StartBuild",
				"codebuild:BatchGetBuildBatches",
				"codebuild:StartBuildBatch"
			],
			"Resource": "${aws_codebuild_project.aws-codebuild.arn}",
			"Effect": "Allow"
		},
		{
			"Effect": "Allow",
			"Action": [
				"servicecatalog:ListProvisioningArtifacts",
				"servicecatalog:CreateProvisioningArtifact",
				"servicecatalog:DescribeProvisioningArtifact",
				"servicecatalog:DeleteProvisioningArtifact",
				"servicecatalog:UpdateProduct"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"ecr:DescribeImages"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"states:DescribeExecution",
				"states:DescribeStateMachine",
				"states:StartExecution"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"appconfig:StartDeployment",
				"appconfig:StopDeployment",
				"appconfig:GetDeployment"
			],
			"Resource": "*"
		},
		{
			"Sid": "ObjectsinBucketPrefix",
			"Effect": "Allow",
			"Action": [
				"s3:GetObject",
				"s3:GetObjectVersion",
                                "s3:GetBucketVersioning",
                                "s3:PutObject"
			],
			"Resource": ["${aws_s3_bucket.aws-s3-code-bucket.arn}","${aws_s3_bucket.aws-s3-code-bucket.arn}/*"]
		},
		{
			"Sid": "CodeKMSCMK",
			"Effect": "Allow",
			"Action": [
				"kms:Encrypt",
				"kms:ReEncrypt*",
				"kms:GenerateDataKey*",
				"kms:DescribeKey"
			],
			"Resource": ["${aws_kms_key.aws-kmscmk-code.arn}"]
		},
                {
                        "Sid": "S3KMSCMK",
                        "Effect": "Allow",
                        "Action": [
                                "kms:Encrypt",
                                "kms:ReEncrypt*",
                                "kms:Decrypt",
                                "kms:GenerateDataKey*",
                                "kms:DescribeKey"
                        ],
                        "Resource": ["${aws_kms_key.aws-kmscmk-s3.arn}"]
                }

	],
	"Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role" "aws-codepipe-role" {
  name                        = "${var.aws_prefix}-codepipe-${random_string.aws-suffix.result}"
  assume_role_policy          = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "Codepipeline"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws-codepipe-policy-role-attach" {
  role                    = aws_iam_role.aws-codepipe-role.name
  policy_arn              = aws_iam_policy.aws-codepipe-policy.arn
}
