variable "ecs_cluster_name" {
  description = "description"
}

variable "ecs_service_role_name" {
  description = "description"
}

variable "ecs_task_role_arn" {
  description = "description"
}

variable "ecs_task_execution_role_arn" {
  description = "description"
}

variable common_tags {
  description = "Resources Tags"
  type = "map"
}

variable "nginx_image_url" {
  description = "the image url for the container image"
}

variable "nginx_container_name" {
  description = "description"
}

variable "nginx_container_host_port" {
  description = "description"
}

variable "nginx_container_container_port" {
  description = "description"
}

variable "cloudwatch_log_group_name" {
  description = "description"
}


####

variable "public_subnet_ids" {
  description = "the load balancer subnets"
  type        = "list"
}

variable "web_subnet_ids" {
  description = "the subnets used for the container task"
  type = "list"
}

variable "vpc_id" {
  description = "The vpc id where container will be deployed"
}

variable "codedeploy_app_name" {
  description = "The name of the code deploy application"
}