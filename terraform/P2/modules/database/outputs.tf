output "db_instance_id" {
  description = "The ID of the created EC2 instance."
  value       = aws_instance.database.id
}
