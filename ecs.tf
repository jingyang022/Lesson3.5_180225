# Create ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "yap-flask-xray-cluster"
}

# Create ECS task definition
resource "aws_ecs_task_definition" "flask-xray-taskdef" {
  family = "yap-flask-xray-taskdef"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 3072
  
  container_definitions = jsonencode([
    {
      name      = "flask-app"
      image     = "255945442255.dkr.ecr.ap-southeast-1.amazonaws.com/yap-flask-xray-repo:latest"
      cpu       = 1024
      memory    = 3072
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
       environment = [
        {
          name  = "MY_APP_CONFIG"
          value = "arn:aws:ssm:ap-southeast-1:255945442255:parameter/yapapp/config"
        },
        {
          name  = "MY_DB_PASSWORD"
          value = "arn:aws:secretsmanager:ap-southeast-1:255945442255:secret:yapapp/db_password-VRnUa9"
        },
        {
          name  = "SERVICE_NAME"
          value = "yap-flask-xray-service"
        },
      ]
    },
    {
      name      = "xray-sidecar"
      image     = "amazon/aws-xray-daemon"
      cpu       = 1024
      memory    = 3072
      essential = false
      portMappings = [
        {
          containerPort = 2000
          hostPort      = 2000
          protocol      = "udp"
        }
      ]
    }
  ])
}

# Create ECS service
resource "aws_ecs_service" "yap-ecs-service" {
    name            = "yap-flask-service"
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.flask-xray-taskdef.arn
    desired_count   = 1
    force_delete    = true
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [aws_security_group.ecs-sg.id]
        subnets          = data.aws_subnets.public.ids
        assign_public_ip = true
    }

    # load_balancer {
    #     target_group_arn = aws_alb_target_group.app.id
    #     container_name   = "cb-app"
    #     container_port   = var.app_port
    # }

    # depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
}