resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Terraform_vpc"
  }
}

resource "aws_subnet" "Public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
 
  tags = {
    Name = "Public_subnet"
  }
}

resource "aws_subnet" "Private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_eip" "eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.Public_subnet.id

  tags = {
    Name = "NAT"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "Public-RT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-RT"
  }
}

resource "aws_route_table" "Private-RT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "Private-RT"
  }
}

resource "aws_route_table_association" "Public_assoc" {
  subnet_id      = aws_subnet.Public_subnet.id
  route_table_id = aws_route_table.Public-RT.id
}

resource "aws_route_table_association" "Private_assoc" {
  subnet_id      = aws_subnet.Private_subnet.id
  route_table_id = aws_route_table.Private-RT.id
}

resource "aws_security_group" "sg" {
  name        = "sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "Security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
 security_group_id = aws_security_group.sg.id
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "web-server" {
  ami                         = "ami-068c0051b15cdb816"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.Public_subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true

 tags = {
    Name = "Web_server"
  }

   user_data = file("userdata.sh")
}

resource "aws_instance" "DB" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.Private_subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "Database_server"
  }
}