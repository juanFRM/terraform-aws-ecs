resource "aws_codebuild_project" "this" {
  for_each      = var.enable_cicd == "yes" ? var.ecs_applications : {}
  name          = "${var.project_name}-ecs-${each.value.name}"
  build_timeout = "10"
  service_role  = var.cicd_role

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = var.compute_type
    image           = var.image
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    dynamic "environment_variable" {
      for_each = var.build_environment_variables

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
      }
    }


  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.codebuild[each.key].name
      stream_name = aws_cloudwatch_log_stream.codebuild[each.key].name
    }

    s3_logs {
      status   = "ENABLED"
      location = "${var.s3_build_logs_bucket}/${var.environment}/${each.value.name}-build-log"
    }
  }

  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.subnets
    security_group_ids = [var.codebuild_security_group]
  }


  source {
    type = "CODEPIPELINE"
    buildspec = templatefile(var.buildspec_file, {
      REGION          = var.region
      AWS_ACCOUNT_ID  = var.ecr_account_id
      ECR_REPO_NAME   = each.key
      CONTAINER_NAME  = each.value.name
      CONTAINER_PORT  = lookup(each.value, "container_port", var.container_port)
      TASK_DEFINITION = each.value.name
      GIT_REPO_NAME   = lookup(each.value, "git_repo_name", "") # To support git submodules
    })
  }

}