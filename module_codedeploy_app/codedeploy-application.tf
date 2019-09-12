resource "aws_codedeploy_app" "demo_codedeploy_application" {
  compute_platform = "${var.compute_platform}"
  name             = "${var.code_deploy_app_name}"
}