resource "aws_ecs_service" "demo_ecs_service_nginx" {
  name            = "terraform-demo-ecs-service-nginx"
  cluster         = "${var.ecs_cluster_name}"
  # task_definition = "${aws_ecs_task_definition.demo_ecs_task_definition_grafana.arn}"
  task_definition = "${aws_ecs_task_definition.demo_ecs_task_definition_nginx.family}:${max("${aws_ecs_task_definition.demo_ecs_task_definition_nginx.revision}", "${aws_ecs_task_definition.demo_ecs_task_definition_nginx.revision}")}"
  desired_count   = 1
  launch_type     = "EC2"
  health_check_grace_period_seconds = 300

  network_configuration {
    security_groups = ["${aws_security_group.demo_security_group_ecs_service_nginx.id}"]
    subnets         = ["${var.web_subnet_ids}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.demo_alb_target_group_ecs_nginx_green.arn}"
    container_name   = "terraform-demo-container-definition-nginx"
    container_port   = 80
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  # Work Arround
  lifecycle {
    ignore_changes = [
      "task_definition",
      "load_balancer",
    ]
  }

  depends_on = ["aws_alb.demo_alb_ecs_nginx"]

  # tags = "${merge(var.common_tags, map(
  #   "Name", "terraform-demo-ecs-service-nginx",
  # ))}"
}