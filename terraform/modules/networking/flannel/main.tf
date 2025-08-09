resource "helm_release" "flannel" {
  name             = "flannel"
  repository       = "https://flannel-helm.s3.amazonaws.com"
  chart            = "flannel"
  version          = "0.0.19"
  namespace        = "kube-flannel"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
