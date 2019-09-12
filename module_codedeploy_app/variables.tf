## Code Deploy
variable "code_deploy_app_name" {
  description = "The name of the application."
}


variable "compute_platform" {
  description = "The compute platform can either be ECS, Lambda, or Server. Default is Server"
}

#### 

variable common_tags {
  description = "Resources Tags"
  type = "map"
}
