output "task_arns" {
  value = { for k, v in aws_ecs_task_definition.this.*.arn : k => v.id }
}

output "cluster_arn" {
  value = aws_ecs_cluster.this.arn
}

output "security_group_id" {
  value = aws_security_group.ecs.id
}