provider "azurerm" {
  tenant_id       = var.arm_tenant_id
  subscription_id = var.arm_subscription_id

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
