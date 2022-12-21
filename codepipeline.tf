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
        FullRepositoryId     = "${var.repo_owner}/${var.repo_name}"
        BranchName           = var.repo_branch
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  #Build
  stage {
    name = "Build"

    dynamic "action" {
      for_each = var.codepipeline_build_environments

      content {
        name             = action.key
        category         = "Build"
        owner            = "AWS"
        provider         = "CodeBuild"
        version          = "1"
        input_artifacts  = ["source"]
        output_artifacts = ["build-artifacts"]

        role_arn = action.key != "dev" ? action.value["crossaccount_role"] : null
        configuration = {
          ProjectName = action.value["codebuild_project"]
        }
      }
    }
  }

  # Deploy

  dynamic "stage" {
    for_each = {
      for k, v in var.codepipeline_deploy_environments : k => v
      if k == "dev"
    }
    content {
      name = "Deploy-Dev"
      action {
        name            = "deploy-${stage.key}"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "ECS"
        version         = "1"
        input_artifacts = ["build-artifacts"]
        configuration = {
          ClusterName       = var.ecs_cluster_name
          ServiceName       = each.value.name
          FileName          = "imagedefinitions.json"
          DeploymentTimeout = "15"
        }
      }
    }
  }

  dynamic "stage" {
    for_each = {
      for k, v in var.codepipeline_deploy_environments : k => v
      if k == "test"
    }
    content {
      name = "Approve"
      action {
        name     = "Stage-Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"
      }
    }
  }

  dynamic "stage" {
    for_each = {
      for k, v in var.codepipeline_deploy_environments : k => v
      if k == "test"
    }
    content {
      name = "Deploy-Test"
      action {
        name            = "deploy-${stage.key}"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "ECS"
        version         = "1"
        input_artifacts = ["build-artifacts"]
        configuration = {
          ClusterName       = var.ecs_cluster_name
          ServiceName       = each.value.name
          FileName          = "imagedefinitions.json"
          DeploymentTimeout = "15"
        }
      }
    }
  }

  dynamic "stage" {
    for_each = {
      for k, v in var.codepipeline_deploy_environments : k => v
      if k == "prod"
    }
    content {
      name = "Approve"
      action {
        name     = "Prod-Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"
      }
    }
  }

  dynamic "stage" {
    for_each = {
      for k, v in var.codepipeline_deploy_environments : k => v
      if k == "prod"
    }
    content {
      name = "Deploy-Prod"
      action {
        name            = "deploy-${stage.key}"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "ECS"
        version         = "1"
        input_artifacts = ["build-artifacts"]
        configuration = {
          ClusterName       = var.ecs_cluster_name
          ServiceName       = each.value.name
          FileName          = "imagedefinitions.json"
          DeploymentTimeout = "15"
        }
      }
    }
  }


}


