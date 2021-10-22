include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common-vars.yaml")))
}

inputs = {
  github_app_id_secret_name              = "aks-actions-runner-controller-github-app-id"
  github_app_installation_id_secret_name = "aks-actions-runner-controller-github-app-installation-id"
  github_app_private_key_secret_name     = "aks-actions-runner-controller-github-app-private-key"
  key_vault_id                           = dependency.azure.outputs.key_vault_id
}

dependency "azure" {
  config_path = "../azure"
  mock_outputs_allowed_terraform_commands = [
    "init",
    "validate",
    "plan",
  ]
  mock_outputs = {
    resource_group   = "mock-resource-group"
    aks_cluster_name = "mock-aks-cluster-name"
    key_vault_id     = "mock-key-vault-id"
    key_vault_name   = "mock-key-vault-name"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  tenant_id       = "${local.common.default_directory_tenant_id}"
  subscription_id = "${local.common.sandbox_subscription_id}"

  features {}
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    config_context = "${dependency.azure.outputs.aks_cluster_name}-admin"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "${dependency.azure.outputs.aks_cluster_name}-admin"
}
EOF
}

terraform {
  before_hook "cluster_auth" {
    commands = [
      "apply",
      "plan",
      "destroy"
    ]
    execute = [
      "az", "aks", "get-credentials",
      "--resource-group", "${dependency.azure.outputs.resource_group}",
      "--name", "${dependency.azure.outputs.aks_cluster_name}",
      "--subscription", "${local.common.sandbox_subscription_id}",
      "--overwrite-existing",
      "--admin",
      "--verbose"
    ]
  }
}
