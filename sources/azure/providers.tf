provider "azuread" {
  tenant_id = var.tenant_id
}

provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id

  features {}
}
provider "azurerm" {
  alias           = "pay-as-you-go"
  tenant_id       = var.tenant_id
  subscription_id = var.dns_subscription_id

  features {}
}
