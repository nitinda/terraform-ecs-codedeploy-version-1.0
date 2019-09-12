## Code Deploy
variable "code_deploy_app" {
  description = "The name of the application."
}

variable "code_deploy_deployment_group_name" {
  description = "description"
}

variable "code_deploy_service_role_arn" {
  description = "description"
}



## Auto Rollback Configuration
variable "action_on_timeout" {
  description = "When to reroute traffic from an original environment to a replacement environment in a blue/green deployment."
}

variable "auto_rollback_events" {
  type        = "list"
  description = "The event type or types that trigger a rollback."
}



# Load Balancer Info
variable "lb_listener_arns" {
  type        = "list"
  description = "List of Amazon Resource Names (ARNs) of the load balancer listeners."
}

variable "test_traffic_route_listener_arns" {
  description = "List of Amazon Resource Names (ARNs) of the load balancer to route test traffic listeners."
}


# ECS
variable "ecs_cluster_name" {
  description = "The ECS Cluster name."
}

variable "ecs_service_name" {
  description = "The ECS Service name."
}

variable "blue_lb_target_group_name" {
  type        = "string"
  description = "Name of the blue target group."
}

variable "green_lb_target_group_name" {
  type        = "string"
  description = "Name of the green target group."
}

#### 

variable common_tags {
  description = "Resources Tags"
  type = "map"
}
