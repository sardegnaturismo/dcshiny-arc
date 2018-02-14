# https://aws.amazon.com/it/blogs/compute/better-together-amazon-ecs-and-aws-lambda/

output "worker_td_revision" {
  value = "${aws_ecs_task_definition.worker.revision}"
}

output "worker_td_arn" {
  value = "${aws_ecs_task_definition.worker.arn}"
}

output "worker_td_family" {
  value = "${aws_ecs_task_definition.worker.family}"
}

resource "aws_ecs_task_definition" "worker" {
  depends_on = ["aws_sqs_queue.worker"]
  family     = "${var.environment}-${var.project}-worker-td"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 128,
    "essential": true,
    "image": "${aws_ecr_repository.default.repository_url}:worker",
    "memory": 128,
    "memoryReservation": 64,
    "name": "worker",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.environment}-${var.project}-worker",
          "awslogs-region": "${var.region}"
        }
    },
    "mountPoints": [
        {
          "containerPath": "/data/",
          "sourceVolume": "shared",
          "readOnly": false
        }
    ],
    "environment": [
        {
          "name": "AWS_REGION",
          "value": "${var.region}"
        },
        {
          "name": "SQS_QUEUE_URL",
          "value": "${aws_sqs_queue.worker.id}"
        },
        {
          "name": "SHORT_POLLING",
          "value": "20"
        },
        {
          "name": "LONG_POLLING",
          "value": "900"
        },
        {
          "name": "CONTAINER_DEST_PATH",
          "value": "/data/"
        }
      ],
      "taskRoleArn": "${aws_iam_role.worker.arn}"
  }
]
DEFINITION

  volume {
    name      = "shared"
    host_path = "/efs/data"
  }
}

resource "aws_cloudwatch_log_group" "worker" {
  name = "${var.environment}-${var.project}-worker"

  tags {
    Environment = "${var.environment}"
    Cluster     = "${var.cluster}"
  }
}

resource "aws_iam_role" "worker" {
  name = "${var.environment}-${var.project}-worker"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

// Inline Policy to use packer on codebuild 
resource "aws_iam_role_policy" "S3-ReadOnlyAccess" {
  name = "S3-ReadOnlyAccess"
  role = "${aws_iam_role.worker.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": "*"
        }
    ]
}
 POLICY
}

// Inline Policy to use packer on codebuild 
resource "aws_iam_role_policy" "SQS" {
  name = "SQS-ConsumerAccess"
  role = "${aws_iam_role.worker.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sqs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
 POLICY
}

resource "aws_sqs_queue" "worker" {
  name = "${var.environment}-${var.project}-worker"

  # delay_seconds = 0

  #   max_message_size          = 2048
  #   message_retention_seconds = 86400
  # receive_wait_time_seconds = 0

  #   redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.terraform_queue_deadletter.arn}\",\"maxReceiveCount\":4}"
}

resource "aws_sqs_queue_policy" "worker" {
  queue_url = "${aws_sqs_queue.worker.id}"

  policy = <<POLICY
{
 "Version": "2008-10-17",
 "Id": "arn:aws:sqs:eu-west-1:064484720015:prod-shinydash-worker/SQSDefaultPolicy",
 "Statement": [
  {
   "Sid": "example-statement-ID",
   "Effect": "Allow",
   "Principal": {
    "AWS":"*"  
   },
   "Action": [
    "SQS:SendMessage"
   ],
   "Resource": "${aws_sqs_queue.worker.arn}",
   "Condition": {
      "ArnLike": {          
      "aws:SourceArn": "arn:aws:s3:*:*:datalake.sardegnaturismocloud.it"    
    }
   }
  }
 ]
}
POLICY
}
