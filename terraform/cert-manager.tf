resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.5.4"

  set {
    name  = "installCRDs"
    value = true
  }
}

data "azurerm_key_vault_secret" "cert_manager_service_principal_secret" {
  key_vault_id = azurerm_key_vault.runners.id
  name         = azurerm_key_vault_secret.cert_manager_sp_secret.name
}

resource "kubernetes_secret" "cert_manager_service_principal" {
  metadata {
    name      = "azuredns-config"
    namespace = helm_release.cert_manager.namespace
  }
  data = {
    client-secret = data.azurerm_key_vault_secret.cert_manager_service_principal_secret.value
  }
}

resource "kubernetes_manifest" "cert_manager_issuer_staging" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-staging"
    }
    spec = {
      acme = {
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"
        email  = "ryanv@liatrio.com"
        privateKeySecretRef = {
          name = "letsencrypt-staging"
        }
        solvers = [
          {
            dns01 = {
              azureDNS = {
                clientID = azuread_application.liatrio_cloud_ghe_cert_manager.application_id
                clientSecretSecretRef = {
                  name = kubernetes_secret.cert_manager_service_principal.metadata[0].name
                  key  = "client-secret"
                }
                subscriptionID    = data.azurerm_client_config.current.subscription_id
                tenantID          = data.azurerm_client_config.current.tenant_id
                resourceGroupName = data.azurerm_dns_zone.runner_zone.resource_group_name
                hostedZoneName    = data.azurerm_dns_zone.runner_zone.name
              }
            }
          }
        ]
      }
    }
  }
}

resource "kubernetes_manifest" "cert_manager_issuer_production" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-production"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = "ryanv@liatrio.com"
        privateKeySecretRef = {
          name = "letsencrypt-production"
        }
        solvers = [
          {
            dns01 = {
              azureDNS = {
                clientID = azuread_application.liatrio_cloud_ghe_cert_manager.application_id
                clientSecretSecretRef = {
                  name = kubernetes_secret.cert_manager_service_principal.metadata[0].name
                  key  = "client-secret"
                }
                subscriptionID    = data.azurerm_client_config.current.subscription_id
                tenantID          = data.azurerm_client_config.current.tenant_id
                resourceGroupName = data.azurerm_dns_zone.runner_zone.resource_group_name
                hostedZoneName    = data.azurerm_dns_zone.runner_zone.name
              }
            }
          }
        ]
      }
    }
  }
}
