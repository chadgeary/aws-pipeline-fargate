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
  container_definitions    = file("service.json")
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.aws-ecs-role.arn
}
 
resource "aws_ecs_service" "aws-ecs-service" {
  name                     = "${var.aws_prefix}-ecsservice-${random_string.aws-suffix.result}"
  cluster                  = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition          = aws_ecs_task_definition.aws-ecs-task.arn
  desired_count            = 1
  launch_type                = "FARGATE"
  load_balancer {
    target_group_arn         = aws_lb_target_group.aws-lbtg.arn
    container_name           = "my-container-1"
    container_port           = var.service_port
  }
  network_configuration {
    subnets                  = [aws_subnet.aws-netA.id, aws_subnet.aws-netB.id]
    security_groups          = [aws_security_group.aws-sg.id]
    assign_public_ip         = false
  }
  depends_on               = [aws_lb_listener.aws-lb-listen]
}
