// Delivery Pipeline

resource "aws_codepipeline" "deliver" {
  name     = "${module.env.environment}-${module.env.project}-${var.role}-deliver-cp"
  role_arn = "${data.terraform_remote_state.common.codepipeline_role_arn}"

  artifact_store {
    location = "${module.env.project_full_name}-codepipeline"
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
        OAuthToken           = "92c48a800ad929be3197620c879ef82169cc52fc"
        Owner                = "sardegnaturismo"
        Repo                 = "DO_shiny"
        Branch               = "master"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["default"]
      output_artifacts = ["defaultbuilt"]
      version          = "1"

      configuration {
        ProjectName = "${module.env.environment}-${module.env.project}-${var.role}-builder-cb"
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
      name            = "${module.env.environment}-${module.env.project}-${var.role}"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["defaultbuilt"]
      version         = "1"

      configuration {
        ClusterName = "${module.env.environment}-${var.cluster}"
        ServiceName = "${module.env.environment}-${module.env.project}-main-srv"
        FileName    = "imagedefinitions.json"
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
  #     UserParameters = "{   \"cluster\": \"${module.env.environment}-${var.cluster}\",\"service_name\": \"${module.env.environment}-${module.env.project}-main-srv\" }"
  #   }
  #  }
  # }
}

# // CodeDeploy
# resource "aws_codedeploy_app" "deliver" {
#   name = "${module.env.environment}-${module.env.project}-${var.role}"
# }

# resource "aws_codedeploy_deployment_group" "deliver" {
#   app_name               = "${aws_codedeploy_app.deliver.name}"
#   deployment_group_name  = "${module.env.environment}-${module.env.project}-${var.role}-dg"
#   service_role_arn       = "${data.terraform_remote_state.common.codedeploy_role_arn}"
#   autoscaling_groups     = ["${module.asg.asg_id}"]
#   deployment_config_name = "${module.env.deployment_configuration}"

#   auto_rollback_configuration {
#     enabled = false
#     events  = ["DEPLOYMENT_FAILURE"]
#   }

#   trigger_configuration {
#     trigger_events     = ["DeploymentFailure", "DeploymentStart", "DeploymentSuccess", "DeploymentStop", "DeploymentRollback", "InstanceStart", "InstanceSuccess", "InstanceFailure"]
#     trigger_name       = "${module.env.environment}-${module.env.project}-${var.role}"
#     trigger_target_arn = "${data.terraform_remote_state.common.codedeploy_sns_arn}"
#   }
# }

# resource "aws_iam_role_policy" "codepipeline" {
#   name = "${module.env.environment}_${module.env.project_full_name}_${var.role}codepipeline_policy"
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
#               "arn:aws:s3:::${module.env.project_full_name}-codepipeline*"

#         ]

#     },
#     {
#         "Action": [
#             "s3:PutObject"
#         ],
#         "Resource": [
#               "arn:aws:s3:::${module.env.project_full_name}-codepipeline*"
#         ],
#         "Effect": "Allow"
#     }   
#   ]
# }
# EOF
# }

# resource "aws_codebuild_project" "default" {
#   name          = "${module.env.environment}-${module.env.project}-${var.role}-builder-cb"
#   description   = "Codebuild project for ${module.env.environment} ${module.env.project}"
#   build_timeout = "50"
#   service_role  = "${data.terraform_remote_state.continous.codebuild_role_name}"

#   artifacts {
#     type     = "S3"
#     location = "${module.env.project_full_name}-codepipeline"
#     path     = "${module.env.environment}-build/${var.role}"
#     name     = "${module.env.environment}-${var.role}"
#   }

#   environment {
#     compute_type = "BUILD_GENERAL1_SMALL"
#     image        = "aws/codebuild/docker:17.09.0"
#     type         = "LINUX_CONTAINER"
#     privileged_mode = true
#     environment_variable {
#       "name"  = "ENV_SELECTOR"
#       "value" = "${module.env.environment}"
#     }

#     environment_variable {
#       "name"  = "AWS_DEFAULT_REGION"
#       "value" = "${module.env.region}"
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
#     "Environment" = "${module.env.environment}"
#     "Project"     = "${module.env.project}"
#   }
# }

resource "aws_codebuild_project" "default" {
  name          = "${module.env.environment}-${module.env.project}-${var.role}-builder-cb"
  description   = "Codebuild project for ${module.env.environment} ${module.env.project}"
  build_timeout = "50"
  service_role  = "${data.terraform_remote_state.continous.codebuild_role_name}"

  # artifacts {
  #   type     = "S3"
  #   location = "${module.env.project_full_name}-codepipeline"
  #   path     = "${module.env.environment}-build/${var.role}"
  #   name     = "${module.env.environment}-${var.role}"
  # }
  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/docker:17.09.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      "name"  = "ENV_SELECTOR"
      "value" = "${module.env.environment}"
    }

    environment_variable {
      "name"  = "AWS_DEFAULT_REGION"
      "value" = "${module.env.region}"
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
  #     resource = "${module.env.github_oauth_token}"
  #   }
  # }
  source {
    buildspec = "buildspec.yml"
    type      = "CODEPIPELINE"
  }

  tags {
    "Environment" = "${module.env.environment}"
    "Project"     = "${module.env.project}"
  }
}

# data.template_file.codebuild_source_location.rendered
data "template_file" "codebuild_source_location" {
  template = "https://github.com/$${owner}/$${repository}.git"

  vars {
    owner      = "sardegnaturismo"
    repository = "DO_shiny"
  }
}
