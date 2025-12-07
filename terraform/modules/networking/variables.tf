variable "namespace" {
  description = "Kubernetes namespace to deploy all database modules into"
  type        = string
}

# DNS module variables (optional)
variable "pihole_password" {
  description = "Pi-hole web interface password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "timezone" {
  description = "Timezone for DNS services"
  type        = string
  default     = "UTC"
}

variable "local_domain" {
  description = "Local domain for DNS services"
  type        = string
  default     = "homelab.local"
}

variable "router_ip" {
  description = "Router IP for conditional forwarding"
  type        = string
  default     = "192.168.1.1"
}

variable "enable_conditional_forwarding" {
  description = "Enable conditional forwarding for Pi-hole"
  type        = bool
  default     = true
}

variable "dns_service_type" {
  description = "Service type for DNS services (LoadBalancer or NodePort)"
  type        = string
  default     = "LoadBalancer"
}

variable "dns_ingress_enabled" {
  description = "Enable ingress for DNS web interface"
  type        = bool
  default     = false
}

variable "dns_ingress_host" {
  description = "Ingress host for DNS web interface"
  type        = string
  default     = "dns.homelab.local"
}
