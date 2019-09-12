resource "aws_codedeploy_deployment_group" "demo_codedeploy_deployment_group" {
  app_name               = "${var.code_deploy_app}"
  deployment_group_name  = "${var.code_deploy_deployment_group_name}"
  service_role_arn       = "${var.code_deploy_service_role_arn}"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  auto_rollback_configuration {
    enabled = true
    events = ["${var.auto_rollback_events}"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "${var.action_on_timeout}"
      wait_time_in_minutes = 0
    }
    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  ecs_service {
    cluster_name = "${var.ecs_cluster_name}"
    service_name = "${var.ecs_service_name}"
  }
  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${var.lb_listener_arns}"]
      }
      target_group {
        name = "${var.blue_lb_target_group_name}"
      }
      target_group {
        name = "${var.green_lb_target_group_name}"
      }
      test_traffic_route {
        listener_arns = ["${var.test_traffic_route_listener_arns}"]
      }
    }
  }
  
  lifecycle {
    ignore_changes = ["blue_green_deployment_config"]
  }
}