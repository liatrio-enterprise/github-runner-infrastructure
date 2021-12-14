terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.7"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.82"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.6"
    }
  }
}

data "azurerm_client_config" "current" {}

data "azuread_group" "admin_group" {
  object_id = var.admin_group_object_id
}

resource "azurerm_resource_group" "liatrio_cloud_ghe_actions_runners" {
  name     = "liatrio-cloud-ghe-actions-runners"
  location = "centralus"
}
