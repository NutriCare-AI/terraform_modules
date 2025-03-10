resource "aws_iam_user" "this" {
  name                 = var.name
  path                 = var.path
  force_destroy        = var.force_destroy
  permissions_boundary = var.permissions_boundary

  tags = var.tags
}

resource "aws_iam_user_policy" "lb_ro" {
  name = "${var.name}-policy"
  user = aws_iam_user.this.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = var.custom_policy
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each = { for k, v in var.policy_arns : k => v }

  user       = aws_iam_user.this.name
  policy_arn = each.value
}