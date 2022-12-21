## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.47.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.ecs_scale_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.ecs_scale_memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.app_log_group_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.app_log_stream_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_codebuild_project.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codedeploy_app.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_codepipeline.pipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_ecr_repository.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.crossaccount](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_efs_access_point.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs_tgt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_iam_role.ecs_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_task_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ecs_task_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.alb_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.alb_http_redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.alb_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.alb_https_bg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.alb_bg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_service_discovery_private_dns_namespace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace) | resource |
| [aws_service_discovery_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [aws_iam_policy_document.ecs_task_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS Account ID | `string` | `""` | no |
| <a name="input_action_on_timeout"></a> [action\_on\_timeout](#input\_action\_on\_timeout) | action to be taken during timeout | `string` | `"STOP_DEPLOYMENT"` | no |
| <a name="input_alb_listener_rules"></a> [alb\_listener\_rules](#input\_alb\_listener\_rules) | map of listener rules | `any` | `{}` | no |
| <a name="input_alb_ssl_policy"></a> [alb\_ssl\_policy](#input\_alb\_ssl\_policy) | ALB SSL Policy for secure listener | `string` | `"ELBSecurityPolicy-TLS-1-2-Ext-2018-06"` | no |
| <a name="input_alb_target_groups"></a> [alb\_target\_groups](#input\_alb\_target\_groups) | map of target groups to be attached to alb | `any` | `{}` | no |
| <a name="input_app_count"></a> [app\_count](#input\_app\_count) | Global var for number of replicas | `number` | `1` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application Name | `string` | `""` | no |
| <a name="input_artifact_bucket_key"></a> [artifact\_bucket\_key](#input\_artifact\_bucket\_key) | KMS key associated with artifact bucket | `string` | `""` | no |
| <a name="input_build_environment_variables"></a> [build\_environment\_variables](#input\_build\_environment\_variables) | env vars for codebuild | `any` | `{}` | no |
| <a name="input_buildspec_file"></a> [buildspec\_file](#input\_buildspec\_file) | buildspec file for ecs | `string` | `""` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | acm cert arn for https alb listener | `string` | `""` | no |
| <a name="input_cicd_role"></a> [cicd\_role](#input\_cicd\_role) | iam role for cicd | `string` | `""` | no |
| <a name="input_codebuild_security_group"></a> [codebuild\_security\_group](#input\_codebuild\_security\_group) | codebuild security group | `string` | `""` | no |
| <a name="input_codestar_connection_arn"></a> [codestar\_connection\_arn](#input\_codestar\_connection\_arn) | codestar connection arn | `string` | `""` | no |
| <a name="input_compute_type"></a> [compute\_type](#input\_compute\_type) | codebuild compute type | `string` | `""` | no |
| <a name="input_container_env_vars"></a> [container\_env\_vars](#input\_container\_env\_vars) | n/a | `any` | `[]` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | global variable for container port | `number` | `null` | no |
| <a name="input_create_alb"></a> [create\_alb](#input\_create\_alb) | Load balancer variables | `bool` | `false` | no |
| <a name="input_deploy_environments"></a> [deploy\_environments](#input\_deploy\_environments) | deploy environments | `any` | `{}` | no |
| <a name="input_deployment_config_name"></a> [deployment\_config\_name](#input\_deployment\_config\_name) | CodeDeploy deployment config name | `string` | `"CodeDeployDefault.ECSAllAtOnce"` | no |
| <a name="input_ecr_account_id"></a> [ecr\_account\_id](#input\_ecr\_account\_id) | AWS Account ID where ECR repos are created | `string` | `""` | no |
| <a name="input_ecr_policy"></a> [ecr\_policy](#input\_ecr\_policy) | ECR policy | `any` | `{}` | no |
| <a name="input_ecs_applications"></a> [ecs\_applications](#input\_ecs\_applications) | ecs applications | `any` | `{}` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | Name of the ECS cluster | `string` | `"ecs-cluster"` | no |
| <a name="input_ecs_internal_services"></a> [ecs\_internal\_services](#input\_ecs\_internal\_services) | list of internal service discoveries | `any` | `[]` | no |
| <a name="input_ecs_services"></a> [ecs\_services](#input\_ecs\_services) | ecs services | `any` | `{}` | no |
| <a name="input_enable_bluegreen_deployments"></a> [enable\_bluegreen\_deployments](#input\_enable\_bluegreen\_deployments) | enable or disable BG deployments | `string` | `"no"` | no |
| <a name="input_enable_cicd"></a> [enable\_cicd](#input\_enable\_cicd) | enable or disable cicd pipeline | `string` | `"no"` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Whether or not to enable cross zone load balancing. Valid only for NLB | `bool` | `false` | no |
| <a name="input_enable_service_discovery"></a> [enable\_service\_discovery](#input\_enable\_service\_discovery) | whether or not to enable private service discovery | `string` | `"no"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment where the state backend will live. | `string` | `""` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Health check path for the default target group | `string` | `"/"` | no |
| <a name="input_health_check_port"></a> [health\_check\_port](#input\_health\_check\_port) | Health check port | `string` | `"traffic-port"` | no |
| <a name="input_health_check_protocol"></a> [health\_check\_protocol](#input\_health\_check\_protocol) | Health check protocol | `string` | `"TCP"` | no |
| <a name="input_http_redirect"></a> [http\_redirect](#input\_http\_redirect) | n/a | `string` | `""` | no |
| <a name="input_image"></a> [image](#input\_image) | codebuild image | `string` | `""` | no |
| <a name="input_is_internal"></a> [is\_internal](#input\_is\_internal) | n/a | `string` | `"no"` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | ECS Launch Type | `string` | `"FARGATE"` | no |
| <a name="input_lb_access_logs_prefix"></a> [lb\_access\_logs\_prefix](#input\_lb\_access\_logs\_prefix) | Load Balancer access logs prefix | `string` | `"ALB"` | no |
| <a name="input_lb_name"></a> [lb\_name](#input\_lb\_name) | Load Balancer Name | `string` | `""` | no |
| <a name="input_lb_subnets"></a> [lb\_subnets](#input\_lb\_subnets) | list of public subnets for alb | `list(any)` | `[]` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | CloudWatch Log Retention (in days) | `string` | `"3"` | no |
| <a name="input_logging_lb_bucket_name"></a> [logging\_lb\_bucket\_name](#input\_logging\_lb\_bucket\_name) | n/a | `string` | `""` | no |
| <a name="input_private_dns"></a> [private\_dns](#input\_private\_dns) | private dns for internal service discovery | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | project name for codebuild | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Amazon region to use for retrieving data (e.g us-east-1) | `string` | `""` | no |
| <a name="input_repo_branch"></a> [repo\_branch](#input\_repo\_branch) | repo branch | `string` | `""` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | repo name | `string` | `""` | no |
| <a name="input_repo_owner"></a> [repo\_owner](#input\_repo\_owner) | repo owner | `string` | `""` | no |
| <a name="input_s3_artifact_store"></a> [s3\_artifact\_store](#input\_s3\_artifact\_store) | s3 bucket to store pipeline artifacts | `string` | `""` | no |
| <a name="input_s3_build_logs_bucket"></a> [s3\_build\_logs\_bucket](#input\_s3\_build\_logs\_bucket) | build logs s3 bucket | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | list of subnets for EFS | `list(string)` | `[]` | no |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | Name of the Load Balancer Target Group | `string` | `""` | no |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | Port on which targets receive traffic | `number` | `3000` | no |
| <a name="input_target_group_protocol"></a> [target\_group\_protocol](#input\_target\_group\_protocol) | Protocol to use for routing traffic to the targets. | `string` | `"HTTP"` | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Type of target to register targets with target group. Valid values are `instance` or `ip`. | `string` | `"ip"` | no |
| <a name="input_task_definitions"></a> [task\_definitions](#input\_task\_definitions) | ecs task definitions | `any` | `{}` | no |
| <a name="input_termination_wait_time_in_minutes"></a> [termination\_wait\_time\_in\_minutes](#input\_termination\_wait\_time\_in\_minutes) | The number of minutes to wait after a successful blue/green deployment before terminating instances from the original environment | `number` | `5` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc id | `string` | `""` | no |
| <a name="input_wait_time_in_minutes"></a> [wait\_time\_in\_minutes](#input\_wait\_time\_in\_minutes) | The number of minutes to wait before the status of a blue/green deployment changed to Stopped if rerouting is not started manually. | `number` | `20` | no |

## Outputs

No outputs.
