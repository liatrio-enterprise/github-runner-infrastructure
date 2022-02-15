#data "azurerm_dns_zone" "runner_zone" {
#  name                = var.dns_zone_name
#  resource_group_name = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name
#}
#
#resource "azurerm_dns_cname_record" "github_webhook" {
#  name                = "github-webhook"
#  resource_group_name = azurerm_resource_group.liatrio_cloud_ghe_actions_runners.name
#  ttl                 = 300
#  zone_name           = data.azurerm_dns_zone.runner_zone.name
#  record              = "liatrio-cloud-actions-runner-controller.centralus.cloudapp.azure.com"
#}
