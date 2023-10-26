variable "vpc_id" {}

variable "webserver_port" {
    default = 80
}

variable "webserver_protocol" {
    default = "HTTP"
}

variable "webapp_port" {
    default = 5173
}

variable "key_name" {
    default = "hat_trick_ssh_key"
}

variable "ami" {
  default = "ami-0a4b7ff081ca1ded9"
}

variable "user_data" {
  default = ""
}

variable "role_profile_name" {
    default = ""
}

variable "instance_type" {
    default = "t2.micro"
}

# ===== ASG related stuff =====
variable "min_instance" {
  description = "Min nb of EC2 instances in ASG"
  default = 2
}

variable "desired_instance" {
  description = "Starting nb of EC2 instances in ASG"
  default = 2
}

variable "max_instance" {
  description = "Max nb of EC2 instances in ASG"
  default = 4
}
# ============================

variable "private_subnet_ids" {
    type = list
}

variable "public_subnet_ids" {
  type = list
}