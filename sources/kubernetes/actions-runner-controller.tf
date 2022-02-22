locals {
  runners = [
    {
      name  = "nodejs-12"
      image = "ghcr.io/liatrio-enterprise/runner-images/nodejs-12:v1.1.1"
      labels = [
        "nodejs-12"
      ]
    },
    {
      name  = "dotnet-sdk-3.1"
      image = "ghcr.io/liatrio-enterprise/runner-images/dotnet-sdk-3.1:v1.1.0"
      labels = [
        "dotnet-sdk-3.1"
      ]
    },
    {
      name  = "terraform-1.0"
      image = "ghcr.io/liatrio-enterprise/runner-images/terraform-1.0:v1.1.2"
      labels = [
        "terraform-1.0"
      ]
    }
  ]
}

resource "random_uuid" "shared_secret" {
  keepers = {
    cluster_name = var.cluster_name
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

  set {
    name  = "githubWebhookServer.enabled"
    value = true
  }

  set {
    name  = "githubWebhookServer.secret.create"
    value = true
  }

  set_sensitive {
    name  = "githubWebhookServer.secret.github_webhook_secret_token"
    value = random_uuid.shared_secret.result
  }

  set_sensitive {
    name  = "authSecret.github_token"
    value = var.github_pat
  }
}

# resource "kubernetes_manifest" "runner_deployments" {
#   for_each = { for r in local.runners : r.name => r }
#   manifest = {
#     apiVersion = "actions.summerwind.dev/v1alpha1"
#     kind       = "RunnerDeployment"
#     metadata = {
#       name      = "liatrio-cloud-${each.value.name}"
#       namespace = helm_release.actions_runner_controller.namespace
#     }
#     spec = {
#       template = {
#         spec = {
#           group         = var.environment_label
#           enterprise    = "liatrio-partnerdemo"
#           dockerEnabled = false
#           ephemeral     = true
#           labels        = concat(each.value.labels, [var.environment_label])
#           image         = each.value.image
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_manifest" "runner_autoscalers" {
#   for_each = { for r in local.runners : r.name => r }
#   manifest = {
#     apiVersion = "actions.summerwind.dev/v1alpha1"
#     kind       = "HorizontalRunnerAutoscaler"
#     metadata = {
#       name      = "liatrio-cloud-autoscaler-${each.value.name}"
#       namespace = helm_release.actions_runner_controller.namespace
#     }
#     spec = {
#       minReplicas = 1
#       maxReplicas = 5
#       scaleTargetRef = {
#         name = kubernetes_manifest.runner_deployments[each.key].manifest.metadata.name
#       }
#       scaleUpTriggers = [
#         {
#           githubEvent = {}
#           duration    = "10m"
#         }
#       ]
#     }
#   }
# }

# resource "kubernetes_manifest" "github_webhook_ingress" {
#   manifest = {
#     apiVersion = "networking.k8s.io/v1"
#     kind       = "Ingress"
#     metadata = {
#       name      = var.webhook_domain
#       namespace = helm_release.actions_runner_controller.namespace
#       annotations = {
#         "cert-manager.io/cluster-issuer" : kubernetes_manifest.cert_manager_issuer_production.manifest.metadata.name
#       }
#     }
#     spec = {
#       rules = [
#         {
#           host = "${var.webhook_domain}.${var.dns_zone_name}"
#           http = {
#             paths = [
#               {
#                 path     = "/"
#                 pathType = "Prefix"
#                 backend = {
#                   service = {
#                     name = "actions-runner-controller-github-webhook-server"
#                     port = {
#                       name = "http"
#                     }
#                   }
#                 }
#               }
#             ]
#           }
#         }
#       ]
#       tls = [
#         {
#           hosts = [
#             "${var.webhook_domain}.${var.dns_zone_name}"
#           ]
#           secretName = "github-runner-webhook-tls"
#         }
#       ]
#       ingressClassName = "nginx"
#     }
#   }
# }
