resource "helm_release" "sonarqube" {
  name             = "sonarqube"
  repository       = "https://SonarSource.github.io/helm-chart-sonarqube"
  chart            = "sonarqube"
  version          = "10.5.1+2535"
  namespace        = "sonarqube"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
