resource "aws_vpc" "main_cloud" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "webserver_subnet" {
  vpc_id     = aws_vpc.main_cloud.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_security_group" "sg_ingress_http" {
  name        = "allow_http"
  description = "Allows ingress TCP traffic to port 80"
  ingress {
    description = "http to instance"
    protocol    = "tcp"

    to_port     = 80
    from_port   = 0 # any
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_ingress_ssh" {
  name        = "allow_ssh"
  description = "Allows ingress TCP traffic to port 22"
  ingress {
    description = "ssh to instance"
    protocol    = "tcp"

    to_port     = 22
    from_port   = 0 # any
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "gateway_main" {
  vpc_id = aws_vpc.main_cloud.id
}

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_cloud.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_main.id
  }
}

resource "aws_route_table_association" "main_rt_to_main_subnet" {
  route_table_id = aws_route_table.main_route_table.id
  subnet_id      = aws_subnet.webserver_subnet.id
}
