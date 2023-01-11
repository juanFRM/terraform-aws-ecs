resource "aws_codepipeline" "pipeline" {
  for_each = var.environment == "dev" && var.enable_cicd == "yes" ? var.ecs_applications : {}
  name     = "${var.project_name}-${each.value.name}-pipeline"
  role_arn = var.cicd_role

  artifact_store {
    location = var.s3_artifact_store
    type     = "S3"
    encryption_key {
      id   = var.artifact_bucket_key
      type = "KMS"
    }
  }

  stage {
    name = "CodeCheckout"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        ConnectionArn        = var.codestar_connection_arn
        FullRepositoryId     = "${var.repo_owner}/${lookup(each.value, "repo_name", var.repo_name)}"
        BranchName           = lookup(each.value, "repo_branch", var.repo_branch)
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  #Build
  stage {
    name = "Build"
    dynamic "action" {
      for_each = var.deploy_environments
      content {
        name             = action.key
        category         = "Build"
        owner            = "AWS"
        provider         = "CodeBuild"
        version          = "1"
        role_arn         = action.key != "dev" ? action.value["role_arn"] : null
        input_artifacts  = ["source"]
        output_artifacts = ["build-${action.key}"]
        configuration = {
          ProjectName = aws_codebuild_project.this[each.key].name
        }
      }
    }


  }

  # Deploy

  dynamic "stage" {
    for_each = {
      for k, v in var.deploy_environments : k => v
      if each.value.enable_service == "yes"
    }
    content {
      name = title("${stage.key}-deploy")
      dynamic "action" {
        for_each = "${stage.key}" != "dev" ? [1] : []
        content {
          name     = "${stage.key}-approval"
          category = "Approval"
          owner    = "AWS"
          provider = "Manual"
          version  = "1"

        }
      }
      action {
        name            = "${stage.key}-deploy"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "${each.value.attach_alb}" != "yes" ? "ECS" : "CodeDeployToECS"
        version         = "1"
        input_artifacts = ["build-${stage.key}"]
        run_order       = "${stage.key}" == "dev" ? 1 : 2
        role_arn        = stage.key != "dev" ? stage.value["role_arn"] : null
        configuration = "${each.value.attach_alb}" != "yes" ? {
          ClusterName       = var.ecs_cluster_name
          ServiceName       = "${each.value.name}-service"
          FileName          = "imagedefinitions.json"
          DeploymentTimeout = "15"
          } : {
          ApplicationName                = var.app_name
          DeploymentGroupName            = "${each.value.name}-dg"
          TaskDefinitionTemplateArtifact = "build-${stage.key}"
          TaskDefinitionTemplatePath     = "taskdef.json"
          AppSpecTemplateArtifact        = "build-${stage.key}"
          AppSpecTemplatePath            = "appspec.yaml"
        }

      }

    }
  }

}


