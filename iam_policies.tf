resource "aws_iam_role_policy" "ecs_task_role_policy" {
  name   = "access_aws_services"
  policy = data.aws_iam_policy_document.ecs_tasks.json
  role   = aws_iam_role.ecs_task_role.id
}

resource "aws_iam_role_policy" "ecs_task_execution_role_policy" {
  name   = "access_aws_services"
  policy = data.aws_iam_policy_document.ecs_tasks.json
  role   = aws_iam_role.ecs_execution_role.id
}

data "aws_iam_policy_document" "ecs_tasks" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "s3:*",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup"
    ]
    resources = ["*"]
  }
}



data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

