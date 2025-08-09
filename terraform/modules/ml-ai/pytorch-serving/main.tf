resource "helm_release" "pytorch_serve" {
  name             = "pytorch-serve"
  repository       = "https://pytorch.github.io/serve"
  chart            = "pytorch-serve"
  version          = "0.7.2"
  namespace        = "pytorch-serve"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
