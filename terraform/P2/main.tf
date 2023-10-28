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
  webapp_front_port          = 5173
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
  user_data                  = <<-EOF
      #!/bin/bash

      # Update the OS and install necessary packages
      sudo yum update -y
      sudo yum install -y docker git

      # Install Go (adjust the version as needed)
      sudo yum install -y golang

      # Install Node.js and npm
      sudo yum install https://rpm.nodesource.com/pub_21.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
      sudo yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1

      # Install Docker Compose
      sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose

      sudo service docker start
      sudo systemctl enable docker

      # Clone your Git repository
      git clone https://github.com/Hat-Trick-Consulting-Group/genarchi.git

      # Change directory to the cloned repository
      cd genarchi

      # Start your Docker Compose services (assuming you have a Docker Compose file)
      sudo docker-compose up --build -d

      # Change directory to the backend and run your Go application
      cd backend
      go run main.go &

      # Change directory to the frontend and run your React application
      cd ../frontend
      npm install
      npm run build
      sudo npm install -g serve
      # Serve the production build on port 80 using 'serve'
      sudo serve -s dist -l 80 &
    EOF
}