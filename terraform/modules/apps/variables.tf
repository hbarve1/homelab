variable "namespace" {
  description = "Kubernetes namespace to deploy all database modules into"
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

variable "image_pull_secret_name" {
  description = "Name of the image pull secret to use"
  type        = string
  default     = ""
}

variable "ingress_enabled" {
  description = "Enable ingress for the service"
  type        = bool
  default     = true
}

variable "ingress_host" {
  description = "Ingress host name"
  type        = string
  default     = "api-1.hbarve1.com"
}

variable "ingress_class_name" {
  description = "Ingress class name"
  type        = string
  default     = "nginx"
}

variable "replicas" {
  description = "Number of pod replicas"
  type        = number
  default     = 1
}

variable "environment" {
  description = "Deployment environment label"
  type        = string
  default     = "production"
}

variable "resources_requests_memory" {
  description = "Container memory request"
  type        = string
  default     = "64Mi"
}

variable "resources_requests_cpu" {
  description = "Container CPU request"
  type        = string
  default     = "50m"
}

variable "resources_limits_memory" {
  description = "Container memory limit"
  type        = string
  default     = "128Mi"
}

variable "resources_limits_cpu" {
  description = "Container CPU limit"
  type        = string
  default     = "200m"
}
