resource "helm_release" "tf_serving" {
  name             = "tf-serving"
  repository       = "https://tensorflow.github.io/serving-helm"
  chart            = "tf-serving"
  version          = "0.7.0"
  namespace        = "tf-serving"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
