variable "vm_name" {
    type    = string
    default = ""
}

variable "vm_id" {
    type    = string
    default = ""
}

variable "resource_group_name" {
  type        = string
  default     = ""
}

variable "location" {
  type        = string
  default     = ""
}

variable "key_vault_id" {
  type      = string
  default   = ""
}

variable "automation_account_name" {
    type    = string
    default = "monitoring"
}

variable "runbook_name" {
    type    = string
    default = "alert-notification"
}

variable "webhook_link" {
  type    = string
  default = ""
}