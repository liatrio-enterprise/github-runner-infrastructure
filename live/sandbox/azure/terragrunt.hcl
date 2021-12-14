include {
  path = find_in_parent_folders()
}

#locals {
#  common          = yamldecode(file(find_in_parent_folders("common-vars.yaml")))
#}

inputs = {
  admin_group_object_id                  = "660a8f6b-7692-495a-bfa0-859e2ea6b6c9"
  network_address_space                  = ["10.21.0.0/16"]
  default_node_pool_subnet_address_space = ["10.21.2.0/24"]
  dns_zone_name                          = "liatrio-cloud-runners.az.liatr.io"
}
