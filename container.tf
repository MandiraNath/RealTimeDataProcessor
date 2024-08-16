resource "aws_ecs_cluster" "ecs_cluster" {
  name = "localstack-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "frequency-data-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "frequency-data-simulator",
      #  Docker image name
      image     = "datasimulatorimage",  
      essential = true,
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/frequency-data-task"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      },
      environment = [
        {
          name  = "frequency-data-stream"
          value = aws_kinesis_stream.kinesis_stream.name
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "frequency-data-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-12345678"] # LocalStack-specific, use any placeholder here
    security_groups = ["sg-12345678"]     # LocalStack-specific, use any placeholder here
    assign_public_ip = true
  }
}
