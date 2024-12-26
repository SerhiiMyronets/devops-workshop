resource "aws_subnet" "project_public_subnet_01" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.project_az.names[0]
  tags = {
    Name = "${var.project.project_name}-subnet-01"
  }
}

resource "aws_subnet" "project_public_subnet_02" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.project_az.names[1]
  tags = {
    Name = "${var.project.project_name}-subnet-02"
  }
}