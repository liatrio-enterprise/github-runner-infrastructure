resource "azurerm_kubernetes_cluster" "runners" {
  name                = "ghe-runners-${data.azurerm_subscription.self.display_name}"
  location            = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.location
  resource_group_name = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name

  kubernetes_version = "1.21.2"

  dns_prefix = "runners"

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed                = true
      azure_rbac_enabled     = true
      admin_group_object_ids = [data.azuread_group.admin_group.id]
    }
  }

  default_node_pool {
    name                   = "default"
    node_count             = 3
    vm_size                = "Standard_D2_v2"
    enable_host_encryption = false
    enable_node_public_ip  = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
  }
}

locals {
  # This gives the owners of the subscription as well as the SP running this automation owner of the cert manager application
  azuread_application_owners = concat(
    data.azurerm_client_config.self.id,
    data.azuread_group.admin_group.members
  )
}

resource "azuread_application" "liatrio_cloud_ghe_cert_manager" {
  display_name = "Cert Manager for GHE runners in ${data.azurerm_subscription.self.display_name}"
  owners       = local.azuread_application_owners
}

resource "azuread_service_principal" "cert_manager" {
  application_id               = azuread_application.liatrio_cloud_ghe_cert_manager.application_id
  app_role_assignment_required = false
  owners                       = data.azuread_group.admin_group.members
}

resource "azuread_service_principal_password" "cert_manager" {
  service_principal_id = azuread_service_principal.cert_manager.id
}

resource "azurerm_role_assignment" "cert_manager_dns_contributor" {
  principal_id         = azuread_service_principal.cert_manager.id
  scope                = data.azurerm_dns_zone.runner_zone.id
  role_definition_name = "DNS Zone Contributor"
}

resource "azurerm_key_vault_secret" "cert_manager_sp_secret" {
  name         = "cert-manager-sp-secret-password"
  value        = azuread_service_principal_password.cert_manager.value
  key_vault_id = azurerm_key_vault.runners.id
}
