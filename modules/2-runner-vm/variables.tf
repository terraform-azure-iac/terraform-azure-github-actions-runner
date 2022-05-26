variable "resource_group_name" {
  type        = string
  default     = ""
}

variable "location" {
  type        = string
  default     = ""
}

variable "interface_id" {
  type    = string
  default = ""
}

variable "public_key" {
  type    = string
  default = ""
}

variable "key_vault_id" {
  type    = string
  default = ""
}

variable "vm_name" {
  type    = string
  default = "pipeline-runner"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "vm_admin_username" {
  type    = string
  default = "runner-admin"
}

variable "github_token" {
  type    = string
  default = ""
}

variable "webhook_url" {
  type    = string
  default = ""
}