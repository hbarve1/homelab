resource "helm_release" "solr" {
  name             = "solr"
  repository       = "https://solr.apache.org/charts"
  chart            = "solr"
  version          = "0.10.1"
  namespace        = "solr"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
