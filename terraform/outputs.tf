output "resource_group" {
  value = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name
}

output "key_vault_name" {
  value = azurerm_key_vault.runners.name
}

output "cert_manager_service_principal_id" {
  value = azuread_service_principal.cert_manager.object_id
}

output "cert_manager_service_principal_secret_secret_name" {
  value = azurerm_key_vault_secret.cert_manager_sp_secret.name
}
