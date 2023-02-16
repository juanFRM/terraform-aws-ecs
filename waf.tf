module "waf" {
  count  = var.create_alb ? 1 : 0
  source = "github.com/revstarconsulting/terraform-aws-waf?ref=v1.1.0"

  environment        = var.environment
  name               = "${var.app_name}_alb_waf"
  scope              = "REGIONAL"
  associate_alb      = true
  alb_arn            = aws_lb.alb[count.index].arn
  tag_application    = var.app_name
  tag_key_contact    = var.app_name
  tag_parent_project = var.app_name
  tag_cost_center    = 12345
  tag_billing_ref    = var.app_name
}