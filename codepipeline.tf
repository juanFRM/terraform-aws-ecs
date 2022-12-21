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
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["build-artifacts"]
      configuration = {
        ProjectName = aws_codebuild_project.this[each.key].name
      }
    }

  }

  # Deploy

  dynamic "stage" {
    for_each = {
      for k, v in var.deploy_environments : k => v
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
      for k, v in var.deploy_environments : k => v
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
      for k, v in var.deploy_environments : k => v
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
      for k, v in var.deploy_environments : k => v
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
      for k, v in var.deploy_environments : k => v
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


