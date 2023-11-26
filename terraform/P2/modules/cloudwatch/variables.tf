variable "asg_name" {
  description = "ASG name used to increase or decrease ec2 instances"
}

variable "max_cpu_percent_alarm" {
  description = "% of CPU usage before scale up"
  default     = 80
}

variable "min_cpu_percent_alarm" {
  description = "% of CPU usage before scale down"
  default     = 5
}