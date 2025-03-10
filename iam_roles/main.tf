data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = var.trusted_role_services
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name                  = var.role_name
  name_prefix           = var.role_prefix
  description           = var.role_description
  force_detach_policies = var.force_detach_policies
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  tags                  = var.tags
}


resource "aws_iam_policy" "policy" {
  count = var.create_policy == true ? 1 : 0

  name        = var.policy_name
  name_prefix = var.policy_prefix
  description = var.policy_description
  policy      = var.policy
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "custom_policy" {
  count      = var.create_policy == true ? 1 : 0

  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy[0].arn
}

resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = var.create_managed_policies == true ? toset(var.managed_policies) : toset([])

  role       = aws_iam_role.role.name
  policy_arn = each.value
}



