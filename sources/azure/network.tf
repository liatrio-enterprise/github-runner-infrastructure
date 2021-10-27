resource "azurerm_virtual_network" "runners" {
  name                = "runners-network"
  address_space       = var.network_address_space
  location            = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.location
  resource_group_name = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name
}

resource "azurerm_subnet" "aks_default_node_pool" {
  name                 = "default-node-pool-subnet"
  resource_group_name  = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name
  virtual_network_name = azurerm_virtual_network.runners.name
  address_prefixes     = var.default_node_pool_subnet_address_space
}

resource "azurerm_public_ip_prefix" "runners" {
  name                = "runners-pip-prefix"
  location            = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.location
  resource_group_name = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name
  prefix_length       = 31
}

resource "azurerm_nat_gateway" "runners" {
  name                = "runners-natgateway"
  location            = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.location
  resource_group_name = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name
}

resource "azurerm_subnet_nat_gateway_association" "runners_aks_default_node_pool_subnet" {
  subnet_id      = azurerm_subnet.aks_default_node_pool.id
  nat_gateway_id = azurerm_nat_gateway.runners.id
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "runners" {
  nat_gateway_id      = azurerm_nat_gateway.runners.id
  public_ip_prefix_id = azurerm_public_ip_prefix.runners.id
}
