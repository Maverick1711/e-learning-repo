# Create security group to allow 80 and 443
resource "aws_security_group" "e-learning-sg" {
  name        = "e-learningsg"
  description = "Allow 80 and 443 inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "e-learning-sg"
  }
}

# Create ALB
resource "aws_lb" "e-learning-alb" {
  name               = "e-learning-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.e-learning-sg.id]
  subnets            = [var.pub-sub-1-id,var.pub-sub-2-id]

  enable_deletion_protection = false

  tags = {
    Name = "e-learning-alb"
  }
}


resource "aws_alb_target_group" "e-learning-ntg" {
  name        = "elearning-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

# Forward / Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "e-learning-http" {
  load_balancer_arn = aws_lb.e-learning-alb.arn
  port              = 80
  protocol          = "HTTP"


# # Application load balancer forwarding traffic to unsecued port 80
#   default_action {
#     target_group_arn = aws_alb_target_group.e-learning-ntg.arn
#     type             = "forward"
#   }

# Application load balancer redirecting traffic to secured port 443
  default_action {
    type = "redirect"
 
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
   }
  }

 }


resource "aws_alb_listener" "e-learning-https" {
  load_balancer_arn = aws_lb.e-learning-alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.elearning_certificate_arn
 
  default_action {
    target_group_arn = aws_alb_target_group.e-learning-ntg.arn
    type             = "forward"
  }
}

#Create ECR
/* resource "aws_ecr_repository" "e-learning-repo" {
  name                 = "elearning-repo"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_lifecycle_policy" "e-learning" {
  repository = aws_ecr_repository.e-learning-repo.name
 
  policy = jsonencode({
   rules = [{
     rulePriority = 1
     description  = "keep last 10 images"
     action       = {
       type = "expire"
     }
     selection     = {
       tagStatus   = "any"
       countType   = "imageCountMoreThan"
       countNumber = 10
     }
   }]
  })
} */


# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "e-learning-ecs-tasks" {
  name        = "ecs-tasks-security-group"

  description = "allow inbound access from the ALB only"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.e-learning-sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create ECS cluster with all its dependencies
resource "aws_ecs_cluster" "e-learning-cluster" {
  name = "e-learning-cluster"
}


resource "aws_iam_role" "ecs_task_role" {
  name = "e-learningTaskRole"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "e-learning-ecsTaskExecutionRole"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
 

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# Creating task definition without json file
resource "aws_ecs_task_definition" "e-learning-td" {
  family                   = "e-learning-service"
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn  
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {

      name      = "e-learning-web"
      cpu       = 10
      memory    = 256
      image     = "public.ecr.aws/c4c2u2i7/e-repo:latest"
      essential = true
      portMappings = [
        {
          protocol      = "tcp"  
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

}


# Create cluster service
resource "aws_ecs_service" "e-learning-service" {
  name            = "e-learning-service"
  cluster         = aws_ecs_cluster.e-learning-cluster.id
  task_definition = aws_ecs_task_definition.e-learning-td.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.e-learning-ecs-tasks.id]
    subnets          = [var.priv-sub-1-id,var.priv-sub-2-id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.e-learning-ntg.arn
    container_name   = "e-learning-web"
    container_port   = 80
  }

 lifecycle {
   ignore_changes = [task_definition, desired_count]
 }
}


# Create autoscaling group
resource "aws_appautoscaling_target" "e-learning-asg" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.e-learning-cluster.name}/${aws_ecs_service.e-learning-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.e-learning-asg.resource_id
  scalable_dimension = aws_appautoscaling_target.e-learning-asg.scalable_dimension
  service_namespace  = aws_appautoscaling_target.e-learning-asg.service_namespace
 
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
   }
 
   target_value       = 80
  }
}
 
resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.e-learning-asg.resource_id
  scalable_dimension = aws_appautoscaling_target.e-learning-asg.scalable_dimension
  service_namespace  = aws_appautoscaling_target.e-learning-asg.service_namespace
 
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
   }
 
   target_value       = 60
  }
}


