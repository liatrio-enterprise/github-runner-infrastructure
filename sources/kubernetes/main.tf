terraform {
  required_providers {
    azurerm    = {
      source  = "hashicorp/azurerm"
      version = "~>2.82"
    }
    helm       = {
      source  = "hashicorp/helm"
      version = "~>2.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.6"
    }
  }
}

data "azurerm_key_vault_secret" "github_app_id" {
  key_vault_id = var.key_vault_id
  name         = var.github_app_id_secret_name
}

data "azurerm_key_vault_secret" "github_app_installation_id" {
  key_vault_id = var.key_vault_id
  name         = var.github_app_installation_id_secret_name
}

data "azurerm_key_vault_secret" "github_app_private_key" {
  key_vault_id = var.key_vault_id
  name         = var.github_app_private_key_secret_name
}

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

resource "helm_release" "actions_runner_controller" {
  name             = "actions-runner-controller"
  namespace        = "actions-runner-controller"
  create_namespace = true

  repository = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart      = "actions-runner-controller"
  version    = "0.14.0"

  set {
    name  = "authSecret.create"
    value = true
  }

  set_sensitive {
    name  = "authSecret.github_app_id"
    value = data.azurerm_key_vault_secret.github_app_id.value
  }

  set_sensitive {
    name  = "authSecret.github_app_installation_id"
    value = data.azurerm_key_vault_secret.github_app_installation_id.value
  }

  set_sensitive {
    name  = "authSecret.github_app_private_key"
    value = base64decode(data.azurerm_key_vault_secret.github_app_private_key.value)
  }
}

resource "kubernetes_manifest" "runner_deployment" {
  manifest = {
    apiVersion = "actions.summerwind.dev/v1alpha1"
    kind       = "RunnerDeployment"
    metadata   = {
      name      = "liatrio-cloud"
      namespace = helm_release.actions_runner_controller.namespace
    }
    spec       = {
      replicas = "3"
      template = {
        spec = {
          organization = "liatrio-cloud"
        }
      }
    }
  }
}
