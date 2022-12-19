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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | github.com/revstarconsulting/terraform-aws-load-balancer | v1.3.7 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.app_log_group_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.app_log_stream_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
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
| [aws_security_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_service_discovery_private_dns_namespace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace) | resource |
| [aws_service_discovery_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [aws_iam_policy_document.ecs_task_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS Account ID | `string` | `""` | no |
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | acm cert arn for https alb listener | `string` | `""` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application Name | `string` | `""` | no |
| <a name="input_container_env_vars"></a> [container\_env\_vars](#input\_container\_env\_vars) | n/a | `any` | `[]` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | global variable for container port | `number` | `null` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | Name of the ECS cluster | `string` | `"ecs-cluster"` | no |
| <a name="input_ecs_internal_services"></a> [ecs\_internal\_services](#input\_ecs\_internal\_services) | list of internal service discoveries | `any` | `[]` | no |
| <a name="input_ecs_services"></a> [ecs\_services](#input\_ecs\_services) | ecs services | `any` | `{}` | no |
| <a name="input_enable_load_balancer"></a> [enable\_load\_balancer](#input\_enable\_load\_balancer) | Load balancer variables | `string` | `"no"` | no |
| <a name="input_enable_service_discovery"></a> [enable\_service\_discovery](#input\_enable\_service\_discovery) | whether or not to enable private service discovery | `string` | `"no"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment where the state backend will live. | `string` | `""` | no |
| <a name="input_http_redirect"></a> [http\_redirect](#input\_http\_redirect) | n/a | `string` | `""` | no |
| <a name="input_internal_load_balancer"></a> [internal\_load\_balancer](#input\_internal\_load\_balancer) | n/a | `string` | `"no"` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | ECS Launch Type | `string` | `"FARGATE"` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | CloudWatch Log Retention (in days) | `string` | `"3"` | no |
| <a name="input_logging_bucket_name"></a> [logging\_bucket\_name](#input\_logging\_bucket\_name) | n/a | `string` | `""` | no |
| <a name="input_private_dns"></a> [private\_dns](#input\_private\_dns) | private dns for internal service discovery | `string` | `""` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | list of public subnets for alb | `list(any)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | Amazon region to use for retrieving data (e.g us-east-1) | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | list of subnets for EFS | `list(string)` | `[]` | no |
| <a name="input_task_definitions"></a> [task\_definitions](#input\_task\_definitions) | ecs task definitions | `any` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc id | `string` | `""` | no |

## Outputs

No outputs.
