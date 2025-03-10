output "arn" {
  description = "ARN of IAM role"
  value       = aws_iam_role.role.arn
}

output "assume_role" {
  description = "Policy document associated with the role."
  value = aws_iam_role.role.assume_role_policy 
}

output "policy" {
  description = "Policy document of the policy."
  value = aws_iam_policy.policy[*].policy
}