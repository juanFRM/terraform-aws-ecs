resource "aws_ecr_repository" "app" {
  for_each             = var.environment == "dev" ? var.ecs_applications : {}
  name                 = each.key
  image_tag_mutability = "MUTABLE"
  tags = {
    "environment" = var.environment
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
  image_scanning_configuration {
    scan_on_push = true
  }

}

resource "aws_ecr_repository_policy" "crossaccount" {
  for_each   = var.environment == "dev" ? var.ecs_applications : {}
  repository = aws_ecr_repository.app[each.key].name
  policy     = var.ecr_policy

}