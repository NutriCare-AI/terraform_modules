variable "eks_clusters" {
  description = "EKS clusters"
  type        = list(string)
  default     = []
}

variable "service_account" {
  description = "EKS cluster and k8s ServiceAccount pairs. Each EKS cluster can have multiple k8s ServiceAccount. See README for details"
  type        = string
}

variable "tags" {
  description = "A map of tags to add the the IAM role"
  type        = map(any)
  default     = {}
}

variable "role_name" {
  description = "Name of IAM role"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "role_name_prefix" {
  description = "IAM role name prefix"
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = "Whether policies should be detached from this role when destroying"
  type        = bool
  default     = true
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = 3600
}

variable "role_permissions_boundary_arn" {
  description = "Permissions boundary ARN to use for IAM role"
  type        = string
  default     = ""
}

variable "create_policy" {
  description = "Whether to create the policy or not"
  type        = bool
  default     = true
}

variable "policy" {
  description = "The path of the policy in IAM (json file)"
  type        = string
  default     = null
}

variable "namespace" {
  description = "Namespace of the SA"
  type        = string
}

variable "managed_policies" {
  description = "List of managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "allow_self_assume_role" {
  description = "Determines whether to allow the role to be [assume itself](https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/)"
  type        = bool
  default     = false
}