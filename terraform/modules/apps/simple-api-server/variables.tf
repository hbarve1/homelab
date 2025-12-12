variable "namespace" {
  description = "Kubernetes namespace for the API server"
  type        = string
}

variable "image_registry" {
  description = "Docker registry host. For GitHub Container Registry use 'ghcr.io', for local registry use 'registry.container-registry.svc.cluster.local:5000'"
  type        = string
  default     = "ghcr.io"
}

variable "image_name" {
  description = "Docker image name (without registry). For GitHub: 'username/repo-name'"
  type        = string
  default     = ""
}

variable "image_pull_secret_name" {
  description = "Name of the Kubernetes secret containing registry credentials (for private images)"
  type        = string
  default     = ""
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "environment" {
  description = "Environment name (development, staging, production)"
  type        = string
  default     = "production"
}

variable "ingress_enabled" {
  description = "Enable ingress for the API server"
  type        = bool
  default     = true
}

variable "ingress_hosts" {
  description = "List of ingress hostnames (e.g., [\"api-1.hbarve1.com\", \"api-test.instanews.app\"])"
  type        = list(string)
  default     = ["api-1.hbarve1.com"]
}

variable "ingress_class_name" {
  description = "Ingress class name"
  type        = string
  default     = "nginx"
}

variable "resources_requests_memory" {
  description = "Memory request"
  type        = string
  default     = "64Mi"
}

variable "resources_requests_cpu" {
  description = "CPU request"
  type        = string
  default     = "50m"
}

variable "resources_limits_memory" {
  description = "Memory limit"
  type        = string
  default     = "128Mi"
}

variable "resources_limits_cpu" {
  description = "CPU limit"
  type        = string
  default     = "200m"
}

