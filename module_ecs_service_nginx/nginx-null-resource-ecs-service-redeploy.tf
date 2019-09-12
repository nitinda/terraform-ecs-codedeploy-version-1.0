resource "null_resource" "demo_null_resource_ecs_service_nginix_redeploy" {
  triggers {
    task_definition_arn = "${aws_ecs_task_definition.demo_ecs_task_definition_nginx.arn}"
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/ecs-service-redeploy.sh ${var.codedeploy_app_name} ${var.nginx_container_name} ${var.nginx_container_container_port} ${aws_ecs_task_definition.demo_ecs_task_definition_nginx.arn}"
  }
}