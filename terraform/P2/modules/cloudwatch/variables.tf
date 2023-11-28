variable "asg_name" {
  type        = list(any)
  description = "list of ASG name used to increase or decrease ec2 instances"
}

variable "max_cpu_percent_alarm" {
  description = "% of CPU usage before scale up"
  default     = 80
}

variable "min_cpu_percent_alarm" {
  description = "% of CPU usage before scale down"
  default     = 5
}