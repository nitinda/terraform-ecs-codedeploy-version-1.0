resource "aws_security_group" "demo_security_group_ecs_service_nginx" {
  description = "ingress to the nginx fargate task from the alb"

  vpc_id = "${var.vpc_id}"
  name   = "terraform-demo-security-group-ecs-service-nginx"

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = ["${aws_security_group.demo_security_group_alb_ecs_nginx.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}