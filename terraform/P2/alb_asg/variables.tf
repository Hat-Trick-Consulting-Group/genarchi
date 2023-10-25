variable "vpc_id" {}

variable "webserver_port" {
    default = 80
}

variable "webapp_port" {
    default = 5173
}

variable "key_name" {
    default = "hat_trick_ssh_key"
}

variable "path_to_public_key" {
    default = "~/.ssh/hat_trick_ssh_key.pem"
}

variable "ami" {
  default = "ami-0a4b7ff081ca1ded9 (64-bit (x86))"
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
