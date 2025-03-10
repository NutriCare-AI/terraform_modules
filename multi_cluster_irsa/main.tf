locals {
  partition  = data.aws_partition.current.partition
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "main" {
  for_each = { for k in var.eks_clusters : k => k }

  name = each.key
}

data "aws_iam_policy_document" "assume_role_policy" {

  dynamic "statement" {
    
    for_each = var.allow_self_assume_role ? [1] : []

    content {
      sid     = "ExplicitSelfRoleAssumption"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      condition {
        test     = "ArnLike"
        variable = "aws:PrincipalArn"
        values   = ["arn:${local.partition}:iam::${data.aws_caller_identity.current.account_id}:role/${var.service_account}-iam-role"]
      }
    }
  }
  
  dynamic "statement" {

    for_each = { for k in var.eks_clusters : k => k }

    content {
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]

      principals {
        type = "Federated"
        identifiers = [
          "arn:${local.partition}:iam::${local.account_id}:oidc-provider/${replace(data.aws_eks_cluster.main[statement.key].identity[0].oidc[0].issuer, "https://", "")}"
        ]
      }

      condition {
        test     = "StringEquals"
        variable = "${replace(data.aws_eks_cluster.main[statement.key].identity[0].oidc[0].issuer, "https://", "")}:aud"
        values   = ["sts.amazonaws.com"]
      }

      condition {
        test     = "StringEquals"
        variable = "${replace(data.aws_eks_cluster.main[statement.key].identity[0].oidc[0].issuer, "https://", "")}:sub"
        values   = ["system:serviceaccount:${var.namespace}:${var.service_account}"]
      }
    }
  }
}

# IRSA IAM role
resource "aws_iam_role" "this" {
  name                  = "${var.service_account}-iam-role"
  name_prefix           = var.role_name_prefix
  path                  = var.role_path
  description           = "AWS IAM role for the Kubernetes service account ${var.service_account}"
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  force_detach_policies = var.force_detach_policies
  permissions_boundary  = var.role_permissions_boundary_arn
  max_session_duration  = var.max_session_duration
  tags                  = var.tags
}

# IRSA IAM policy
resource "aws_iam_policy" "this" {
  count = var.create_policy == true ? 1 : 0

  name_prefix = "${var.service_account}-"
  description = "AWS IAM policy for Kubernetes service account ${var.service_account}"
  policy      = var.policy
  tags        = var.tags
}

# IRSA IAM policy attachments
resource "aws_iam_role_policy_attachment" "this" {
  count = var.create_policy == true ? 1 : 0

  policy_arn = aws_iam_policy.this[0].arn
  role       = aws_iam_role.this.name
}

# IRSA IAM policy attachments
resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = { for k, v in var.managed_policies : k => v }

  policy_arn = each.value
  role       = aws_iam_role.this.name
}

