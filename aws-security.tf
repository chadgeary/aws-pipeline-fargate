resource "aws_security_group" "aws-sg" {
  name                    = "${var.aws_prefix}-sg-${random_string.aws-suffix.result}"
  description             = "Security group for ${var.aws_prefix}-containers-${random_string.aws-suffix.result}"
  vpc_id                  = aws_vpc.aws-vpc.id
  tags = {
    Name = "${var.aws_prefix}-sg-${random_string.aws-suffix.result}"
  }
}

resource "aws_security_group_rule" "aws-sg-tcp-out" {
  security_group_id       = aws_security_group.aws-sg.id
  type                    = "egress"
  description             = "OUT TO WORLD - TCP"
  from_port               = 0
  to_port                 = 65535
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "aws-sg-udp-out" {
  security_group_id       = aws_security_group.aws-sg.id
  type                    = "egress"
  description             = "OUT TO WORLD - UDP"
  from_port               = 0
  to_port                 = 65535
  protocol                = "udp"
  cidr_blocks             = ["0.0.0.0/0"]
}
