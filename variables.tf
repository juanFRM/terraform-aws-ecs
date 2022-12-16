variable "app_name" {
  description = "Application Name"
  type        = string
  default     = ""
}

variable "account_id" {
  description = "AWS Account ID"
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

variable "container_env_vars" {
  type    = any
  default = []
}

