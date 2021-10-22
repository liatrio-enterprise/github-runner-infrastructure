terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.82"
    }
  }
}

data "azurerm_client_config" "self" {
}

resource "azurerm_resource_group" "liatrio_cloud_ghe_actions_runners" {
  name     = "liatrio-cloud-ghe-actions-runners"
  location = "centralus"
}

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

resource "azurerm_kubernetes_cluster" "runners" {
  name                = "runners-aks"
  location            = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.location
  resource_group_name = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name

  kubernetes_version = "1.21.2"

  dns_prefix = "runners"

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed                = true
      azure_rbac_enabled     = true
      admin_group_object_ids = [var.admin_group_object_id]
    }
  }

  default_node_pool {
    name                   = "default"
    node_count             = 3
    vm_size                = "Standard_D2_v2"
    enable_host_encryption = false
    enable_node_public_ip  = false
    vnet_subnet_id         = azurerm_subnet.aks_default_node_pool.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
  }
}
