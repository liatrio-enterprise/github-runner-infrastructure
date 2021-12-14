resource "azurerm_key_vault" "runners" {
  name                      = "liatriocloudgherunners"
  location                  = "centralus"
  resource_group_name       = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name
  sku_name                  = "standard"
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "admin_key_vault_owners" {
  principal_id         = var.admin_group_object_id
  scope                = azurerm_key_vault.runners.id
  role_definition_name = "Key Vault Administrator"
}
