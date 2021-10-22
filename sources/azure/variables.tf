variable "admin_group_object_id" {
  type = string
}

variable "network_address_space" {
  type = list(string)
}

variable "default_node_pool_subnet_address_space" {
  type = list(string)
}
