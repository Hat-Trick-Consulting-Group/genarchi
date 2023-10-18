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
  region  = "eu-west-3"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

# terraform{} block contains T's settings
# "hashicorp/aws": Hashicorp = T's registry
# version is optional (if not specified, T download the latest)

# provider{} block configure the specified provider (aws)
# provider = T's plugin used to create and manage ressources

# ressource{} block used to define components of the infrastructure
# need2 2 str params: 1st is the type ("aws_instance"), 2nd name ("app_server")
# The prefix of type ("aws") maps to the provider "aws"
# A unique ID is formed : aws_instance.app_server

# ami id (image stockee sur aws, ici Ubuntu)
# instance_type = type de vm
