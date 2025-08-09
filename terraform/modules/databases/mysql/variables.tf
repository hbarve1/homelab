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
  description = "Bitnami MySQL chart version"
  default     = "9.19.1"
}

variable "mysql_root_password" {
  type        = string
  description = "MySQL root password"
}

variable "mysql_database" {
  type        = string
  description = "Default database name"
  default     = "appdb"
}

variable "storage_size" {
  type        = string
  description = "Persistent volume size"
  default     = "8Gi"
}
