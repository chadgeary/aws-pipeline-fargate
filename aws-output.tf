output "aws-output" {
  value = <<OUTPUT
Load Balancer: ${aws_lb.aws-lb.dns_name}
OUTPUT
}
