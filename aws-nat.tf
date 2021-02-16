resource "aws_eip" "aws-natipA" {
  vpc                     = true
}

resource "aws_subnet" "aws-netA" {
  vpc_id                  = aws_vpc.aws-vpc.id
  availability_zone       = data.aws_availability_zones.aws-azs.names[var.aws_az]
  cidr_block              = var.subnetA_cidr
  tags                    = {
    Name                  = "${var.aws_prefix}-netA-${random_string.aws-suffix.result}"
  }
  depends_on              = [aws_internet_gateway.aws-gw]
}

resource "aws_nat_gateway" "aws-natgwAC" {
  allocation_id           = aws_eip.aws-natipA.id
  subnet_id               = aws_subnet.aws-netA.id
  depends_on              = [aws_internet_gateway.aws-gw]
}

resource "aws_eip" "aws-natipB" {
  vpc                     = true
}

resource "aws_subnet" "aws-netB" {
  vpc_id                  = aws_vpc.aws-vpc.id
  availability_zone       = data.aws_availability_zones.aws-azs.names[var.aws_az + 1]
  cidr_block              = var.subnetB_cidr
  tags                    = {
    Name                  = "${var.aws_prefix}-netB-${random_string.aws-suffix.result}"
  }
  depends_on              = [aws_internet_gateway.aws-gw]
}

resource "aws_nat_gateway" "aws-natgwBD" {
  allocation_id           = aws_eip.aws-natipB.id
  subnet_id               = aws_subnet.aws-netB.id
  depends_on              = [aws_internet_gateway.aws-gw]
}

resource "aws_subnet" "aws-netC" {
  vpc_id                  = aws_vpc.aws-vpc.id
  availability_zone       = data.aws_availability_zones.aws-azs.names[var.aws_az]
  cidr_block              = var.subnetC_cidr
  tags                    = {
    Name                  = "${var.aws_prefix}-netC-${random_string.aws-suffix.result}"
  }
  depends_on              = [aws_nat_gateway.aws-natgwAC]
}

resource "aws_subnet" "aws-netD" {
  vpc_id                  = aws_vpc.aws-vpc.id
  availability_zone       = data.aws_availability_zones.aws-azs.names[var.aws_az + 1]
  cidr_block              = var.subnetD_cidr
  tags                    = {
    Name                  = "${var.aws_prefix}-netD-${random_string.aws-suffix.result}"
  }
  depends_on              = [aws_nat_gateway.aws-natgwBD]
}

resource "aws_vpc_endpoint" "aws-vpc-s3-endpointABCD" {
  vpc_id                  = aws_vpc.aws-vpc.id
  service_name            = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids         = [aws_route_table.aws-routeAB.id, aws_route_table.aws-routeAC.id, aws_route_table.aws-routeBD.id]
}

resource "aws_vpc_endpoint" "aws-vpc-logs-endpointAB" {
  vpc_id                  = aws_vpc.aws-vpc.id
  service_name            = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type       = "Interface"
  security_group_ids      = [aws_security_group.aws-sg.id]
  private_dns_enabled     = true
  subnet_ids              = [aws_subnet.aws-netA.id, aws_subnet.aws-netB.id]
}
