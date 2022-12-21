resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.app_name}_ecs_task_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

}

resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.app_name}_ecs_task_execution_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role" "ecs_autoscale_role" {
  name               = "${var.app_name}_ecs_autoscaling_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_autoscale.json
}

resource "aws_iam_role_policy_attachment" "ecs_autoscale" {
  role       = aws_iam_role.ecs_autoscale_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}