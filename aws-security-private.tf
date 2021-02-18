resource "aws_security_group" "aws-sg-private" {
  name                    = "${var.aws_prefix}-sg-private-${random_string.aws-suffix.result}"
  description             = "Security group for private"
  vpc_id                  = aws_vpc.aws-vpc.id
  tags = {
    Name = "${var.aws_prefix}-sg-private-${random_string.aws-suffix.result}"
  }
}

resource "aws_security_group_rule" "aws-sg-private-tcp-out" {
  security_group_id       = aws_security_group.aws-sg-private.id
  type                    = "egress"
  description             = "OUT TO WORLD - TCP"
  from_port               = 0
  to_port                 = 65535
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "aws-sg-private-udp-out" {
  security_group_id       = aws_security_group.aws-sg-private.id
  type                    = "egress"
  description             = "OUT TO WORLD - UDP"
  from_port               = 0
  to_port                 = 65535
  protocol                = "udp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "aws-sg-private-service-public" {
  security_group_id       = aws_security_group.aws-sg-private.id
  type                    = "ingress"
  description             = "IN FROM PUBLIC"
  from_port               = var.service_port
  to_port                 = var.service_port
  protocol                = var.service_protocol
  cidr_blocks             = [var.subnetA_cidr, var.subnetB_cidr]
}
