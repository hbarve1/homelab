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
  description = "Bitnami Postgres chart version"
  default     = "16.7.4"
}

variable "postgres_user" {
  type        = string
  description = "Postgres admin username"
  default     = "admin"
}

variable "postgres_password" {
  type        = string
  description = "Postgres admin password"
}

variable "postgres_db" {
  type        = string
  description = "Default database name"
  default     = "appdb"
}

variable "storage_size" {
  type        = string
  description = "Persistent volume size"
  default     = "10Gi"
}
