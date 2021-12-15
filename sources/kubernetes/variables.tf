variable "key_vault_id" {
  type = string
}

variable "github_webhook_secret_secret_name" {
  type = string
}

variable "cert_manager_service_principal_app_id" {
  type = string
}

variable "dns_zone_name" {
  type = string
}

variable "dns_zone_resource_group" {
  type = string
}

variable "cert_manager_service_principal_secret_secret_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "arm_tenant_id" {
  type = string
}

variable "arm_subscription_id" {
  type = string
}

variable "github_pat" {
  type        = string
  description = "PAT for setting up enterprise runners"
  secret      = true
}
