# Green
resource "aws_alb_target_group" "demo_alb_target_group_ecs_nginx_green" {
    name_prefix          = "ng-gr-"
    port                 = "80"
    protocol             = "HTTP"
    vpc_id               = "${var.vpc_id}"
    deregistration_delay = 5
    target_type          = "ip"
    depends_on           = ["aws_alb.demo_alb_ecs_nginx"]

    lifecycle {
        create_before_destroy = true
    }

    health_check {
        healthy_threshold   = "2"
        unhealthy_threshold = "2"
        interval            = "5"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "3"
    }

    tags = "${merge(var.common_tags, map(
        "Name", "terraform-demo-alb-target-group-ecs-nginx-green",
        "Description", "Target Group for Nginx",
    ))}"
}



### Blue
resource "aws_alb_target_group" "demo_alb_target_group_ecs_nginx_blue" {
    name_prefix          = "ng-bl-"
    port                 = "80"
    protocol             = "HTTP"
    vpc_id               = "${var.vpc_id}"
    deregistration_delay = 5
    target_type          = "ip"
    depends_on           = ["aws_alb.demo_alb_ecs_nginx"]

    lifecycle {
        create_before_destroy = true
    }

    health_check {
        healthy_threshold   = "2"
        unhealthy_threshold = "2"
        interval            = "5"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "3"
    }

    tags = "${merge(var.common_tags, map(
        "Name", "tf-demo-alb-target-group-ecs-nginx-blue",
        "Description", "Target Group for nginx",
    ))}"
}

