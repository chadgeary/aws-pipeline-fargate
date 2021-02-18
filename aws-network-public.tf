resource "aws_route_table" "aws-routeAB" {
  vpc_id                  = aws_vpc.aws-vpc.id
  route {
    cidr_block              = "0.0.0.0/0"
    gateway_id              = aws_internet_gateway.aws-gw.id
  }
  tags                    = {
    Name                  = "${var.aws_prefix}-route1-${random_string.aws-suffix.result}"
  }
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

resource "aws_subnet" "aws-netB" {
  vpc_id                  = aws_vpc.aws-vpc.id
  availability_zone       = data.aws_availability_zones.aws-azs.names[var.aws_az + 1]
  cidr_block              = var.subnetB_cidr
  tags                    = {
    Name                  = "${var.aws_prefix}-netB-${random_string.aws-suffix.result}"
  }
  depends_on              = [aws_internet_gateway.aws-gw]
}

resource "aws_route_table_association" "aws-route-netA" {
  subnet_id               = aws_subnet.aws-netA.id
  route_table_id          = aws_route_table.aws-routeAB.id
}

resource "aws_route_table_association" "aws-route-netB" {
  subnet_id               = aws_subnet.aws-netB.id
  route_table_id          = aws_route_table.aws-routeAB.id
}
