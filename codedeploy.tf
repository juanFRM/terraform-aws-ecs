resource "aws_codedeploy_app" "this" {
  count            = var.enable_cicd == "yes" && var.enable_bluegreen_deployments == "yes" ? 1 : 0
  compute_platform = "ECS"
  name             = var.app_name
}

resource "aws_codedeploy_deployment_group" "this" {
  for_each = var.enable_cicd == "yes" && var.enable_bluegreen_deployments == "yes" ? { for k, v in var.ecs_applications : k => v if v.attach_alb == "yes" } : {}

  app_name               = one(aws_codedeploy_app.this.*.name)
  deployment_group_name  = "${each.value.name}-dg"
  service_role_arn       = var.cicd_role
  deployment_config_name = var.deployment_config_name

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = var.action_on_timeout
      wait_time_in_minutes = var.wait_time_in_minutes
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = var.termination_wait_time_in_minutes
    }
  }
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = each.value.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [one(aws_lb_listener.alb_https.*.arn)]
      }
      target_group {
        name = aws_lb_target_group.alb[each.key].name
      }
      target_group {
        name = aws_lb_target_group.alb_bg[each.key].name
      }
      test_traffic_route {
        listener_arns = [one(aws_lb_listener.alb_https_bg.*.arn)]
      }
    }
  }

}