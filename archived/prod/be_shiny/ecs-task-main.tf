output "main_td_revision" {
  value = "${aws_ecs_task_definition.default.revision}"
}

output "main_td_arn" {
  value = "${aws_ecs_task_definition.default.arn}"
}

output "main_td_family" {
  value = "${aws_ecs_task_definition.default.family}"
}

resource "aws_ecs_task_definition" "default" {
  family = "${module.env.environment}-${module.env.project}-${var.role}-td"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 128,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 0,
        "protocol": "tcp"

      }
    ],
    "image": "${aws_ecr_repository.default.repository_url}:nginx",
    "memory": 128,
    "memoryReservation": 64,
    "name": "nginx",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${module.env.environment}-${module.env.project}-nginx",
          "awslogs-region": "eu-west-1"
        }
    },
    "links": [
        "shiny-server"
    ]
  },
  {
    "name": "shiny-server",
    "image": "${aws_ecr_repository.default.repository_url}:shiny-server",
    "essential": true,
    "memory": 1500,
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${module.env.environment}-${module.env.project}-shiny-server",
          "awslogs-region": "eu-west-1"
      }
    }
    ,
    "mountPoints": [
        {
          "containerPath": "/srv/shiny-server/dashboard/data",
          "sourceVolume": "shared",
          "readOnly": false
        }
    ]
  }
]
DEFINITION

  volume {
    name      = "shared"
    host_path = "/efs/data"
  }
}

resource "aws_cloudwatch_log_group" "nginx" {
  name = "${module.env.environment}-${module.env.project}-nginx"

  tags {
    Environment = "${module.env.environment}"
    Cluster     = "${var.cluster}"
  }
}

resource "aws_cloudwatch_log_group" "shiny-server" {
  name = "${module.env.environment}-${module.env.project}-shiny-server"

  tags {
    Environment = "${module.env.environment}"
    Cluster     = "${var.cluster}"
  }
}
