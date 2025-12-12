variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
}

variable "image_registry" {
  description = "Docker registry host"
  type        = string
  default     = "ghcr.io"
}

variable "image_name" {
  description = "Docker image name (without registry)"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}
variable "environment" {
  description = "Environment name (development, staging, production)"
  type        = string
  default     = "development"
}

variable "image_pull_secret_name" {
  description = "Image pull secret name"
  type        = string
  default     = ""
}

variable "ingress_hosts" {
  description = "List of ingress hostnames"
  type        = list(string)
  default     = []
}

