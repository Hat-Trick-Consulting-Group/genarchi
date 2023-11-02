variable "vpc_id" {}

variable "db_port" {
  default = 5432
}

variable "ami" {
  default = "ami-0a4b7ff081ca1ded9"
}

variable "ssh_key_name" {
  default = "hat_trick_ssh_key"
}

variable "user_data" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "private_subnet_ids" {
  type = list(any)
}

variable "webapp_sg_id" {
  type        = list(any)
  description = "security group for the WebApp instances"
}
