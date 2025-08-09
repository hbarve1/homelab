resource "helm_release" "airflow" {
  name             = "airflow"
  repository       = "https://airflow.apache.org"
  chart            = "airflow"
  version          = "1.13.0"
  namespace        = "airflow"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
