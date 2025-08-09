resource "helm_release" "redisinsight_secure" {
  name             = "redisinsight-secure"
  repository       = "https://charts.redis.com/"
  chart            = "redisinsight"
  version          = "2.44.0"
  namespace        = "redisinsight"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
