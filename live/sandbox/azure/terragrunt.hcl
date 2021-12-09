include {
  path = find_in_parent_folders()
}

locals {
  common          = yamldecode(file(find_in_parent_folders("common-vars.yaml")))
  tenant_id       = get_env("TF_VAR_arm_tenant_id")
  subscription_id = get_env("TF_VAR_arm_subscription_id")
}

inputs = {
  admin_group_object_id                  = "660a8f6b-7692-495a-bfa0-859e2ea6b6c9"
  network_address_space                  = ["10.21.0.0/16"]
  default_node_pool_subnet_address_space = ["10.21.2.0/24"]
  tenant_id                              = local.tenant_id
  subscription_id                        = local.subscription_id
  dns_subscription_id                    = local.common.pay_as_you_go_subscription_id
}
