resource "aws_subnet" "development-subnet-1" {
  vpc_id            = var.vpc-id
  cidr_block        = var.dev-subnet-cidr-block
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.env-prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "dev-igw" {
  vpc_id = var.vpc-id

  tags = {
    Name = "${var.env-prefix}-igw"
  }

}

resource "aws_default_route_table" "dev-main-rt" {
  default_route_table_id = var.default-route-table-id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }
  tags = {
    Name = "${var.env-prefix}-main-rtb"
  }
}