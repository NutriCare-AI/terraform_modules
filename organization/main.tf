# Create an organizational unit if specified in the variables
resource "aws_organizations_organizational_unit" "this" {
  count     = var.create_organizational_unit ? 1 : 0
  name      = var.organizational_unit_name
  parent_id = var.organizational_unit_parent_id
  tags      = var.tags
}

# Define AWS Organization accounts
resource "aws_organizations_account" "this" {
  for_each                    = toset([var.organization_account_name])
  email                       = var.email
  name                        = each.value
  close_on_deletion           = var.close_on_deletion
  create_govcloud             = var.create_govcloud
  iam_user_access_to_billing  = var.iam_user_access_to_billing
  parent_id                   = var.parent_id
  role_name                   = var.role_name
  tags                        = var.tags
}

# IAM Policy Document for Organization policies
data "aws_iam_policy_document" "example" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

# Organization Policy based on IAM policy document
resource "aws_organizations_policy" "example" {
  name    = "example"
  content = data.aws_iam_policy_document.example.json
}

# Attach policy to the Organizational Unit
resource "aws_organizations_policy_attachment" "unit" {
  policy_id = aws_organizations_policy.example.id
  target_id = aws_organizations_organizational_unit.this[0].id
  depends_on = [aws_organizations_organizational_unit.this]
}

# Attach policy directly to an Organization Account by ID
resource "aws_organizations_policy_attachment" "account" {
  policy_id = aws_organizations_policy.example.id
  target_id = "123456789012"
}
