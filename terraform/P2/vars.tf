variable "AWS_REGION" {
  default = "eu-west-3"
}

variable "db_password" {
  description = "The password for the database"
  type = string
  sensitive = true
}

variable "db_username" {
  description = "The username for the database"
  type = string
  sensitive = true
}