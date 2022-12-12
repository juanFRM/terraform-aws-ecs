resource "aws_cloudwatch_log_group" "app_log_group_1" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = var.log_retention_in_days

}

resource "aws_cloudwatch_log_stream" "app_log_stream_1" {
  name           = "${var.app_name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.app_log_group_1.name
}
