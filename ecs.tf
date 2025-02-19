# Create ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "yap-flask-xray-cluster"
}

# Create ECS task definition
# resource "aws_ecs_task_definition" "service" {
#   family = "yap-flask-xray-taskdef"
#   task_role_arn            = aws_iam_role.ecs_task_role.arn
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = 1024
#   memory                   = 3072
  
#   container_definitions = jsonencode([
#     {
#       name      = "first"
#       image     = "service-first"
#       cpu       = 10
#       memory    = 512
#       essential = true
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80
#         }
#       ]
#     },
#     {
#       name      = "second"
#       image     = "service-second"
#       cpu       = 10
#       memory    = 256
#       essential = true
#       portMappings = [
#         {
#           containerPort = 443
#           hostPort      = 443
#         }
#       ]
#     }
#   ])
# }

# Create ECS service
# resource "aws_ecs_service" "main" {
#     name            = "cb-service"
#     cluster         = aws_ecs_cluster.main.id
#     task_definition = aws_ecs_task_definition.app.arn
#     desired_count   = var.app_count
#     launch_type     = "FARGATE"

#     network_configuration {
#         security_groups  = [aws_security_group.ecs_tasks.id]
#         subnets          = aws_subnet.private.*.id
#         assign_public_ip = true
#     }

#     load_balancer {
#         target_group_arn = aws_alb_target_group.app.id
#         container_name   = "cb-app"
#         container_port   = var.app_port
#     }

#     depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
# }