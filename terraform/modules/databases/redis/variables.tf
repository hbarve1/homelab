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
  default     = "18.5.0"
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
