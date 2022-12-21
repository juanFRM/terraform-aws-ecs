variable "app_name" {
  description = "Application Name"
  type        = string
  default     = ""
}

variable "app_count" {
  description = "Global var for number of replicas"
  type        = number
  default     = 1
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
  default     = ""
}

variable "ecr_account_id" {
  description = "AWS Account ID where ECR repos are created"
  type        = string
  default     = ""
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
  default     = "ecs-cluster"
}

variable "log_retention_in_days" {
  description = "CloudWatch Log Retention (in days)"
  type        = string
  default     = "3"

}

variable "vpc_id" {
  description = "vpc id"
  type        = string
  default     = ""
}

variable "subnets" {
  description = "list of subnets for EFS"
  type        = list(string)
  default     = []
}

variable "region" {
  type        = string
  default     = ""
  description = "Amazon region to use for retrieving data (e.g us-east-1)"
}

variable "environment" {
  type        = string
  default     = ""
  description = "The environment where the state backend will live."
}


variable "launch_type" {
  description = "ECS Launch Type"
  type        = string
  default     = "FARGATE"
}


variable "enable_service_discovery" {
  type        = string
  default     = "no"
  description = "whether or not to enable private service discovery"
}

variable "ecs_internal_services" {
  type        = any
  default     = []
  description = "list of internal service discoveries"
}

variable "private_dns" {
  type        = string
  default     = ""
  description = "private dns for internal service discovery"
}

variable "task_definitions" {
  type        = any
  default     = {}
  description = "ecs task definitions"
}

variable "ecs_services" {
  type        = any
  default     = {}
  description = "ecs services"
}

variable "ecs_applications" {
  type        = any
  default     = {}
  description = "ecs applications"
}

variable "ecr_policy" {
  type        = any
  default     = {}
  description = "ECR policy"
}

variable "container_env_vars" {
  type    = any
  default = []
}

variable "container_port" {
  type        = number
  default     = null
  description = "global variable for container port"
}


# Load balancer variables
variable "create_alb" {
  type    = bool
  default = false
}

variable "is_internal" {
  type    = string
  default = "no"
}

variable "lb_subnets" {
  type        = list(any)
  default     = []
  description = "list of public subnets for alb"
}

variable "logging_lb_bucket_name" {
  type    = string
  default = ""
}

variable "certificate_arn" {
  type        = string
  default     = ""
  description = "acm cert arn for https alb listener"
}

variable "http_redirect" {
  type    = string
  default = ""
}

variable "lb_name" {
  type        = string
  description = "Load Balancer Name"
  default     = ""

}

variable "target_group_name" {
  type        = string
  description = "Name of the Load Balancer Target Group"
  default     = ""

}

variable "alb_ssl_policy" {
  type        = string
  description = "ALB SSL Policy for secure listener"
  default     = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}

variable "health_check_path" {
  description = "Health check path for the default target group"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Health check port"
  type        = string
  default     = "traffic-port"
}

variable "health_check_protocol" {
  description = "Health check protocol"
  type        = string
  default     = "TCP"

}

variable "enable_cross_zone_load_balancing" {
  description = "Whether or not to enable cross zone load balancing. Valid only for NLB"
  type        = bool
  default     = false
}

variable "target_group_protocol" {
  description = "Protocol to use for routing traffic to the targets."
  type        = string
  default     = "HTTP"
}

variable "target_group_port" {
  description = "Port on which targets receive traffic"
  type        = number
  default     = 3000
}

variable "target_type" {
  description = "Type of target to register targets with target group. Valid values are `instance` or `ip`."
  type        = string
  default     = "ip"
}

variable "alb_target_groups" {
  type        = any
  description = "map of target groups to be attached to alb"
  default     = {}
}

variable "alb_listener_rules" {
  type        = any
  description = "map of listener rules"
  default     = {}
}
variable "lb_access_logs_prefix" {
  description = "Load Balancer access logs prefix"
  type        = string
  default     = "ALB"

}

# CodePipeline

variable "enable_cicd" {
  type        = string
  default     = "no"
  description = "enable or disable cicd pipeline"
}

variable "project_name" {
  type        = string
  description = "project name for codebuild"
  default     = ""

}

variable "cicd_role" {
  type        = string
  default     = ""
  description = "iam role for cicd"
}

variable "compute_type" {
  type        = string
  default     = ""
  description = "codebuild compute type"
}

variable "image" {
  type        = string
  default     = ""
  description = "codebuild image"
}

variable "build_environment_variables" {
  type        = any
  default     = {}
  description = "env vars for codebuild"
}

variable "s3_build_logs_bucket" {
  type        = string
  default     = ""
  description = "build logs s3 bucket"
}

variable "buildspec_file" {
  type        = string
  default     = ""
  description = "buildspec file for ecs"
}

locals {
  common_tags = {
    environment = var.environment
  }
}