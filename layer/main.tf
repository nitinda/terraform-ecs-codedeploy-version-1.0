terraform {
  required_version = ">= 0.11.7"
}


#######################  CloudWatch Logs

module "aws_resources_module_cloudwatch_log_ecs_service_nginx" {
  source  = "../module_cloudwatch_log"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags               = "${var.common_tags}"
  cloudwatch_log_group_name = "terraform-demo-cloudwatch-log-group-nginx"
}



#######################  IAM

module "aws_resources_module_iam_ecs" {
  source  = "../module_iam_ecs"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags     = "${var.common_tags}"
  aws_account_ids = {
    Accounts-1 = "760341739473"
    Accounts-2 = "${data.aws_caller_identity.demo_caller_identity_current.account_id}"
  }
}


module "aws_resources_module_iam_grafana" {
  source  = "../module_iam_grafana"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags     = "${var.common_tags}"
  ecs_task_role_arn = "${module.aws_resources_module_iam_ecs.ecs_task_role_arn}"
  aws_account_ids = {
    Accounts-1 = "760341739473"
    Accounts-2 = "${data.aws_caller_identity.demo_caller_identity_current.account_id}"
  }
}

module "aws_resources_module_iam_codedeploy" {
  source  = "../module_iam_codedeploy"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags = "${var.common_tags}"
}


########################## CodeDeploy App
module "aws_resources_module_codedeploy_app_ecs_service_nginx" {
  source  = "../module_codedeploy_app"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags = "${var.common_tags}"
  compute_platform = "ECS"
  code_deploy_app_name = "terraform-demo-codedeploy-app-ecs-service-nginx"
}


########################## Network

module "aws_resources_module_network" {
  source  = "../module_network"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags = "${var.common_tags}"
}


########################## ECS on EC2

module "aws_resources_module_ecs_cluster_ec2" {
  source  = "../module_ecs_cluster_ec2"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags               = "${var.common_tags}"
  ecs_cluster_name          = "${var.ecs_cluster_name}"
  vpc_id                    = "${module.aws_resources_module_network.vpc_id}"
  web_subnet_ids            = "${module.aws_resources_module_network.web_subnet_ids}"
  public_subnet_ids         = "${module.aws_resources_module_network.public_subnet_ids}"
  public_subnet_cidr_blocks = "${module.aws_resources_module_network.public_subnet_cidr_blocks}"
  ecs_instance_profile_name = "${module.aws_resources_module_iam_ecs.ecs_instance_profile_name}"
  override_instance_types   = ["t3.xlarge", "t3.large"]
}


module "aws_resources_module_ecs_cluster_ec2_autoscalling_policy" {
  source  = "../module_autoscalling_policy"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags             = "${var.common_tags}"
  autoscaling_group_name  = "${module.aws_resources_module_ecs_cluster_ec2.ecs_autoscalling_group_name}"
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 30
  scaling_adjustment      = 8
  autoscaling_policy_name = "terraform-demo-ecs-autoscaling-policy-target-tracking-scaling"
  simplescaling_enabled   = false
  targettrackingscaling_enabled = true
}


############################################################################################
#############################  Nginx on ECS EC2  ###################################

module "aws_resources_module_ecs_service_nginx" {
  source  = "../module_ecs_service_nginx"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags                    = "${var.common_tags}"
  vpc_id                         = "${module.aws_resources_module_network.vpc_id}"
  public_subnet_ids              = "${module.aws_resources_module_network.public_subnet_ids}"
  web_subnet_ids                 = "${module.aws_resources_module_network.web_subnet_ids}"
  ecs_cluster_name               = "${module.aws_resources_module_ecs_cluster_ec2.ecs_cluster_name}"
  ecs_service_role_name          = "${module.aws_resources_module_iam_ecs.ecs_service_role_name}"
  ecs_task_execution_role_arn    = "${module.aws_resources_module_iam_ecs.ecs_task_execution_role_arn}"
  ecs_task_role_arn              = "${module.aws_resources_module_iam_ecs.ecs_task_role_arn}"
  nginx_image_url                = "nginx:1.17.3"
  nginx_container_name           = "terraform-demo-container-definition-nginx"
  nginx_container_container_port = 80
  nginx_container_host_port      = 80
  cloudwatch_log_group_name      = "${module.aws_resources_module_cloudwatch_log_ecs_service_nginx.cloudwatch_log_group_name}"
  codedeploy_app_name            = "${module.aws_resources_module_codedeploy_app_ecs_service_nginx.code_deploy_application_name}"  
}

#############################  Code Deploy ECS Servcie Nginx 
module "aws_resources_module_codedeployment_group_ecs_service_nginx" {
  source = "../module_codedeployment_group"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags              = "${var.common_tags}"
  ecs_cluster_name         = "${module.aws_resources_module_ecs_cluster_ec2.ecs_cluster_name}"
  ecs_service_name         = "${module.aws_resources_module_ecs_service_nginx.ecs_service_nginx_name}"
  lb_listener_arns         = ["${module.aws_resources_module_ecs_service_nginx.alb_listener_arns}"]
  test_traffic_route_listener_arns = "${module.aws_resources_module_ecs_service_nginx.test_traffic_alb_listener_arns}"

  code_deploy_app                   = "${module.aws_resources_module_codedeploy_app_ecs_service_nginx.code_deploy_application_name}"
  code_deploy_deployment_group_name = "terraform-demo-codedeploy-app-ecs-service-nginx"
  blue_lb_target_group_name         = "${module.aws_resources_module_ecs_service_nginx.blue_lb_target_group_name}"
  green_lb_target_group_name        = "${module.aws_resources_module_ecs_service_nginx.green_lb_target_group_name}"
  action_on_timeout                 = "CONTINUE_DEPLOYMENT"
  auto_rollback_events              = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
  code_deploy_service_role_arn      = "${module.aws_resources_module_iam_codedeploy.codedeploy_iam_role_arn}"
}