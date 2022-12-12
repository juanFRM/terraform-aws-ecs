resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "this" {
  for_each                 = var.task_definitions
  family                   = lookup(each.value, "family", var.app_name)
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = 2048
  memory                   = 8192
  container_definitions = jsonencode([
    {
      name      = lookup(each.value, "name", var.app_name)
      image     = each.value.ecr_image_url
      cpu       = lookup(each.value, "cpu", 1024)
      memory    = lookup(each.value, "memory", 2048)
      essential = true
      portMappings = [
        {
          containerPort = each.value.container_port
        }
      ]
      environment = lookup(each.value, "env_vars", null)
      mountPoints = [
        {
          containerPath = lookup(each.value, "container_path", "/opt/shared")
          sourceVolume  = "shared"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = lookup(each.value, "log_group", "/ecs/${var.app_name}")
          awslogs-region        = "${var.region}"
          awslogs-stream-prefix = lookup(each.value, "log_stream_prefix", "${var.app_name}-log-stream")
        }
      }

    }
  ])

  volume {
    name = "shared"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.efs.id
      root_directory = "/"
    }

  }
}

resource "aws_ecs_service" "this" {
  for_each        = var.ecs_services
  name            = lookup(each.value, "name", "${var.app_name}-service")
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this[each.key].arn

  desired_count = lookup(each.value, "app_count", 1)

  launch_type = lookup(each.value, "launch_type", "FARGATE")

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.ecs.id]
  }
  service_registries {
    registry_arn = var.enable_service_discovery == "yes" ? one(aws_service_discovery_service.this.*.arn) : null

  }
  load_balancer {
    target_group_arn = lookup(each.value, "target_group_arn", null)
    container_name   = lookup(each.value, "container_name", null)
    container_port   = lookup(each.value, "container_port", null)
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }
}