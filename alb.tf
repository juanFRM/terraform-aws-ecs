module "alb" {
  count = var.enable_load_balancer == "yes" ? 1 : 0

  source = "github.com/revstarconsulting/terraform-aws-load-balancer?ref=v1.3.3"

  environment = var.environment
  create_alb  = true
  lb_name     = var.app_name
  is_internal = var.internal_load_balancer

  vpc_id                 = var.vpc_id
  lb_subnets             = var.public_subnets
  logging_lb_bucket_name = var.logging_bucket_name
  certificate_arn        = var.acm_certificate_arn
  http_redirect          = var.http_redirect

  alb_target_groups = var.ecs_services

}