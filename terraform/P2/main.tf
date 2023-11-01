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
  source               = "./modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.3.0/24"]
  azs                  = ["eu-west-3a", "eu-west-3b"]
}

module "alb_asg" {
  source                     = "./modules/alb_asg"
  alb_front_port             = 80
  alb_back_port              = 8080
  webapp_instance_front_port = 80
  webapp_instance_back_port  = 8080
  webapp_front_port          = 80
  webapp_back_port           = 8080
  protocol                   = "HTTP"
  instance_type              = "t2.micro"
  private_subnet_ids         = module.vpc.private_subnet_ids
  public_subnet_ids          = module.vpc.public_subnet_ids
  min_instance               = 2
  desired_instance           = 2
  max_instance               = 3
  ami                        = "ami-0a4b7ff081ca1ded9"
  ssh_key_name               = "hat_trick_ssh_key"
  vpc_id                     = module.vpc.vpc_id
  user_data                  = templatefile("./scripts/webapp_user_data.sh", {
    alb_dns_name = module.alb_asg.alb_dns_name
  })
}

module "database" {
  source               = "./modules/database"
  vpc_id               = module.vpc.vpc_id
  db_port              = 5432
  ami                  = "ami-0a4b7ff081ca1ded9"
  ssh_key_name         = "hat_trick_ssh_key"
  instance_type        = "t2.micro"
  private_subnet_ids   = module.vpc.private_subnet_ids
  webapp_sg_id         = module.alb_asg.webapp_sg_id
  user_data            = templatefile("./scripts/database_user_data.sh", {
    db_name     = "hat_trick_db"
    db_username = "hat_trick_user"
    db_password = "hat_trick_password"
  })
}