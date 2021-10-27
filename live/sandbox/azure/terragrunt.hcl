include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common-vars.yaml")))
}

inputs = {
  admin_group_object_id                  = "660a8f6b-7692-495a-bfa0-859e2ea6b6c9"
  network_address_space                  = ["10.21.0.0/16"]
  default_node_pool_subnet_address_space = ["10.21.2.0/24"]
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azuread" {
  tenant_id = "${local.common.default_directory_tenant_id}"
}

provider "azurerm" {
  tenant_id       = "${local.common.default_directory_tenant_id}"
  subscription_id = "${local.common.sandbox_subscription_id}"

  features {}
}
provider "azurerm" {
  alias           = "pay-as-you-go"
  tenant_id       = "${local.common.default_directory_tenant_id}"
  subscription_id = "${local.common.pay_as_you_go_subscription_id}"

  features {}
}
EOF
}

