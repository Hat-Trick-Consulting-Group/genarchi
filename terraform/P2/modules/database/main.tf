resource "aws_security_group" "database" {
  name        = "database-sg"
  description = "security group for the database"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = var.webapp_sg_id
    self            = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database"
  }
}

resource "aws_instance" "database" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.database.id]
  key_name        = var.ssh_key_name
  subnet_id       = var.private_subnet_ids[0]
  user_data       = var.user_data

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name" = "database"
  }
}