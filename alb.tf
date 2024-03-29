locals {
  access_mode = var.is_internal == "yes" ? true : false
}

resource "aws_lb" "alb" {
  count              = var.create_alb ? 1 : 0
  name               = var.lb_name
  load_balancer_type = "application"
  #tfsec:ignore:AWS005
  internal        = local.access_mode
  security_groups = [aws_security_group.load_balancer[0].id]
  subnets         = var.lb_subnets

  drop_invalid_header_fields = true
  access_logs {
    bucket  = var.logging_lb_bucket_name
    prefix  = var.lb_access_logs_prefix
    enabled = true
  }
  tags = local.common_tags
}

# Target group
resource "aws_lb_target_group" "alb" {
  for_each = var.alb_target_groups

  name        = each.value.name
  port        = lookup(each.value, "target_group_port", var.target_group_port)
  protocol    = lookup(each.value, "target_group_protocol", var.target_group_protocol)
  vpc_id      = var.vpc_id
  target_type = lookup(each.value, "target_type", "ip")

  tags       = local.common_tags
  depends_on = [aws_lb.alb]

  health_check {
    path                = lookup(each.value, "health_check_path", "/")
    port                = lookup(each.value, "health_check_port", "traffic-port")
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 30
    matcher             = "200,403,404,400,401,301,302"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Target Group for BG Deployments

resource "aws_lb_target_group" "alb_bg" {
  for_each = var.enable_bluegreen_deployments == "yes" ? var.alb_target_groups : {}

  name        = "${each.value.name}-test"
  port        = lookup(each.value, "target_group_port", var.target_group_port)
  protocol    = lookup(each.value, "target_group_protocol", var.target_group_protocol)
  vpc_id      = var.vpc_id
  target_type = lookup(each.value, "target_type", "ip")

  tags       = local.common_tags
  depends_on = [aws_lb.alb]

  health_check {
    path                = lookup(each.value, "health_check_path", "/")
    port                = lookup(each.value, "health_check_port", "traffic-port")
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 30
    matcher             = "200,403,404,400,401,301,302"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ALB rule

resource "aws_lb_listener_rule" "this" {
  for_each     = var.alb_target_groups
  listener_arn = var.create_alb && var.http_redirect == "no" ? one(aws_lb_listener.alb_http.*.arn) : one(aws_lb_listener.alb_https.*.arn)
  priority     = lookup(each.value, "priority", 1)
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb[each.key].arn
  }

  #dynamic "condition" {
  # for_each = [for condition_rule in each.value.conditions :
  #   condition_rule
  #   if length(lookup(condition_rule, "path_patterns", [])) > 0
  # ]

  condition {
    path_pattern {
      values = lookup(each.value, "path_patterns", [])
    }
  }
  lifecycle {
    ignore_changes = [action]
  }
  depends_on = [aws_lb_target_group.alb]
}

# For BG
resource "aws_lb_listener_rule" "bg" {
  for_each     = var.enable_bluegreen_deployments == "yes" ? var.alb_target_groups : {}
  listener_arn = var.create_alb && var.http_redirect == "no" ? one(aws_lb_listener.alb_http_bg.*.arn) : one(aws_lb_listener.alb_https_bg.*.arn)
  priority     = lookup(each.value, "priority", 1)
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_bg[each.key].arn
  }

  #dynamic "condition" {
  # for_each = [for condition_rule in each.value.conditions :
  #   condition_rule
  #   if length(lookup(condition_rule, "path_patterns", [])) > 0
  # ]

  condition {
    path_pattern {
      values = lookup(each.value, "path_patterns", [])
    }
  }
  lifecycle {
    ignore_changes = [action.0.target_group_arn]
  }
  depends_on = [aws_lb_target_group.alb_bg]

}


# Listener (redirects traffic from the load balancer to the target group)
resource "aws_lb_listener" "alb_http_redirect" {
  count             = var.create_alb && var.http_redirect == "yes" ? 1 : 0
  load_balancer_arn = aws_lb.alb[0].id
  port              = "80"
  protocol          = "HTTP"

  depends_on = [aws_lb_target_group.alb]

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb_http" {
  count             = var.create_alb && var.http_redirect == "no" ? 1 : 0
  load_balancer_arn = aws_lb.alb[0].id
  port              = "80"
  protocol          = "HTTP"

  depends_on = [aws_lb_target_group.alb]

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid Endpoint"
      status_code  = "200"
    }

  }
}

resource "aws_lb_listener" "alb_https" {
  count             = var.create_alb && var.certificate_arn != "" && var.http_redirect == "yes" ? 1 : 0
  load_balancer_arn = aws_lb.alb[0].id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.alb_ssl_policy
  certificate_arn   = var.certificate_arn
  depends_on        = [aws_lb_target_group.alb]

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid Endpoint"
      status_code  = "200"
    }

  }
}

resource "aws_lb_listener" "alb_http_bg" {
  count             = var.create_alb && var.http_redirect == "no" && var.certificate_arn == "" && var.enable_bluegreen_deployments == "yes" ? 1 : 0
  load_balancer_arn = aws_lb.alb[0].id
  port              = "8080"
  protocol          = "HTTP"

  depends_on = [aws_lb_target_group.alb_bg]

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid Endpoint"
      status_code  = "200"
    }

  }
}

resource "aws_lb_listener" "alb_https_bg" {
  count             = var.create_alb && var.certificate_arn != "" && var.http_redirect == "yes" && var.enable_bluegreen_deployments == "yes" ? 1 : 0
  load_balancer_arn = aws_lb.alb[0].id
  port              = "9443"
  protocol          = "HTTPS"
  ssl_policy        = var.alb_ssl_policy
  certificate_arn   = var.certificate_arn
  depends_on        = [aws_lb_target_group.alb_bg]

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid Endpoint"
      status_code  = "200"
    }

  }
}
