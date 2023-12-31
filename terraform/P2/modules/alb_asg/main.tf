# Security group for ALB
resource "aws_security_group" "sg-ALB-public" {
  vpc_id      = var.vpc_id
  name        = "ALB-public-sg"
  description = "security group for the application load balancer"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.alb_front_port
    to_port     = var.alb_front_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.alb_back_port
    to_port     = var.alb_back_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-public"
  }
}

# Security groupe for Backend ASG instances
resource "aws_security_group" "sg-backend-instances" {
  vpc_id      = var.vpc_id
  name        = "Backend-sg"
  description = "security group for the backend instances"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = var.webapp_back_port
    to_port   = var.webapp_back_port
    protocol  = "tcp"
    # traffic from ALB to EC2 instances is allowed only from ALB security group (sg-ALB-public) that is to say from ALB port 80 to EC2 instances port 80
    security_groups = [aws_security_group.sg-ALB-public.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-backend"
  }
}


# Security groupe for Frontend ASG instances
resource "aws_security_group" "sg-frontend-instances" {
  vpc_id      = var.vpc_id
  name        = "Frontend-sg"
  description = "security group for the frontend instances"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = var.webapp_front_port
    to_port   = var.webapp_front_port
    protocol  = "tcp"
    # traffic from ALB to EC2 instances is allowed only from ALB security group (sg-ALB-public) that is to say from ALB port 80 to EC2 instances port 80
    security_groups = [aws_security_group.sg-ALB-public.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-frontend"
  }
}

# Launch configuration for backend ASG
resource "aws_launch_configuration" "backend-launchconfig" {
  name_prefix     = "backend-launchconfig"
  image_id        = var.ami
  instance_type   = var.instance_type
  key_name        = var.ssh_key_name # may fail
  security_groups = [aws_security_group.sg-backend-instances.id]
  user_data       = var.user_data_backend

  lifecycle {
    create_before_destroy = true
  }
}

# Launch configuration for  frontend ASG
resource "aws_launch_configuration" "frontend-launchconfig" {
  name_prefix     = "frontend-launchconfig"
  image_id        = var.ami
  instance_type   = var.instance_type
  key_name        = var.ssh_key_name # may fail
  security_groups = [aws_security_group.sg-frontend-instances.id]
  user_data       = var.user_data_frontend

  lifecycle {
    create_before_destroy = true
  }
}

# ASG Backend
resource "aws_autoscaling_group" "backend-autoscaling" {
  name                      = "backend-autoscaling"
  vpc_zone_identifier       = var.private_subnet_ids
  launch_configuration      = aws_launch_configuration.backend-launchconfig.name
  min_size                  = var.min_instance                                   #nb min of EC2 instances in asg
  desired_capacity          = var.desired_instance                               #nb of EC2 instances at start in asg
  max_size                  = var.max_instance                                   #nb max of EC2 instances in asg
  health_check_grace_period = 300                                                #seconds before an instance is terminated if unhealthy
  health_check_type         = "ELB"                                              #TODO CHECK
  target_group_arns         = [aws_lb_target_group.webapp-back-target-group.arn] #ARN = Amazon Resource Names
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "backend"
    propagate_at_launch = true
  }
}

# ASG Frontend
resource "aws_autoscaling_group" "frontend-autoscaling" {
  name                      = "frontend-autoscaling"
  vpc_zone_identifier       = var.private_subnet_ids
  launch_configuration      = aws_launch_configuration.frontend-launchconfig.name
  min_size                  = var.min_instance                                    #nb min of EC2 instances in asg
  desired_capacity          = var.desired_instance                                #nb of EC2 instances at start in asg
  max_size                  = var.max_instance                                    #nb max of EC2 instances in asg
  health_check_grace_period = 300                                                 #seconds before an instance is terminated if unhealthy
  health_check_type         = "ELB"                                               #TODO CHECK
  target_group_arns         = [aws_lb_target_group.webapp-front-target-group.arn] #ARN = Amazon Resource Names
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "frontend"
    propagate_at_launch = true
  }
}

# ALB
resource "aws_lb" "webapp-alb" {
  name               = "webapp-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.sg-ALB-public.id]

  tags = {
    Name = "webapp-alb-tf"
  }
}


# ALB listener front
resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.webapp-alb.arn
  port              = var.alb_front_port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp-front-target-group.arn
  }
}

# ALB listener back
resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.webapp-alb.arn
  port              = var.alb_back_port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp-back-target-group.arn
  }
}

# ALB Target front
resource "aws_lb_target_group" "webapp-front-target-group" {
  name     = "webapp-front-tg"
  port     = var.webapp_instance_front_port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 5
    path                = "/"
    matcher             = "200"
  }
}

# ALB Target back
resource "aws_lb_target_group" "webapp-back-target-group" {
  name     = "webapp-back-tg"
  port     = var.webapp_instance_back_port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 5
    path                = "/health"
    matcher             = "200"
  }
}
