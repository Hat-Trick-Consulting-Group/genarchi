output "vpc_id" {
  value = aws_vpc.prod-vpc.id
}

output "private_subnet_ids" {
  value = [for private_subnet in aws_subnet.prod-subnet-private : private_subnet.id]
}

output "public_subnet_ids" {
  value = [for public_subnet in aws_subnet.prod-subnet-public : public_subnet.id]
}