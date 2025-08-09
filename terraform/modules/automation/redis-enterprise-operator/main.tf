resource "helm_release" "redis_enterprise_operator" {
  name             = "redis-enterprise-operator"
  repository       = "https://charts.redis.com/"
  chart            = "redis-enterprise-operator"
  version          = "7.2.0"
  namespace        = "redis-enterprise"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
