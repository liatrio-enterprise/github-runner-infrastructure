terraform {
  required_providers {
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
