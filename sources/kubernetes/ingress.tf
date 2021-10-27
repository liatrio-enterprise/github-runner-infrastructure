resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.6"

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-dns-label-name"
    value = "liatrio-cloud-actions-runner-controller"
    type  = "string"
  }
}


#
#resource "kubernetes_manifest" "liatrio_cloud_ghe_wildcard" {
#  manifest = {
#    apiVersion = "cert-manager.io/v1"
#    kind = "Certificate"
#    metadata = {
#      name = "wildcard-liatrio-cloud-ghe"
#      namespace = helm_release.ingress_nginx.namespace
#    }
#    spec = {
#      secretName = "wildcard-liatrio-cloud-ghe"
#      dnsNames = [
#        "liatrio-cloud-ghe.az.liatr.io",
#        "*.liatrio-cloud-ghe.az.liatr.io"
#      ]
#      issuerRef = {
#        name: kubernetes_manifest.cert_manager_issuer_staging.manifest.metadata.name
#        kind: "Issuer"
#      }
#    }
#  }
#}
