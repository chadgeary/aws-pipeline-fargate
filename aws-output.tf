output "aws-output" {
  value                   = <<OUTPUT
Code Pipeline: https://console.aws.amazon.com/codesuite/codepipeline/pipelines/${var.aws_prefix}-codepipe-${random_string.aws-suffix.result}/view?region=${var.aws_region}
Cluster Service: https://console.aws.amazon.com/ecs/home?region=${var.aws_region}#/clusters/${var.aws_prefix}-ecscluster-${random_string.aws-suffix.result}/services/${var.aws_prefix}-ecsservice-${random_string.aws-suffix.result}/tasks
Load Balancer Target Group: https://console.aws.amazon.com/ec2/v2/home?region=${var.aws_region}#TargetGroup:targetGroupArn=${aws_lb_target_group.aws-lbtg.arn}
OUTPUT
}
