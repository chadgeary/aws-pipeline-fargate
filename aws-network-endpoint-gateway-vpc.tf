resource "aws_vpc" "aws-vpc" {
  cidr_block              = var.vpc_cidr
  enable_dns_support      = "true"
  enable_dns_hostnames    = "true"
  tags                    = {
    Name                  = "${var.aws_prefix}-vpc-${random_string.aws-suffix.result}"
  }
}

resource "aws_internet_gateway" "aws-gw" {
  vpc_id                  = aws_vpc.aws-vpc.id
  tags                    = {
    Name                  = "${var.aws_prefix}-gw-${random_string.aws-suffix.result}"
  }
}

resource "aws_eip" "aws-natipA" {
  vpc                     = true
}

resource "aws_eip" "aws-natipB" {
  vpc                     = true
}

resource "aws_nat_gateway" "aws-natgwAC" {
  allocation_id           = aws_eip.aws-natipA.id
  subnet_id               = aws_subnet.aws-netA.id
  depends_on              = [aws_internet_gateway.aws-gw]
}

resource "aws_nat_gateway" "aws-natgwBD" {
  allocation_id           = aws_eip.aws-natipB.id
  subnet_id               = aws_subnet.aws-netB.id
  depends_on              = [aws_internet_gateway.aws-gw]
}

resource "aws_vpc_endpoint" "aws-vpc-s3-endpointABCD" {
  vpc_id                  = aws_vpc.aws-vpc.id
  service_name            = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids         = [aws_route_table.aws-routeAB.id, aws_route_table.aws-routeAC.id, aws_route_table.aws-routeBD.id]
}

resource "aws_vpc_endpoint" "aws-vpc-logs-endpointCD" {
  vpc_id                  = aws_vpc.aws-vpc.id
  service_name            = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type       = "Interface"
  security_group_ids      = [aws_security_group.aws-sg-private.id]
  private_dns_enabled     = true
  subnet_ids              = [aws_subnet.aws-netC.id, aws_subnet.aws-netD.id]
}
