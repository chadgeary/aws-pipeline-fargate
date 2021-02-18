resource "aws_route_table" "aws-routeAC" {
  vpc_id                  = aws_vpc.aws-vpc.id
  route {
    cidr_block              = "0.0.0.0/0"
    nat_gateway_id          = aws_nat_gateway.aws-natgwAC.id
  }
  tags                    = {
    Name                  = "${var.aws_prefix}-routeC-${random_string.aws-suffix.result}"
  }
}

resource "aws_route_table" "aws-routeBD" {
  vpc_id                  = aws_vpc.aws-vpc.id
  route {
    cidr_block              = "0.0.0.0/0"
    nat_gateway_id          = aws_nat_gateway.aws-natgwBD.id
  }
  tags                    = {
    Name                  = "${var.aws_prefix}-routeD-${random_string.aws-suffix.result}"
  }
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

resource "aws_route_table_association" "aws-route-netC" {
  subnet_id               = aws_subnet.aws-netC.id
  route_table_id          = aws_route_table.aws-routeAC.id
}

resource "aws_route_table_association" "aws-route-netD" {
  subnet_id               = aws_subnet.aws-netD.id
  route_table_id          = aws_route_table.aws-routeBD.id
}
