resource "aws_cloudwatch_log_group" "demo_cloudwatch_log_group" {
  name = "${var.cloudwatch_log_group_name}"
  retention_in_days = 7

  tags = "${merge(var.common_tags, map(
      "Name", "${var.cloudwatch_log_group_name}",
      ))}"
}