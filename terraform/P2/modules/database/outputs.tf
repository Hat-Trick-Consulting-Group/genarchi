output "db_instance_ip" {
  description = "The IP address of the database instance"
  value       = aws_instance.database.private_ip
}
