output "alb_dns_name" {
  value = aws_lb.webapp-alb.dns_name
}

output "webapp_sg_id" {
  value = [aws_security_group.sg-WebApp-instances.id]
}

output "asg_name" {
  value = aws_autoscaling_group.webapp-autoscaling.name
}
