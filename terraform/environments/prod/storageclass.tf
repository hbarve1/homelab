resource "kubernetes_storage_class" "standard" {
  metadata {
    name = "standard"
  }
  # For MicroK8s (default):
  storage_provisioner  = "microk8s.io/hostpath"
  volume_binding_mode  = "WaitForFirstConsumer"
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
