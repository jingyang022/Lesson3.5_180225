# Create ECS task role
resource "aws_iam_role" "ecs_task_role" {
 name = "yap-ecs-xray-taskrole"

  assume_role_policy = jsonencode({
   Version = "2012-10-17",
   Statement = [
     {
       Action = "sts:AssumeRole",
       Principal = {
         Service = "ecs-tasks.amazonaws.com"
       },
       Effect = "Allow"
     }
   ]
 })
}

resource "aws_iam_role_policy_attachment" "ecs_task_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}