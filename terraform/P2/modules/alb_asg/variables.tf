variable "vpc_id" {}

variable "protocol" {
  default = "HTTP"
}

variable "alb_front_port" {
  default = 80
}

variable "alb_back_port" {
  default = 8080
}

variable "webapp_instance_front_port" {
  default = 80
}

variable "webapp_instance_back_port" {
  default = 8080
}

variable "webapp_front_port" {
  default = 80
}

variable "webapp_back_port" {
  default = 8080
}

variable "ssh_key_name" {
  default = "hat_trick_ssh_key"
}

variable "ami" {
  default = "ami-0a4b7ff081ca1ded9"
}

variable "user_data" {}

variable "instance_type" {
  default = "t2.micro"
}

# ===== ASG related stuff =====
variable "min_instance" {
  description = "Min nb of EC2 instances in ASG"
  default     = 2
}

variable "desired_instance" {
  description = "Starting nb of EC2 instances in ASG"
  default     = 2
}

variable "max_instance" {
  description = "Max nb of EC2 instances in ASG"
  default     = 4
}
# ============================

variable "private_subnet_ids" {
  type = list(any)
}

variable "public_subnet_ids" {
  type = list(any)
}