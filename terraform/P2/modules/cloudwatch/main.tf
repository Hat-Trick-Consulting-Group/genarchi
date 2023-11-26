# Scale Up alarm
resource "aws_autoscaling_policy" "cpu-policy-scaleup" {
  name                   = "cpu-policy-scaleup"
  autoscaling_group_name = var.asg_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1   #Nb of members by which to scale
  cooldown               = 120 #Amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start.
  policy_type            = "SimpleScaling"
}

# CPU metrics to scale up
resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scaleup" {
  alarm_name          = "cpu-alarm"
  alarm_description   = "cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 10 #seconds
  statistic           = "Average"
  threshold           = var.max_cpu_percent_alarm

  #Add here ressources you want to monitor with the cloudwatch
  dimensions = {
    "AutoScalingGroupName" = var.asg_name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu-policy-scaleup.arn]
}

# Scale down alarm
resource "aws_autoscaling_policy" "cpu-policy-scaledown" {
  name                   = "cpu-policy-scaledown"
  autoscaling_group_name = var.asg_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = 120
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scaledown" {
  alarm_name          = "cpu-alarm-scaledown"
  alarm_description   = "cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 10
  statistic           = "Average"
  threshold           = var.min_cpu_percent_alarm

  dimensions = {
    "AutoScalingGroupName" = var.asg_name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu-policy-scaledown.arn]
}


