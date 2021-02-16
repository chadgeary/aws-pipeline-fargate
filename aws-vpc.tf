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

resource "aws_route_table_association" "aws-route-netA" {
  subnet_id               = aws_subnet.aws-netA.id
  route_table_id          = aws_route_table.aws-routeAB.id
}

resource "aws_route_table_association" "aws-route-netB" {
  subnet_id               = aws_subnet.aws-netB.id
  route_table_id          = aws_route_table.aws-routeAB.id
}

resource "aws_route_table" "aws-routeAC" {
  vpc_id                  = aws_vpc.aws-vpc.id
  route {
    cidr_block              = "0.0.0.0/0"
    gateway_id              = aws_nat_gateway.aws-natgwAC.id
  }
  tags                    = {
    Name                  = "${var.aws_prefix}-routeC-${random_string.aws-suffix.result}"
  }
}

resource "aws_route_table" "aws-routeBD" {
  vpc_id                  = aws_vpc.aws-vpc.id
  route {
    cidr_block              = "0.0.0.0/0"
    gateway_id              = aws_nat_gateway.aws-natgwBD.id
  }
  tags                    = {
    Name                  = "${var.aws_prefix}-routeD-${random_string.aws-suffix.result}"
  }
}

resource "aws_route_table_association" "aws-route-netC" {
  subnet_id               = aws_subnet.aws-netC.id
  route_table_id          = aws_route_table.aws-routeAC.id
}

resource "aws_route_table_association" "aws-route-netD" {
  subnet_id               = aws_subnet.aws-netD.id
  route_table_id          = aws_route_table.aws-routeBD.id
}
