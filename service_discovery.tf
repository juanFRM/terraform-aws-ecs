resource "aws_service_discovery_private_dns_namespace" "this" {
  count       = var.enable_service_discovery == "yes" ? 1 : 0
  name        = var.private_dns == "" ? "${var.app_name}.local" : var.private_dns
  description = "For ECS internal service discovery"
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "this" {
  count = var.enable_service_discovery == "yes" ? length(var.ecs_internal_services) : 0
  name  = lookup(var.ecs_internal_services[count.index], "name", null)

  dns_config {
    namespace_id = one(aws_service_discovery_private_dns_namespace.this.*.id)

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

