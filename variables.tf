variable "app_name" {
  description = "Application Name"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string

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
}

variable "subnets" {
  description = "list of subnets for EFS"
  type        = list(string)
}

variable "region" {
  type        = string
  description = "Amazon region to use for retrieving data (e.g us-east-1)"
}

variable "environment" {
  type        = string
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

variable "cicd_role" {
  type        = string
  default     = ""
  description = "CICD role for CodePipeline"
}

variable "s3_artifact_store" {
  type        = string
  default     = ""
  description = "S3 bucket to store artifacts"
}

variable "artifact_bucket_key" {
  type        = string
  default     = ""
  description = "KMS Key ID associated with artifacts bucket"
}

variable "codestar_connection_arn" {
  type        = string
  default     = ""
  description = "CodeStar Connection ARN to connect with GitHub"
}

variable "github_repo_owner" {
  type        = string
  default     = ""
  description = "GitHub repo org owner"
}

variable "github_repo_name" {
  type        = string
  default     = ""
  description = "GitHub repo name"
}

variable "github_repo_branch" {
  type        = string
  default     = ""
  description = "GitHub branch name"
}

variable "build_environments" {
  type        = any
  description = "Build environments"
  default     = []
}

variable "prodduction_approval" {
  type        = bool
  default     = false
  description = "Whether or not to enable prod approvals before deployments"
}

variable "deploy_environments" {
  type        = any
  default     = []
  description = "Deploy environments"
}

variable "pipeline_type" {
  type        = string
  default     = "ecs"
  description = "Pipeline type identifier"
}

variable "enable_codepipeline" {
  type        = bool
  default     = false
  description = "Enable or disable CodePipeline"
}