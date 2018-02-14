resource "aws_ecr_repository" "default" {
  name = "${var.environment}-${var.project}"
}

# arn - Full ARN of the repository.
# name - The name of the repository.
# registry_id - The registry ID where the repository was created.
# repository_url - The URL of the repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName
# »

resource "aws_ecr_lifecycle_policy" "default" {
  repository = "${aws_ecr_repository.default.name}"

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
