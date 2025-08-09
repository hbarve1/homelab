resource "helm_release" "openstack_swift" {
  name             = "openstack-swift"
  repository       = "https://openstack-helm.github.io/openstack-helm"
  chart            = "swift"
  version          = "0.3.0"
  namespace        = "openstack-swift"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
