terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.18"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.96"
    }
  }
}

data "azurerm_client_config" "self" {}

data "azurerm_subscription" "self" {}

data "azuread_group" "admin_group" {
  display_name = "${data.azurerm_subscription.self.display_name} Owners"
}

resource "azurerm_resource_group" "liatrio_cloud_ghe_actions_runners" {
  name     = "ghe-actions-runners-infra"
  location = "centralus"
}
