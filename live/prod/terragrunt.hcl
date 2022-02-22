locals {
  terragrunt_module_name = replace(path_relative_to_include(), "/^.*/.*//", "")
  tenant_id              = get_env("ARM_TENANT_ID")
  subscription_id        = get_env("ARM_SUBSCRIPTION_ID")
}

remote_state {
  backend = "azurerm"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    resource_group_name  = "ghe-infra"
    storage_account_name = "gheprod"
    container_name       = "tfstate"
    key                  = "aks-runners/${path_relative_to_include()}/terraform.tfstate"
  }
}

terraform {
  source = "${path_relative_from_include()}/../../sources//${local.terragrunt_module_name}"
}

terraform_version_constraint  = ">= 1.0"
terragrunt_version_constraint = ">=0.31"
