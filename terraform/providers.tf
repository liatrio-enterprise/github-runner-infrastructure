provider "azuread" {
  tenant_id = var.arm_tenant_id
}

provider "azurerm" {
  tenant_id       = var.arm_tenant_id
  subscription_id = var.arm_subscription_id

  features {}
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.runners.kube_admin_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.runners.kube_admin_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.runners.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.runners.kube_admin_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.runners.kube_admin_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.runners.kube_admin_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.runners.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.runners.kube_admin_config.0.cluster_ca_certificate)
  }
}
