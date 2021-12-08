variable "admin_group_object_id" {
  type = string
}

variable "network_address_space" {
  type = list(string)
}

variable "default_node_pool_subnet_address_space" {
  type = list(string)
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "dns_subscription_id" {
  type = string
}

variable "arm_client_id" {
  type = string
}

variable "arm_client_secret" {
  type      = string
  sensitive = true
}
