provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret

  features {}
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "${var.cluster_name}-admin"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "${var.cluster_name}-admin"
}
