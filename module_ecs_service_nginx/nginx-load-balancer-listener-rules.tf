resource "aws_alb_listener" "demo_alb_listener_ecs_nginx_front_end_http" {
    load_balancer_arn = "${aws_alb.demo_alb_ecs_nginx.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.demo_alb_target_group_ecs_nginx_green.arn}"
        type             = "forward"
    }

    # # Work Arround
    # lifecycle {
    #     ignore_changes = ["action.0.target_group_arn",]
    # }
}

resource "aws_alb_listener" "demo_alb_listener_ecs_nginx_test_front_end_http" {
    load_balancer_arn = "${aws_alb.demo_alb_ecs_nginx.arn}"
    port              = "8080"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.demo_alb_target_group_ecs_nginx_blue.arn}"
        type             = "forward"
    }

    # # Work Arround
    # lifecycle {
    #     ignore_changes = ["action.0.target_group_arn",]
    # }
}
