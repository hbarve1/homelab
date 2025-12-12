variable "namespace" {
  description = "Kubernetes namespace for Cloudflare Tunnel"
  type        = string
  default     = "cloudflare-tunnel"
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}

variable "tunnel_id" {
  description = "Cloudflare Tunnel ID (optional if using token)"
  type        = string
  default     = ""
}

variable "tunnel_credentials_json" {
  description = "Cloudflare Tunnel credentials JSON (deprecated - use tunnel_token instead)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "tunnel_token" {
  description = "Cloudflare Tunnel token (from dashboard - newer method)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ingress_host" {
  description = "Ingress controller hostname (for routing to ingress)"
  type        = string
  default     = "nginx-ingress-controller.ingress-nginx.svc.cluster.local"
}

variable "ingress_port" {
  description = "Ingress controller port"
  type        = number
  default     = 80
}

variable "ingress_service" {
  description = "Ingress service name"
  type        = string
  default     = "nginx-ingress-controller"
}

variable "ingress_namespace" {
  description = "Ingress namespace"
  type        = string
  default     = "ingress-nginx"
}

variable "routes" {
  description = "List of routes to configure. Each route should have hostname and service. If empty, all traffic routes to ingress controller which handles hostname-based routing. DEPRECATED: Use http_routes instead."
  type = list(object({
    hostname = string
    service  = string  # e.g., "http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80"
  }))
  default = []
}

variable "http_routes" {
  description = "List of HTTP routes to configure. Each route should have hostname and service. Routes to ingress controller if not specified."
  type = list(object({
    hostname = string
    service  = string  # e.g., "http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80"
  }))
  default = []
}

variable "tcp_routes" {
  description = "List of TCP routes for database and other TCP services. Each route should have hostname and service (host:port)."
  type = list(object({
    hostname = string
    service  = string  # e.g., "postgres-15-postgresql.databases.svc.cluster.local:5432"
  }))
  default = []
}

variable "subdomains" {
  description = "List of subdomains to route through tunnel. All will route to ingress controller. Alternative to specifying individual routes. Requires 'domain' variable."
  type        = list(string)
  default     = []
}

variable "domain" {
  description = "Base domain for subdomains (e.g., 'yourdomain.com'). Required if using 'subdomains' variable."
  type        = string
  default     = ""
}

variable "image_repository" {
  description = "Cloudflared Docker image repository"
  type        = string
  default     = "cloudflare/cloudflared"
}

variable "image_tag" {
  description = "Cloudflared Docker image tag"
  type        = string
  default     = "latest"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 1
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

