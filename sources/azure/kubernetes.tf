resource "azurerm_kubernetes_cluster" "runners" {
  name                = "runners-aks"
  location            = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.location
  resource_group_name = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name

  kubernetes_version = "1.21.2"

  dns_prefix = "runners"

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed                = true
      azure_rbac_enabled     = true
      admin_group_object_ids = [var.admin_group_object_id]
    }
  }

  default_node_pool {
    name                   = "default"
    node_count             = 3
    vm_size                = "Standard_D2_v2"
    enable_host_encryption = false
    enable_node_public_ip  = false
    vnet_subnet_id         = azurerm_subnet.aks_default_node_pool.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
  }
}

resource "azuread_application" "liatrio_cloud_ghe_cert_manager" {
  display_name = "liatrio-cloud-ghe-cert-manager"
  owners       = data.azuread_group.admin_group.members
}

resource "azuread_service_principal" "cert_manager" {
  application_id               = azuread_application.liatrio_cloud_ghe_cert_manager.application_id
  app_role_assignment_required = false
  owners                       = data.azuread_group.admin_group.members
  description                  = "cert manager aks sp for liatrio-cloud github enterprise"
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
