output "cloudwatch_log_group_name" {
  value = "${aws_cloudwatch_log_group.demo_cloudwatch_log_group.name}"
}
