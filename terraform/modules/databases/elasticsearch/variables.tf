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
  description = "Bitnami Elasticsearch chart version"
  default     = "22.0.4"
}

variable "elasticsearch_password" {
  type        = string
  description = "Elasticsearch password for the elastic user"
  default     = "admin"
}

variable "storage_size" {
  type        = string
  description = "Persistent volume size"
  default     = "8Gi"
}
