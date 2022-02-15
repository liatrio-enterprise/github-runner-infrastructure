data "azurerm_dns_zone" "runner_zone" {
  name                = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group
}

resource "azurerm_dns_cname_record" "github_webhook" {
  name                = var.webhook_domain
  resource_group_name = data.azurerm_dns_zone.runner_zone.name
  ttl                 = 300
  zone_name           = data.azurerm_dns_zone.runner_zone.name
  record              = "${var.cname_target_value}.centralus.cloudapp.azure.com"
}
