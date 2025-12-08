resource "kubernetes_storage_class" "standard" {
  metadata {
    name = "standard"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  # For MicroK8s (default):
  storage_provisioner  = "microk8s.io/hostpath"
  volume_binding_mode  = "WaitForFirstConsumer"
  reclaim_policy       = "Delete"
  allow_volume_expansion = true
  parameters = {}
}

# Storage class matching MicroK8s hostpath (for compatibility with existing PVs)
resource "kubernetes_storage_class" "microk8s_hostpath" {
  metadata {
    name = "microk8s-hostpath"
  }
  storage_provisioner  = "microk8s.io/hostpath"
  volume_binding_mode  = "WaitForFirstConsumer"  # MicroK8s default
  reclaim_policy       = "Delete"
  allow_volume_expansion = true
  parameters = {}
}

# Storage class with immediate binding for Harbor and other stateful services
# This binds PVCs immediately instead of waiting for pods to start
resource "kubernetes_storage_class" "immediate" {
  metadata {
    name = "immediate"
  }
  storage_provisioner  = "microk8s.io/hostpath"  # Use MicroK8s provisioner
  volume_binding_mode  = "Immediate"  # Bind immediately, don't wait for pod
  reclaim_policy       = "Delete"
  allow_volume_expansion = true
  parameters = {}
}

# ---
# For kind (Kubernetes IN Docker) clusters, use the following provisioner:
# resource "kubernetes_storage_class" "standard_kind" {
#   metadata {
#     name = "standard"
#   }
#   storage_provisioner  = "k8s.io/minikube-hostpath" # or "rancher.io/local-path" if using local-path-provisioner
#   volume_binding_mode  = "WaitForFirstConsumer"
#   reclaim_policy       = "Delete"
#   allow_volume_expansion = true
#   parameters = {}
# }
# Description: Uncomment and use this block for kind clusters with local-path-provisioner or minikube-hostpath.

# ---
# For original (bare-metal or cloud) Kubernetes with a dynamic provisioner, use the appropriate provisioner name:
# resource "kubernetes_storage_class" "standard_cloud" {
#   metadata {
#     name = "standard"
#   }
#   storage_provisioner  = "kubernetes.io/aws-ebs" # or "kubernetes.io/gce-pd", "kubernetes.io/azure-disk", etc.
#   volume_binding_mode  = "WaitForFirstConsumer"
#   reclaim_policy       = "Delete"
#   allow_volume_expansion = true
#   parameters = {
#     type = "gp2" # or the appropriate parameter for your cloud
#   }
# }
# Description: Uncomment and adjust this block for AWS, GCP, Azure, or other cloud environments.
