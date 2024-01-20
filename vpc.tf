resource "aws_vpc" "demo-monish" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
    created_by=var.created_by
    created_for=var.created_for
    Terraformed="True"
  }
}


#subnets

resource "aws_subnet" "demo-monish-public-subnets" {
  count = length(var.subnet_cidrs_public)
  vpc_id     = aws_vpc.demo-monish.id
  cidr_block = var.subnet_cidrs_public[count.index]
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = "true"
  enable_resource_name_dns_a_record_on_launch = "true"
  tags = {
    Name = "monish-demo-public-subnet-2b"
    created_by = var.created_by
    created_for = var.created_for
    Terraformed = "True"
  }
}


#IGW

resource "aws_internet_gateway" "demo-monish-igw" {
  vpc_id = aws_vpc.demo-monish.id
  tags = {
    Name = "demo-monish-igw"
    created_by = var.created_by
    created_for = var.created_for
    Terraformed = "True"
  }
}

#routetable

resource "aws_route_table" "demo-monish-public-rt" {
  vpc_id = aws_vpc.demo-monish.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-monish-igw.id
  }

  tags = {
    Name = "demo-monish-public-rt"
    created_by = var.created_by
    created_for = var.created_for
    Terraformed = "True"
  }
}


resource "aws_route_table_association" "public-2a" {
  count = length(var.subnet_cidrs_public)
  subnet_id      = element(aws_subnet.demo-monish-public-subnets.*.id, count.index)
  route_table_id = aws_route_table.demo-monish-public-rt.id
}




#security group

resource "aws_security_group" "demo-monish" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.demo-monish.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.demo-monish.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.demo-monish.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
