terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.AWS_REGION
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
}

module "my_alb_asg" {
    source               = "./modules/alb_asg"
    webserver_port       = 80
    webserver_protocol   = "HTTP"
    instance_type        = "t2.micro"
    private_subnet_ids   = module.my_vpc.private_subnet_ids
    public_subnet_ids    = module.my_vpc.public_subnet_ids
    role_profile_name            = module.my_ec2_role_allow_s3.name
    min_instance         = 2
    desired_instance     = 2
    max_instance         = 3
    ami                  = data.aws_ami.ubuntu-ami.id
    path_to_public_key   = "path of your public key"
    vpc_id               = module.my_vpc.vpc_id
    prefix_name          = var.prefix_name
    user_data = <<-EOF
      #!/bin/bash
      sudo apt-get update -y
      sudo apt-get install -y apache2 awscli mysql-client php php-mysql
      sudo systemctl start apache2
      sudo systemctl enable apache2
      sudo rm -f /var/www/html/index.html
      sudo aws s3 sync  s3://${var.bucket_name}/ /var/www/html/
      mysql -h ${module.my_rds.host} -u ${module.my_rds.username} -p${var.db_password} < /var/www/html/articles.sql
      sudo sed -i 's/##DB_HOST##/${module.my_rds.host}/' /var/www/html/db-config.php
      sudo sed -i 's/##DB_USER##/${module.my_rds.username}/' /var/www/html/db-config.php
      sudo sed -i 's/##DB_PASSWORD##/${var.db_password}/' /var/www/html/db-config.php
    EOF  
}