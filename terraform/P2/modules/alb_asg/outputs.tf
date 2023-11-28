output "alb_dns_name" {
  value = aws_lb.webapp-alb.dns_name
}

output "backend_sg_id" {
  value = [aws_security_group.sg-backend-instances.id]
}

output "asg_name_frontend" {
  value = aws_autoscaling_group.frontend-autoscaling.name
}
output "asg_name_backend" {
  value = aws_autoscaling_group.backend-autoscaling.name
}
