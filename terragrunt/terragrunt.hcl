include {
  path = find_in_parent_folders()
}

locals {
  tenant_id       = get_env("TF_VAR_arm_tenant_id")
  subscription_id = get_env("TF_VAR_arm_subscription_id")
}

inputs = {
  admin_group_object_id                             = "660a8f6b-7692-495a-bfa0-859e2ea6b6c9"
  dns_zone_name                                     = "liatrio-cloud-runners.az.liatr.io"
  github_app_id_secret_name                         = "aks-actions-runner-controller-github-app-id"
  github_app_installation_id_secret_name            = "aks-actions-runner-controller-github-app-installation-id"
  github_app_private_key_secret_name                = "aks-actions-runner-controller-github-app-private-key"
  github_webhook_secret_secret_name                 = "aks-actions-runner-controller-github-webhook-secret"
}
