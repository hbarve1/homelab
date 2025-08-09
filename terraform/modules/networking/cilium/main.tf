resource "helm_release" "cilium" {
  name             = "cilium"
  repository       = "https://helm.cilium.io/"
  chart            = "cilium"
  version          = "1.15.5"
  namespace        = "kube-system"
  create_namespace = false

  values = [
    file("${path.module}/values.yaml")
  ]

  # ---
  # Workaround for Docker Desktop/macOS: disable eBPF features that require /sys/fs/bpf as a shared mount
  set {
    name  = "kubeProxyReplacement"
    value = "disabled"
  }
  set {
    name  = "enableBPFMasquerade"
    value = "false"
  }
  # Description: The above disables eBPF kube-proxy replacement and BPF masquerading, allowing Cilium to run in legacy mode on Docker Desktop/macOS. Most advanced features will not work.

  # ---
  # For original (bare-metal or cloud) Kubernetes clusters, comment out the above set blocks to enable full eBPF support.
  # Description: On a real Linux host with a shared /sys/fs/bpf mount, you can use the default Cilium settings for full functionality.
}
