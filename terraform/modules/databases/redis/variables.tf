variable "release_name" {
  type        = string
  description = "Helm release name"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace"
}

variable "chart_version" {
  type        = string
  description = "Bitnami Redis chart version"
  default     = "24.0.0"
}

variable "redis_password" {
  type        = string
  description = "Redis password"
}

variable "storage_size" {
  type        = string
  description = "Persistent volume size"
  default     = "8Gi"
}

variable "redis_version" {
  type        = string
  description = "Redis version tag (e.g., '6', '7', '8')"
  default     = "7"
}
