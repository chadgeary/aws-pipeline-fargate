resource "aws_security_group" "aws-sg-public" {
  name                    = "${var.aws_prefix}-sg-public-${random_string.aws-suffix.result}"
  description             = "Security group for public"
  vpc_id                  = aws_vpc.aws-vpc.id
  tags = {
    Name = "${var.aws_prefix}-sg-public-${random_string.aws-suffix.result}"
  }
}

resource "aws_security_group_rule" "aws-sg-public-tcp-out" {
  security_group_id       = aws_security_group.aws-sg-public.id
  type                    = "egress"
  description             = "OUT TO WORLD - TCP"
  from_port               = 0
  to_port                 = 65535
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "aws-sg-public-udp-out" {
  security_group_id       = aws_security_group.aws-sg-public.id
  type                    = "egress"
  description             = "OUT TO WORLD - UDP"
  from_port               = 0
  to_port                 = 65535
  protocol                = "udp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "aws-sg-public-service-private" {
  security_group_id       = aws_security_group.aws-sg-public.id
  type                    = "egress"
  description             = "OUT TO PRIVATE"
  from_port               = var.service_port
  to_port                 = var.service_port
  protocol                = var.service_protocol
  source_security_group_id = aws_security_group.aws-sg-private.id
}

resource "aws_security_group_rule" "aws-sg-public-service-client" {
  security_group_id       = aws_security_group.aws-sg-public.id
  type                    = "ingress"
  description             = "IN FROM CLIENT"
  from_port               = var.service_port
  to_port                 = var.service_port
  protocol                = var.service_protocol
  cidr_blocks             = var.client_cidrs
}
