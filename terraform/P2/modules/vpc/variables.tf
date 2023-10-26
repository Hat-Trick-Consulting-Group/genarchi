variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.3.0/24"
}

variable "azs" {
  description = "AZs to use in your public and private subnet  (make sure they are consistent with your AWS region)"
  default     = "eu-west-3a"
}
