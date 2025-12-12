variable "namespace" {
  description = "Kubernetes namespace for apps"
  type        = string
}

variable "ghcr_secret_name" {
  description = "Name of the GHCR image pull secret"
  type        = string
  default     = "ghcr-secret"
}

variable "github_username" {
  description = "GitHub username for GHCR authentication"
  type        = string
}

variable "github_pat" {
  description = "GitHub PAT with read:packages for GHCR"
  type        = string
  sensitive   = true
}
