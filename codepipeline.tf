resource "aws_codepipeline" "this" {
  count    = var.enable_codepipeline ? 1 : 0
  name     = "${var.app_name}-pipeline-${var.pipeline_type}"
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
        FullRepositoryId     = "${var.github_repo_owner}/${var.github_repo_name}"
        BranchName           = var.github_repo_branch
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  #Build
  stage {
    name = "Build"

    dynamic "action" {
      for_each = var.build_environments

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

  dynamic "stage" {
    for_each = var.prodduction_approval ? [1] : [] # e.g. [] || [true]  
    content {
      name = "Approve"
      action {
        name     = "Production-Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"
      }
    }
  }

  stage {
    name = "Deploy"

    dynamic "action" {
      for_each = var.deploy_environments

      content {
        name            = action.key
        category        = "Deploy"
        owner           = "AWS"
        provider        = "ECS"
        version         = "1"
        input_artifacts = ["build-artifacts"]
        configuration = {
          ClusterName       = action.value.cluster_name
          ServiceName       = action.value.service_name
          FileName          = "imagedefinitions.json"
          DeploymentTimeout = "15"
        }

      }
    }
  }
}


