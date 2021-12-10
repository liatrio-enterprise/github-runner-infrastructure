provider "azuread" {
  tenant_id = var.arm_tenant_id
}

provider "azurerm" {
  tenant_id       = var.arm_tenant_id
  subscription_id = var.arm_subscription_id

  features {}
}

provider "azurerm" {
  alias = "pay-as-you-go"

  tenant_id       = var.arm_tenant_id
  subscription_id = var.dns_subscription_id

  features {}
}
