############################# OUTPUTS START
output "ec2_service_sg" {
  value = "${aws_security_group.service.id}"
}

############################# OUTPUTS END

resource "aws_security_group" "service" {
  name        = "${module.env.environment}-${module.env.project}-service-sg"
  vpc_id      = "vpc-f3c9f796"
  description = "sg for IT management"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["217.133.84.68/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["217.133.84.68/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["217.133.84.68/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
