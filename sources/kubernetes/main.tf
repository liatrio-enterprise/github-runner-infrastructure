terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.96"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.8"
    }
  }
}

data "azurerm_client_config" "current" {}
