# Security group for ALB
resource "aws_security_group" "sg-ALB-public" {
  vpc_id = var.vpc_id
  name = "sg-ALB-public"
  description = "security group for the application load balancer"

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
    from_port = var.webserver_port
    to_port = var.webserver_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0/0"]
  }

  tags = {
    Name = "sg-ALB-public"
  }
}

# Security groupe for WebApp ASG instances
resource "aws_security_group" "sg-WebApp" {
    vpc_id = var.vpc_id
    name = "sg-WebApp"
    description = "security group for the WebApp instances"
    egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
    ingress = {
        from_port = var.webapp_port
        to_port = var.webapp_port
        protocol = "tcp"
        # Authorize traffic only from ALB security group
        security_groups = [aws_security_group.sg-ALB-public.id]
    }

    tags = {
      Name = "sg-WebApp"
    }
}

# Get public key to connect to EC2 instances
data "aws_key_pair" "mykeypair" {
  key_name = var.key_name
  include_public_key = true
}

# Launch configuration for WebApp ASG
resource "aws_launch_configuration" "webapp-launchconfig" {
    name_prefix = "webapp-launchconfig"
    image_id = var.ami
    instance_type = var.instance_type
    key_name = aws_key_pair.mykeypair.key_name
    security_groups = [aws_security_group.sg-WebApp.id]
    #TODO: add user_data to setup env (dl go and node)
    user_data = var.user_data
    #TODO: add iam_instance_profile to allow EC2 to access S3??????????????
    iam_instance_profile = var.role_profile_name

    lifecycle {
        create_before_destroy = true
    }
}

# ASG
resource "aws_autoscaling_group" "webapp-autoscaling" {
    name = "webapp-autoscaling"
    vpc_zone_identifier = var.private_subnet_ids #Error here, maybe bcs of the repo architecture ?
    launch_configuration = aws_launch_configuration.webapp-launchconfig.name
    min_size = var.min_instance #nb min of EC2 instances in asg
    desired_capacity = var.desired_instance #nb of EC2 instances at start in asg
    max_size = var.max_instance #nb max of EC2 instances in asg
    health_check_grace_period = 300 #seconds before an instance is terminated if unhealthy
    health_check_type = "ELB"
    target_group_arns = [ aws_lb_target_group.alb-target-group.arn ] #TODEFINE !!! ARN = Amazon Resource Names
    force_delete = true

    tag {
      key = "Name"
      value = "webapp"
      propagate_at_launch = true
    }
}

# ALB
resource "aws_lb" "webapp-alb" {
    name = "webapp-alb"
    internal = false
    load_balancer_type = "application"
    subnets = var.public_subnet_ids
    security_groups = [aws_security_group.sg-ALB-public.id]

    tags = {
      Name = "webapp-alb-tf"
    }
}

# ALB Targets
resource "aws_lb_target_group" "alb-target-group" {
    name = "webapp-tg"
    port = var.webserver_port
    protocol = var.webserver_protocol
    vpc_id = var.vpc_id
}

# ALB listener
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = "${aws_lb.webapp-alb.arn}"
  port = var.webserver_port
  protocol = var.webserver_protocol

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.alb-target_group.arn}"
  }
}