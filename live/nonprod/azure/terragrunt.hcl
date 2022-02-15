include {
  path = find_in_parent_folders()
}

locals {
  tenant_id       = get_env("ARM_TENANT_ID")
  subscription_id = get_env("ARM_SUBSCRIPTION_ID")
}

inputs = {
  dns_zone_name      = "nonprod.az.liatr.io"
  cname_target_value = "ghe-runner-nonprod-webhook"
  webhook_domain     = "github-runner-webhook"
}
