resource "azurerm_dns_zone" "liatrio-cloud-ghe" {
  name                = "liatrio-cloud-ghe.az.liatr.io"
  resource_group_name = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name
}

resource "azurerm_dns_ns_record" "liatrio_cloud_ghe_child_zone_ns" {
  provider            = azurerm.pay-as-you-go
  name                = "liatrio-cloud-ghe"
  zone_name           = "az.liatr.io"
  resource_group_name = "liatrio-core"
  ttl                 = 300

  records = azurerm_dns_zone.liatrio-cloud-ghe.name_servers
}

resource "azurerm_dns_cname_record" "github_webhook" {
  name                = "github-webhook"
  resource_group_name = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name
  ttl                 = 300
  zone_name           = azurerm_dns_zone.liatrio-cloud-ghe.name
  record              = "liatrio-cloud-actions-runner-controller.centralus.cloudapp.azure.com"
}
