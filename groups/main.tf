resource "aws_iam_group" "default" {
  name = var.group.name
  path = var.group.path
}

resource "aws_iam_policy" "default_assume" {
  count = var.group.attach_assume_policy == true ? 1 : 0

  name        = "${aws_iam_group.default.name}-assume-role-policy"
  description = "IAM policy to assume role"
  path        = "/"
  policy      = data.aws_iam_policy_document.default_assume[0].json
}

resource "aws_iam_group_policy_attachment" "default_assume_policy" {
  count = var.group.attach_assume_policy == true ? 1 : 0

  group      = aws_iam_group.default.name
  policy_arn = aws_iam_policy.default_assume[0].arn
  depends_on = [
    aws_iam_group.default
  ]
}

resource "aws_iam_policy" "default_policy" {
  count = var.group.attach_default_policy == true ? 1 : 0

  name        = "${aws_iam_group.default.name}-default-policy"
  description = "IAM group default policy"
  path        = "/"
  policy      = var.group.default_policy
}

resource "aws_iam_group_policy_attachment" "default_policy" {
  count = var.group.attach_assume_policy == true ? 1 : 0

  group      = aws_iam_group.default.name
  policy_arn = aws_iam_policy.default_policy[0].arn
  depends_on = [
    aws_iam_group.default
  ]
}

resource "aws_iam_group_policy_attachment" "managed_policy" {
  count = var.group.attach_assume_policy == true ? length(var.group.managed_policy_arns) : 0

  group      = aws_iam_group.default.name
  policy_arn = element(var.group.managed_policy_arns, count.index)
  depends_on = [
    aws_iam_group.default
  ]
}

resource "aws_iam_user_group_membership" "default" {
  for_each = { for user in var.users : user => user.name }

  user   = each.value
  groups = [aws_iam_group.default.name]

  depends_on = [
    aws_iam_group.default
  ]
}