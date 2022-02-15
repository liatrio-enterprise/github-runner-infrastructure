locals {
  subscription_name_sanitized = replace(data.azurerm_subscription.self.display_name, "-", "")
}

resource "azurerm_key_vault" "runners" {
  name                      = "gherunners${local.subscription_name_sanitized}"
  location                  = "centralus"
  resource_group_name       = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name
  sku_name                  = "standard"
  tenant_id                 = data.azurerm_client_config.self.tenant_id
  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "admin_key_vault_owners" {
  principal_id         = data.azuread_group.admin_group.id
  scope                = azurerm_key_vault.runners.id
  role_definition_name = "Key Vault Administrator"
}
