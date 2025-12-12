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
  description = "Bitnami MongoDB chart version"
  default     = "18.1.10"
}

variable "mongodb_root_password" {
  type        = string
  description = "MongoDB root password"
}

variable "mongodb_database" {
  type        = string
  description = "Default database name"
  default     = "appdb"
}

variable "storage_size" {
  type        = string
  description = "Persistent volume size"
  default     = "8Gi"
}

variable "mongodb_version" {
  type        = string
  description = "MongoDB version"
  default     = "8"
}
