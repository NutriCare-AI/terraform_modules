### Organizational Unit variables
variable "create_organizational_unit" {
  description = "Whether to create OU or not"
  type        = bool
  default     = true
}

variable "organizational_unit_name" {
  description = "The name for the organizational unit"
  type        = string
}

variable "organizational_unit_parent_id" {
  description = " ID of the parent organizational unit, which may be the root"
  type        = string
}

### Organization Account variables

variable "create_account" {
  description = "Whether to create Account or not"
  type        = bool
  default     = true
}

variable "email" {
  description = "(Required) Email address of the owner to assign to the new member account."
  type        = string
}

variable "organization_account_name" {
  description = "(Required) Friendly name for the member account."
  type        = string
}

variable "close_on_deletion" {
  description = "(Optional) If true, a deletion event will close the account."
  type        = bool
  default     = false
}

variable "create_govcloud" {
  description = "(Optional) Whether to also create a GovCloud account."
  type        = bool
  default     = false
}

variable "iam_user_access_to_billing" {
  description = "(Optional) If set to ALLOW, the new account enables IAM users and roles to access account billing information if they have the required permissions."
  type        = string
  default     = "ALLOW"
  validation {
    condition     = can(regex("^(ALLOW|DENY)$", var.iam_user_access_to_billing))
    error_message = "Valid values are ALLOW or DENY."
  }
}

variable "parent_id" {
  description = "(Optional) Parent Organizational Unit ID or Root ID for the account."
  type        = string
  default     = null
}

variable "role_name" {
  description = "(Optional) The name of an IAM role that Organizations automatically preconfigures in the new member account."
  type        = string
  default     = "OrganizationAccountAccessRole"
}

variable "tags" {
  description = "(Optional) Key-value map of resource tags."
  type        = map(string)
  default     = {}
}