output "alb_dns_name" {
  value = aws_lb.webapp-alb.dns_name
}

output "webapp_sg_id" {
  value = aws_security_group.sg-WebApp.id
}
