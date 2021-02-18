resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name                     = "${var.aws_prefix}-ecscluster-${random_string.aws-suffix.result}"
  capacity_providers       = ["FARGATE"]
  setting {
    name                     = "containerInsights"
    value                    = "enabled"
  }
}

resource "aws_ecs_task_definition" "aws-ecs-task" {
  family                   = "${var.aws_prefix}-ecsservice-${random_string.aws-suffix.result}"
  container_definitions    = templatefile("${path.module}/code-service/service.tpl", {
    aws_prefix              = var.aws_prefix,
    aws_suffix              = random_string.aws-suffix.result,
    aws_repo_url            = aws_ecr_repository.aws-repo.repository_url,
    service_port            = var.service_port
  })
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.aws-ecs-role.arn
  execution_role_arn       = aws_iam_role.aws-ecs-role.arn
  depends_on               = [aws_iam_role_policy_attachment.aws-ecs-iam-attach-1, aws_iam_role_policy_attachment.aws-ecs-iam-attach-2]
}
 
resource "aws_ecs_service" "aws-ecs-service" {
  name                     = "${var.aws_prefix}-ecsservice-${random_string.aws-suffix.result}"
  cluster                  = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition          = aws_ecs_task_definition.aws-ecs-task.arn
  desired_count            = var.service_count
  launch_type                = "FARGATE"
  load_balancer {
    target_group_arn         = aws_lb_target_group.aws-lbtg.arn
    container_name           = "${var.aws_prefix}-container-${random_string.aws-suffix.result}"
    container_port           = var.service_port
  }
  network_configuration {
    subnets                  = [aws_subnet.aws-netC.id, aws_subnet.aws-netD.id]
    security_groups          = [aws_security_group.aws-sg-private.id]
    assign_public_ip         = false
  }
}
