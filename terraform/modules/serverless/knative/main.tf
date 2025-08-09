resource "kubernetes_namespace" "knative_serving" {
  metadata {
    name = "knative-serving"

  }
}

locals {
  serving_crds = split("\n---\n", file("${path.module}/serving-crds.yaml"))
  serving_core = split("\n---\n", file("${path.module}/serving-core.yaml"))
}

resource "kubernetes_manifest" "knative_serving_crds" {
  for_each = { for idx, doc in local.serving_crds : idx => doc if trimspace(doc) != "" }
  manifest = yamldecode(each.value)
}

# 1st deployment of Knative Serving CRDs
# then uncomment following lines to deploy the core components
# resource "kubernetes_manifest" "knative_serving_core" {
#   for_each = { for idx, doc in local.serving_core : idx => doc if trimspace(doc) != "" }
#   manifest = yamldecode(each.value)
#   depends_on = [kubernetes_manifest.knative_serving_crds, kubernetes_namespace.knative_serving]
# }

# Download the official Knative Serving CRDs and core manifests from:
# https://github.com/knative/serving/releases/download/knative-v1.18.0/serving-crds.yaml
# https://github.com/knative/serving/releases/download/knative-v1.18.0/serving-core.yaml
# Place them in this module as serving-crds.yaml and serving-core.yaml
#
# For production, you may want to add networking layer (e.g., Kourier, Istio) as well.
