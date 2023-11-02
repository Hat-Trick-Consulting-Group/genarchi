resource "aws_vpc" "prod-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  # enable_classiclink = "false"
  instance_tenancy = "default"

  tags = {
    Name = "prod-vpc"
  }
}

resource "aws_subnet" "prod-subnet-public" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.public_subnets_cidr[count.index]
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone       = var.azs[count.index]
  tags = {
    Name = "prod-subnet-public-${count.index}"
  }
}

resource "aws_subnet" "prod-subnet-private" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "prod-subnet-private-${count.index}"
  }
}

resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.prod-vpc.id
  tags = {
    Name = "main-gw"
  }
}

# Public route table
resource "aws_route_table" "public-subnet-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  # 0.0.0.0/0 => all traffic from public subnet
  # nat_geteway => will go to internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "public-subnets"
  }
}

# Associate public route table with public subnet
resource "aws_route_table_association" "associate-public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.prod-subnet-public[count.index].id
  route_table_id = aws_route_table.public-subnet-route-table.id
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
  subnet_id     = aws_subnet.prod-subnet-public[0].id # public subnet why???
  depends_on    = [aws_internet_gateway.main-gw]      # nat gw depends on internet gw??
}

# Private route table
resource "aws_route_table" "private-subnet-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  # 0.0.0.0/0 => all traffic from private subnet
  # nat_geteway => will go to nat gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "private-subnets"
  }
}

# Associate private route table with private subnet
resource "aws_route_table_association" "associate-private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = aws_subnet.prod-subnet-private[count.index].id
  route_table_id = aws_route_table.private-subnet-route-table.id
}