output "resource_group" {
  value = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.runners.name
}

output "key_vault_id" {
  value = azurerm_key_vault.runners.id
}

output "key_vault_name" {
  value = azurerm_key_vault.runners.name
}
