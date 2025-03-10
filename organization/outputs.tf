#### Organizational Unit Outputs
output "aws_orgnaization_unit_arn" {
  description = "ARN of the organizational unit"
  value       = try(aws_organizations_organizational_unit.this[0].arn, "")
}

output "aws_orgnaization_unit_id" {
  description = "Identifier of the organization unit"
  value       = try(aws_organizations_organizational_unit.this[0].id, "")
}

output "aws_orgnaization_unit_tags_all" {
  description = " A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = try(aws_organizations_organizational_unit.this[0].tags_all, "")
}

#### Organization Accounts Outputs
output "aws_organizations_account_arn" {
  description = "The ARN for this account."
  value       = [for account in aws_organizations_account.this : account.arn]
}

output "aws_organizations_account_govcloud_id" {
  description = "ID for a GovCloud account created with the account."
  value       = [for account in aws_organizations_account.this : account.govcloud_id]
}

output "aws_organizations_account_id" {
  description = "The AWS account id."
  value       = [for account in aws_organizations_account.this : account.id]
}

output "aws_organizations_account_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = [for account in aws_organizations_account.this : account.tags_all]
}