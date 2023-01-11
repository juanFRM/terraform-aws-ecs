resource "aws_cloudwatch_log_group" "this" {
  for_each          = var.ecs_applications
  name              = "/ecs/${each.value.name}"
  retention_in_days = var.log_retention_in_days

}

resource "aws_cloudwatch_log_stream" "this" {
  for_each       = var.ecs_applications
  name           = "${each.value.name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.this[each.key].name
}
