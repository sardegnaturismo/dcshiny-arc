

// Delivery Pipeline

resource "aws_codepipeline" "deliver" {
  name     = "${var.environment}-${var.project}-${var.role}-deliver-cp"
  role_arn = "${data.terraform_remote_state.common.codepipeline_role_arn}"

  artifact_store {
    location = "${var.project_full_name}-codepipeline"
    type     = "S3"
  }

  stage {
    name = "Source"

  #   action {
  #     name             = "Source"
  #     category         = "Source"
  #     owner            = "AWS"
  #     provider         = "CodeCommit"
  #     version          = "1"
  #     output_artifacts = ["default"]
  #   configuration {
  #       PollForSourceChanges      = true
  #       RepositoryName       = "shinydash"
  #       BranchName     = "master"
  #     }
   action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["default"]

      configuration {
        OAuthToken           = "${var.github_oauth_token}"
        Owner                = "${var.github_owner}"
        Repo                 = "${var.github_repository}"
        Branch               = "${var.github_branch}"
        PollForSourceChanges = "${var.poll_for_source_changes}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["default"]
      output_artifacts = ["defaultbuilt"]
      version         = "1"

      configuration {
        ProjectName = "${var.environment}-${var.project}-${var.role}-builder-cb"
      }
    }
  }
  # stage {
  #   name = "Approval"


  #   action {
  #     name             = "Approval"
  #     category         = "Approval"
  #     owner            = "AWS"
  #     provider         = "Manual"
  #     version          = "1"
  #    configuration {
  #      NotificationArn = "${data.terraform_remote_state.common.codedeploy_sns_arn}"
  #      ExternalEntityLink = "http://example.com"
  #      CustomData = " Click to start deploy " 
  #    }
  #   }

  stage {
    name = "Deploy"

    action {
      name            = "${var.environment}-${var.project}-${var.role}"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["defaultbuilt"]
      version         = "1"

      configuration {
ClusterName = "${var.environment}-${var.cluster}"
ServiceName = "${var.environment}-${var.project}-main-srv"
FileName = "imagedefinitions.json"
      }
    }
  }
    # stage {
    # name = "Restart"
    #  action {
    #    name = "Call_Lambda"
    #   category        = "Invoke"
    #   owner           = "AWS"
    #   provider        = "Lambda"
    #   version         = "1"
    # configuration {
    #     FunctionName   = "ecs-service-restarter"
    #     UserParameters = "{   \"cluster\": \"${var.environment}-${var.cluster}\",\"service_name\": \"${var.environment}-${var.project}-main-srv\" }"
    #   }
    #  }
    # }
}

# // CodeDeploy
# resource "aws_codedeploy_app" "deliver" {
#   name = "${var.environment}-${var.project}-${var.role}"
# }

# resource "aws_codedeploy_deployment_group" "deliver" {
#   app_name               = "${aws_codedeploy_app.deliver.name}"
#   deployment_group_name  = "${var.environment}-${var.project}-${var.role}-dg"
#   service_role_arn       = "${data.terraform_remote_state.common.codedeploy_role_arn}"
#   autoscaling_groups     = ["${module.asg.asg_id}"]
#   deployment_config_name = "${var.deployment_configuration}"

#   auto_rollback_configuration {
#     enabled = false
#     events  = ["DEPLOYMENT_FAILURE"]
#   }

#   trigger_configuration {
#     trigger_events     = ["DeploymentFailure", "DeploymentStart", "DeploymentSuccess", "DeploymentStop", "DeploymentRollback", "InstanceStart", "InstanceSuccess", "InstanceFailure"]
#     trigger_name       = "${var.environment}-${var.project}-${var.role}"
#     trigger_target_arn = "${data.terraform_remote_state.common.codedeploy_sns_arn}"
#   }
# }

# resource "aws_iam_role_policy" "codepipeline" {
#   name = "${var.environment}_${var.project_full_name}_${var.role}codepipeline_policy"
#   role = "${module.asg.asg_role_name}"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect":"Allow",
#       "Action": [
#         "s3:GetObject",
#         "s3:GetObjectVersion",
#         "s3:GetBucketVersioning"
#       ],
#       "Resource": [
#               "arn:aws:s3:::${var.project_full_name}-codepipeline*"
              
#         ]
      
#     },
#     {
#         "Action": [
#             "s3:PutObject"
#         ],
#         "Resource": [
#               "arn:aws:s3:::${var.project_full_name}-codepipeline*"
#         ],
#         "Effect": "Allow"
#     }   
#   ]
# }
# EOF
# }


# resource "aws_codebuild_project" "default" {
#   name          = "${var.environment}-${var.project}-${var.role}-builder-cb"
#   description   = "Codebuild project for ${var.environment} ${var.project}"
#   build_timeout = "50"
#   service_role  = "${data.terraform_remote_state.continous.codebuild_role_name}"

#   artifacts {
#     type     = "S3"
#     location = "${var.project_full_name}-codepipeline"
#     path     = "${var.environment}-build/${var.role}"
#     name     = "${var.environment}-${var.role}"
#   }

#   environment {
#     compute_type = "BUILD_GENERAL1_SMALL"
#     image        = "aws/codebuild/docker:17.09.0"
#     type         = "LINUX_CONTAINER"
#     privileged_mode = true
#     environment_variable {
#       "name"  = "ENV_SELECTOR"
#       "value" = "${var.environment}"
#     }

#     environment_variable {
#       "name"  = "AWS_DEFAULT_REGION"
#       "value" = "${var.region}"
#     }
#     environment_variable {
#       "name"  = "REPOSITORY_URI"
#       "value" = "${aws_ecr_repository.default.repository_url}"
#     }
#       environment_variable {
#       "name"  = "CONTAINER_NAME"
#       "value" = "shiny-server"
#     }
#   }

#   source {
#     type     = "CODECOMMIT"
#     buildspec = "buildspec.yml"
#     location = "arn:aws:codecommit:eu-west-1:064484720015:shinydash"
#     # configuration {
#     #     PollForSourceChanges      = true
#     #     RepositoryName       = "shinydash"
#     #     BranchName     = "master"
#     #   }
#     }

  

#   tags {
#     "Environment" = "${var.environment}"
#     "Project"     = "${var.project}"
#   }
# }


resource "aws_codebuild_project" "default" {
  name          = "${var.environment}-${var.project}-${var.role}-builder-cb"
  description   = "Codebuild project for ${var.environment} ${var.project}"
  build_timeout = "50"
  service_role  = "${data.terraform_remote_state.continous.codebuild_role_name}"

  # artifacts {
  #   type     = "S3"
  #   location = "${var.project_full_name}-codepipeline"
  #   path     = "${var.environment}-build/${var.role}"
  #   name     = "${var.environment}-${var.role}"
  # }
 artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/docker:17.09.0"
    type         = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      "name"  = "ENV_SELECTOR"
      "value" = "${var.environment}"
    }

    environment_variable {
      "name"  = "AWS_DEFAULT_REGION"
      "value" = "${var.region}"
    }
    environment_variable {
      "name"  = "REPOSITORY_URI"
      "value" = "${aws_ecr_repository.default.repository_url}"
    }
      environment_variable {
      "name"  = "CONTAINER_NAME"
      "value" = "shiny-server"
    }
  }


  # source {
  #   type     = "GITHUB"
  #   buildspec = "buildspec.yml"
  #   location = "${data.template_file.codebuild_source_location.rendered}"
  #   auth {
  #     type     = "OAUTH"
  #     resource = "${var.github_oauth_token}"
  #   }
  # }
  source {
    buildspec = "buildspec.yml"
    type      = "CODEPIPELINE"
  }

  

  tags {
    "Environment" = "${var.environment}"
    "Project"     = "${var.project}"
  }
}


# data.template_file.codebuild_source_location.rendered
data "template_file" "codebuild_source_location" {
  template = "https://github.com/$${owner}/$${repository}.git"

  vars {
    owner      = "${var.github_owner}"
    repository = "${var.github_repository}"
  }
}