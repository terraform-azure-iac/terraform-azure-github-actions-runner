
variable "github_token" {
  type        = string
  description = "Token from GitHub. Is passed into modules/2-runner-vm/scripts/init.sh"
  default     = ""
}

variable "webhook_url" {
  type        = string
  description = "A webhook url for alerts and when runner is configured."
  default     = ""
}

variable "resource_group_name" {
  type        = string
  default     = "github-actions"
}

variable "location" {
  type        = string
  default     = "norwayeast"
}
