include {
  path = find_in_parent_folders()
}

locals {
  tenant_id       = get_env("ARM_TENANT_ID")
  subscription_id = get_env("ARM_SUBSCRIPTION_ID")
}

inputs = {
  admin_group_object_id                  = "660a8f6b-7692-495a-bfa0-859e2ea6b6c9"
  dns_zone_name                          = "liatrio-cloud-runners.az.liatr.io"
}
