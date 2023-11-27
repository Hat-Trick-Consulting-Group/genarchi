resource "aws_instance" "database" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [var.sg_db_id]
  key_name        = var.ssh_key_name
  subnet_id       = var.private_subnet_id
  user_data       = var.user_data

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name" = "database"
  }
}
