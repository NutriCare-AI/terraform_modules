variable "trusted_role_services" {
  description = "AWS Services that can assume these roles"
  type        = list(string)
}

variable "role_name" {
  description = "IAM role name"
  type        = string
}

variable "role_prefix" {
  description = "(Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with role_name."
  type        = string
  default     = null
}

variable "role_description" {
  description = "(Optional) Description of the role"
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = "(Optional) Whether to force detaching any policies the role has before destroying it. Defaults to false."
  type        = bool
  default     = false
}

variable "policy_name" {
  description = "(Optional, Forces new resource) Name of the policy. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "policy_prefix" {
  description = "(Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with policy_name."
  type        = string
  default     = null
}

variable "policy_description" {
  description = "(Optional, Forces new resource) Description of the IAM policy."
  type        = string
  default     = null
}

variable "policy_path" {
  description = "Path in which to create the policy. See IAM Identifiers for more information."
  type        = string
  default     = "/"
}

variable "policy" {
  description = "The path of the policy in IAM (json file)"
  type        = string
  default     = ""
}

variable "create_policy" {
  description = "Whether to create the policy or not"
  type        = bool
  default     = true
}

variable "create_managed_policies" {
  description = "Whether to create managed policies for the IAM role"
  type        = bool
  default     = true
}

variable "managed_policies" {
  description = "List of managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add the the IAM role"
  type        = map(any)
  default     = {}
}