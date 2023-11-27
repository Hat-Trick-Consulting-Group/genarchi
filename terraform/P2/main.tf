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

locals {
  db_port    = 27017
  git_branch = "main"
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  azs                  = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}

module "sg_database" {
  source       = "./modules/database/sg_database"
  vpc_id       = module.vpc.vpc_id
  db_port      = local.db_port
  webapp_sg_id = module.alb_asg.webapp_sg_id
}

module "database_1" {
  source            = "./modules/database/instance_database"
  ami               = "ami-00983e8a26e4c9bd9"
  ssh_key_name      = "hat_trick_ssh_key"
  instance_type     = "t2.micro"
  sg_db_id          = module.sg_database.sg_db_id
  private_subnet_id = module.vpc.private_subnet_ids[0]
  user_data = templatefile("./scripts/database_user_data.sh", {
    db_port      = local.db_port
    git_branch   = local.git_branch
    db_host_ip_1 = "" # only for database_3
    db_host_ip_2 = "" # only for database_3
    is_last_node = false
  })
}

module "database_2" {
  source            = "./modules/database/instance_database"
  ami               = "ami-00983e8a26e4c9bd9"
  ssh_key_name      = "hat_trick_ssh_key"
  instance_type     = "t2.micro"
  sg_db_id          = module.sg_database.sg_db_id
  private_subnet_id = module.vpc.private_subnet_ids[1]
  user_data = templatefile("./scripts/database_user_data.sh", {
    db_port      = local.db_port
    git_branch   = local.git_branch
    db_host_ip_1 = "" # only for database_3
    db_host_ip_2 = "" # only for database_3
    is_last_node = false
  })
}

module "database_3" {
  source            = "./modules/database/instance_database"
  ami               = "ami-00983e8a26e4c9bd9"
  ssh_key_name      = "hat_trick_ssh_key"
  instance_type     = "t2.micro"
  sg_db_id          = module.sg_database.sg_db_id
  private_subnet_id = module.vpc.private_subnet_ids[2]
  user_data = templatefile("./scripts/database_user_data.sh", {
    db_port      = local.db_port
    git_branch   = local.git_branch
    is_last_node = true
    db_host_ip_1 = module.database_1.db_instance_ip
    db_host_ip_2 = module.database_2.db_instance_ip
  })
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
  min_instance               = 3
  desired_instance           = 3
  max_instance               = 6
  ami                        = "ami-0a4b7ff081ca1ded9"
  ssh_key_name               = "hat_trick_ssh_key"
  vpc_id                     = module.vpc.vpc_id
  user_data = templatefile("./scripts/webapp_user_data.sh", {
    alb_dns_name = module.alb_asg.alb_dns_name
    db_host_ip_1 = module.database_1.db_instance_ip
    db_host_ip_2 = module.database_2.db_instance_ip
    db_host_ip_3 = module.database_3.db_instance_ip
    db_port      = local.db_port
    git_branch   = local.git_branch
  })
}

module "cloudwatch_cpu_alarm" {
  source                = "./modules/cloudwatch"
  min_cpu_percent_alarm = 5  #5
  max_cpu_percent_alarm = 80 #80
  asg_name              = module.alb_asg.asg_name
}

resource "null_resource" "print_alb_dns_name" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "echo 'ALB DNS Name: ${module.alb_asg.alb_dns_name}'"
  }
}