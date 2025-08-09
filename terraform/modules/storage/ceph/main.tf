resource "helm_release" "ceph" {
  name             = "ceph"
  repository       = "https://ceph.github.io/ceph-csi-charts"
  chart            = "ceph-csi-cephfs"
  version          = "3.11.0"
  namespace        = "ceph"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
