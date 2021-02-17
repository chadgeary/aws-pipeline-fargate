resource "aws_lb" "aws-lb" {
  name                    = "${var.aws_prefix}-lb-${random_string.aws-suffix.result}"
  internal                = false
  load_balancer_type      = "network"
  subnets                 = [aws_subnet.aws-netA.id, aws_subnet.aws-netB.id]
}

resource "aws_lb_target_group" "aws-lbtg" {
  name                    = "${var.aws_prefix}-lbtg-${var.service_port}-${random_string.aws-suffix.result}"
  port                    = var.service_port
  protocol                = var.service_protocol
  vpc_id                  = aws_vpc.aws-vpc.id
  target_type             = "ip"
}

resource "aws_lb_listener" "aws-lb-listen" {
  load_balancer_arn       = aws_lb.aws-lb.arn
  port                    = var.service_port
  protocol                = var.service_protocol
  default_action {
    type                    = "forward"
    target_group_arn        = aws_lb_target_group.aws-lbtg.arn
  }
}
