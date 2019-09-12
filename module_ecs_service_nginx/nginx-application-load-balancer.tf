resource "aws_alb" "demo_alb_ecs_nginx" {
    name                = "tf-demo-alb-ecs-nginx"
    security_groups     = ["${aws_security_group.demo_security_group_alb_ecs_nginx.id}"]
    subnets             = ["${var.public_subnet_ids}"]
    internal            = false
    load_balancer_type  = "application"

    tags = "${merge(var.common_tags, map(
        "Name", "terraform-demo-alb-ecs-nginx",
    ))}"
}

