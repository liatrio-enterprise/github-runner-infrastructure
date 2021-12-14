locals {
  terragrunt_module_name = replace(path_relative_to_include(), "/^.*/.*//", "")
  tenant_id              = get_env("TF_VAR_arm_tenant_id")
  subscription_id        = get_env("TF_VAR_arm_subscription_id")
}

remote_state {
  backend = "azurerm"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    resource_group_name  = "github-workshop"
    storage_account_name = "githubworkshop"
    container_name       = "tfstate"
    key                  = "aks-runners/${path_relative_to_include()}/terraform.tfstate"
    tenant_id            = local.tenant_id
    subscription_id      = local.subscription_id
  }
}

inputs = {
  tenant_id       = local.tenant_id
  subscription_id = local.subscription_id
}

terraform {
  source = "${path_relative_from_include()}/sources//${local.terragrunt_module_name}"
}

terraform_version_constraint  = ">= 1.0"
terragrunt_version_constraint = ">=0.31"
