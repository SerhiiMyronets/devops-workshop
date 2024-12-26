resource "aws_vpc" "project_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "${var.project.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "project-igw" {
  vpc_id = aws_vpc.project_vpc.id
  tags = {
    Name = "${var.project.project_name}-igw"
  }
}

resource "aws_route_table" "project-rt" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-igw.id
  }
  tags = {
    Name = "${var.project.project_name}-rt"
  }
}

resource "aws_route_table_association" "project-rta-public-subnet-01" {
  subnet_id      = aws_subnet.project_public_subnet_01.id
  route_table_id = aws_route_table.project-rt.id
}

resource "aws_route_table_association" "project-rta-public-subnet-02" {
  subnet_id      = aws_subnet.project_public_subnet_02.id
  route_table_id = aws_route_table.project-rt.id
}