include {
  path = find_in_parent_folders()
}

locals {
  tenant_id       = get_env("ARM_TENANT_ID")
  subscription_id = get_env("ARM_SUBSCRIPTION_ID")
}

inputs = {
  dns_zone_name           = "ghe.az.liatr.io"
  dns_zone_resource_group = "ghe-infra"
  cname_target_value      = "ghe-runner-prod-webhook"
  webhook_domain          = "github-runner-webhook"
}
