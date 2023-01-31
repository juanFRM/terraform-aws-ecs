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
    action {
      name     = "Build-Image"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"
      #role_arn         = action.key != "dev" ? action.value["role_arn"] : null
      input_artifacts  = ["source"]
      output_artifacts = ["build"]
      configuration = {
        ProjectName = aws_codebuild_project.this[each.key].name
      }
    }
  }

  # Deploy

  dynamic "stage" {
    for_each = {
      for k, v in var.deploy_environments : format("%.4d", k) => v
    }
    content {
      name = title("${stage.value.env_name}")
      dynamic "action" {
        for_each = "${stage.value.env_name}" != "dev" ? [1] : []
        content {
          name     = "${stage.value.env_name}-approval"
          category = "Approval"
          owner    = "AWS"
          provider = "Manual"
          version  = "1"

        }
      }
      action {
        name            = "${stage.value.env_name}-deploy"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "${each.value.attach_alb}" != "yes" ? "ECS" : "CodeDeployToECS"
        version         = "1"
        input_artifacts = ["build"]
        run_order       = "${stage.value.env_name}" == "dev" ? 1 : 2
        role_arn        = stage.value.env_name != "dev" ? stage.value["role_arn"] : null
        configuration = "${each.value.attach_alb}" != "yes" ? {
          ClusterName       = var.ecs_cluster_name
          ServiceName       = "${each.value.name}-service"
          FileName          = "imagedefinitions.json"
          DeploymentTimeout = "15"
          } : {
          ApplicationName                = var.app_name
          DeploymentGroupName            = "${each.value.name}-dg"
          TaskDefinitionTemplateArtifact = "build"
          TaskDefinitionTemplatePath     = "taskdef.json"
          AppSpecTemplateArtifact        = "build"
          AppSpecTemplatePath            = "appspec.yaml"
        }

      }

    }
  }

}


