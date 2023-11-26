output "sg_db_id" {
  description = "value of the security group id for the database"
  value       = aws_security_group.database.id
}