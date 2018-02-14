############################# OUTPUTS START
output "codepipeline_role_arn" {
  value = "${aws_iam_role.codepipeline.arn}"
}

############################# OUTPUTS END

resource "aws_iam_role" "codepipeline" {
  name = "${var.environment}-${var.project_full_name}-codepipeline"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline" {
  name = "${var.environment}_${var.project_full_name}_codepipeline_policy"
  role = "${aws_iam_role.codepipeline.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning"
      ],
      "Resource": [
              "arn:aws:s3:::${var.project_full_name}-codepipeline*",
              "arn:aws:s3:::${var.project_full_name}-releases*"
              
        ]
      
    },
    {
        "Action": [
            "s3:PutObject"
        ],
        "Resource": [
              "arn:aws:s3:::${var.project_full_name}-codepipeline*",
              "arn:aws:s3:::${var.project_full_name}-releases*"
        ],
        "Effect": "Allow"
    },
    {
        "Action": [
            "codecommit:CancelUploadArchive",
            "codecommit:GetBranch",
            "codecommit:GetCommit",
            "codecommit:GetUploadArchiveStatus",
            "codecommit:UploadArchive"
        ],
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": [
            "codedeploy:CreateDeployment",
            "codedeploy:GetApplicationRevision",
            "codedeploy:GetDeployment",
            "codedeploy:GetDeploymentConfig",
            "codedeploy:RegisterApplicationRevision"
        ],
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": [
            "lambda:InvokeFunction",
            "lambda:ListFunctions"
        ],
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": [
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild"
        ],
        "Resource": "*",
        "Effect": "Allow"
    },
    {
        "Action": [
            "ecs:DescribeServices",
            "ecs:DescribeTaskDefinition",
            "ecs:DescribeTasks",
            "ecs:ListTasks",
            "ecs:RegisterTaskDefinition",
            "ecs:UpdateService"
        ],
        "Resource": "*",
        "Effect": "Allow"        
    }
  ]
}
EOF
}
