data "aws_region" "demo_current" {}

data "template_file" "demo_template_file_ecs_fargate_task_definition_nginx" {
  template = "${file("${path.module}/task-definitions/ecs-task-definition-nginx.json")}"

  vars {
    nginx_image_url                = "${var.nginx_image_url}"
    nginx_log_group_region         = "${data.aws_region.demo_current.name}"
    nginx_log_group_name           = "${var.cloudwatch_log_group_name}"
    nginx_container_name           = "${var.nginx_container_name}"
    nginx_container_container_port = "${var.nginx_container_container_port}"
    nginx_container_host_port      = "${var.nginx_container_host_port}"
  }
}

