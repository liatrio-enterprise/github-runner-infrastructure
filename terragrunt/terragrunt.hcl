locals {
  tenant_id       = get_env("TF_VAR_arm_tenant_id")
  subscription_id = get_env("TF_VAR_arm_subscription_id")
}

inputs = {
  admin_group_object_id                  = "660a8f6b-7692-495a-bfa0-859e2ea6b6c9"
  dns_zone_name                          = "liatrio-cloud-runners.az.liatr.io"
  github_app_id_secret_name              = "aks-actions-runner-controller-github-app-id"
  github_app_installation_id_secret_name = "aks-actions-runner-controller-github-app-installation-id"
  github_app_private_key_secret_name     = "aks-actions-runner-controller-github-app-private-key"
  github_webhook_secret_secret_name      = "aks-actions-runner-controller-github-webhook-secret"
  tenant_id                              = local.tenant_id
  subscription_id                        = local.subscription_id
}

terraform {
  source = "..//terraform"
}

terraform_version_constraint  = ">= 1.0"
terragrunt_version_constraint = ">=0.31"

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
    key                  = "aks-runners/live/sandbox/azure/terraform.tfstate"
    tenant_id            = local.tenant_id
    subscription_id      = local.subscription_id
  }
}
