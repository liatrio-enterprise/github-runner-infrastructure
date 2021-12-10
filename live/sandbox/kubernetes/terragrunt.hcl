include {
  path = find_in_parent_folders()
}

locals {
  common          = yamldecode(file(find_in_parent_folders("common-vars.yaml")))
  tenant_id       = get_env("TF_VAR_arm_tenant_id")
  subscription_id = get_env("TF_VAR_arm_subscription_id")
}

inputs = {
  github_app_id_secret_name                         = "aks-actions-runner-controller-github-app-id"
  github_app_installation_id_secret_name            = "aks-actions-runner-controller-github-app-installation-id"
  github_app_private_key_secret_name                = "aks-actions-runner-controller-github-app-private-key"
  github_webhook_secret_secret_name                 = "aks-actions-runner-controller-github-webhook-secret"
  key_vault_id                                      = dependency.azure.outputs.key_vault_id
  cert_manager_service_principal_app_id             = dependency.azure.outputs.cert_manager_application_id
  dns_zone_name                                     = dependency.azure.outputs.dns_zone_name
  dns_zone_resource_group                           = dependency.azure.outputs.resource_group
  cert_manager_service_principal_secret_secret_name = dependency.azure.outputs.cert_manager_service_principal_secret_secret_name
  cluster_name                                      = dependency.azure.outputs.aks_cluster_name
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

terraform {
  before_hook "az_login" {
    commands = [
      "apply",
      "plan",
      "destroy"
    ]

    execute = [
      "az", "login", "--service-principal",
      "--username", get_env("TF_VAR_arm_client_id"),
      "--password", get_env("TF_VAR_arm_client_secret"),
      "--tenant", "${local.tenant_id}"
    ]
  }

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
      "--subscription", "${local.subscription_id}",
      "--overwrite-existing",
      "--admin",
      "--verbose"
    ]
  }
}
