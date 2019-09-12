data "aws_iam_policy_document" "demo_iam_role_policy_codedeploy_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "demo_iam_policy_document_codedeploy" {
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecs:DescribeServices",
      "ecs:CreateTaskSet",
      "ecs:UpdateServicePrimaryTaskSet",
      "ecs:DeleteTaskSet",
      "cloudwatch:DescribeAlarms",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "sns:Publish",
    ]
    resources = ["arn:aws:sns:*:*:CodeDeployTopic_*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:ModifyRule",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = ["arn:aws:lambda:*:*:function:CodeDeployHook_*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectMetadata",
      "s3:GetObjectVersion",
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:ExistingObjectTag/UseWithCodeDeploy"
      values   = ["true"]
    }
    resources = ["*"]
  }
}
