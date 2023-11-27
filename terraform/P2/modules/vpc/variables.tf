variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  validation {
    condition     = length(var.public_subnets_cidr) == 3
    error_message = "The length of the public subnet list must be 3"
  }
}

variable "private_subnets_cidr" {
  type    = list(any)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  validation {
    condition     = length(var.private_subnets_cidr) == 3
    error_message = "The length of the private subnet list must be 3"
  }
}

variable "azs" {
  type        = list(any)
  description = "AZs to use in your public and private subnet  (make sure they are consistent with your AWS region)"
  default     = ["eu-west-3a", "eu-west-3b"]
}
