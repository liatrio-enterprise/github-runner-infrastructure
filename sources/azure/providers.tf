provider "azuread" {
  tenant_id = var.tenant_id
}

provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret

  features {}
}
provider "azurerm" {
  alias = "pay-as-you-go"

  tenant_id       = var.tenant_id
  subscription_id = var.dns_subscription_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret

  features {}
}
