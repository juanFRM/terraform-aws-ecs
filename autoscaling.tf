resource "aws_appautoscaling_target" "ecs" {
  for_each = {
    for k, v in var.ecs_applications : k => v
    if v.enable_service == "yes"
  }
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.this[each.key].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs_autoscale_role.arn
}

resource "aws_appautoscaling_policy" "ecs_scale_cpu" {
  for_each = {
    for k, v in var.ecs_applications : k => v
    if v.enable_service == "yes"
  }
  name               = "${aws_ecs_service.this[each.key].name}-scaling-policy-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.ecs]
}

resource "aws_appautoscaling_policy" "ecs_scale_memory" {
  for_each = {
    for k, v in var.ecs_applications : k => v
    if v.enable_service != "yes"
  }
  name               = "${aws_ecs_service.this[each.key].name}-scaling-policy-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.ecs]
}