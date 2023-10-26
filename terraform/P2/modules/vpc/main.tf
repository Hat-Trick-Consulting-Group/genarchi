resource "aws_vpc" "prod-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  # enable_classiclink = "false"
  instance_tenancy = "default"

  tags = {
    Name = "prod-vpc"
  }
}

resource "aws_subnet" "prod-subnet-public-1" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone       = "eu-west-3a"
  tags = {
    Name = "prod-subnet-public-1"
  }
}

resource "aws_subnet" "prod-subnet-private-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-3a"
  tags = {
    Name = "prod-subnet-private-1"
  }
}

resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.prod-vpc.id
  tags = {
    Name = "main-gw"
  }
}

# Public route table
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.prod-vpc.id

  # 0.0.0.0/0 => all traffic from public subnet
  # nat_geteway => will go to internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }
}

# Associate public route table with public subnet
resource "aws_route_table_association" "main-public" {
  subnet_id      = aws_subnet.prod-subnet-public-1.id
  route_table_id = aws_route_table.main-public.id
}


# Elastic IP for NAT gw
resource "aws_eip" "nat" {
  #domain = "vpc"
  vpc = true

  tags = {
    Name = "main-eip"
  }
}

# Nat gw
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.prod-subnet-public-1.id # public subnet why???
  depends_on    = [aws_internet_gateway.main-gw]     # nat gw depends on internet gw??
}

# Private route table
resource "aws_route_table" "main-private" {
  vpc_id = aws_vpc.prod-vpc.id

  # 0.0.0.0/0 => all traffic from private subnet
  # nat_geteway => will go to nat gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "main-private"
  }
}