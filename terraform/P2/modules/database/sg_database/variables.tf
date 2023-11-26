variable "vpc_id" {}

variable "db_port" {
  default = 27017
}

variable "webapp_sg_id" {
  type        = list(any)
  description = "security group for the WebApp instances"
}