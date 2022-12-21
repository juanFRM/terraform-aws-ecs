resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.app_name}_ecs_task_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

}

resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.app_name}_ecs_task_execution_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}