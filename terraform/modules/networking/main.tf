// Networking and ingress modules
module "nginx-ingress" {
  source   = "../networking/nginx-ingress"
  namespace = "ingress-nginx"
}

# module "istiod" {
#   source = "../networking/istio"
# }

// Local DNS - Pi-hole
module "pihole" {
  source    = "./pihole"
  namespace = var.namespace
  
  web_password                  = var.pihole_password
  timezone                      = var.timezone
  local_domain                  = var.local_domain
  router_ip                     = var.router_ip
  enable_conditional_forwarding = var.enable_conditional_forwarding
  service_type                  = var.dns_service_type
  ingress_enabled               = var.dns_ingress_enabled
  ingress_host                  = var.dns_ingress_host
}

// Ingress resources for HTTP services
module "ingress_services" {
  source = "./ingress-services"
}

// Cloudflare Tunnel - Multiple subdomains through single tunnel
module "cloudflare_tunnel" {
  count = var.cloudflare_tunnel_enabled ? 1 : 0
  
  source = "./cloudflare-tunnel"
  
  namespace              = var.cloudflare_tunnel_namespace
  tunnel_id              = var.cloudflare_tunnel_id
  tunnel_credentials_json = var.cloudflare_tunnel_credentials_json
  tunnel_token           = var.cloudflare_tunnel_token
  
  # HTTP routes via ingress controller
  http_routes = [
    {
      hostname = "gitea.hbarve1.com"
      service  = "http://nginx-ingress-ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "harbor.hbarve1.com"
      service  = "http://nginx-ingress-ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "grafana.hbarve1.com"
      service  = "http://nginx-ingress-ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "prometheus.hbarve1.com"
      service  = "http://nginx-ingress-ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "loki.hbarve1.com"
      service  = "http://nginx-ingress-ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "tempo.hbarve1.com"
      service  = "http://nginx-ingress-ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "faas.hbarve1.com"
      service  = "http://nginx-ingress-ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "minio.hbarve1.com"
      service  = "http://nginx-ingress-ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "n8n.hbarve1.com"
      service  = "http://nginx-ingress-ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "pihole.hbarve1.com"
      service  = "http://nginx-ingress-ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "k8s.hbarve1.com"
      service  = "http://nginx-ingress-ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "cloud.hbarve1.com"
      service  = "http://nginx-ingress-ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
    }
  ]
  
  # TCP routes for databases (using NodePort services for better reliability)
  tcp_routes = [
    # PostgreSQL - using NodePort services
    {
      hostname = "postgres16.hbarve1.com"
      service  = "postgres-16-postgresql-nodeport.databases.svc.cluster.local:5432"
    },
    {
      hostname = "postgres17.hbarve1.com"
      service  = "postgres-17-postgresql-nodeport.databases.svc.cluster.local:5432"
    },
    {
      hostname = "postgres18.hbarve1.com"
      service  = "postgres-18-postgresql-nodeport.databases.svc.cluster.local:5432"
    },
    # MySQL
    {
      hostname = "mysql1.hbarve1.com"
      service  = "mysql-1-dev.databases.svc.cluster.local:3306"
    },
    {
      hostname = "mysql2.hbarve1.com"
      service  = "mysql-2-dev.databases.svc.cluster.local:3306"
    },
    {
      hostname = "mysql5.hbarve1.com"
      service  = "mysql-5.databases.svc.cluster.local:3306"
    },
    {
      hostname = "mysql8.hbarve1.com"
      service  = "mysql-8.databases.svc.cluster.local:3306"
    },
    {
      hostname = "mysql9.hbarve1.com"
      service  = "mysql-9.databases.svc.cluster.local:3306"
    },
    # MongoDB
    {
      hostname = "mongo.hbarve1.com"
      service  = "mongodb.databases.svc.cluster.local:27017"
    },
    # Redis
    {
      hostname = "redis6.hbarve1.com"
      service  = "redis-6-master.databases.svc.cluster.local:6379"
    },
    {
      hostname = "redis7.hbarve1.com"
      service  = "redis-7-master.databases.svc.cluster.local:6379"
    },
    {
      hostname = "redis8.hbarve1.com"
      service  = "redis-8-master.databases.svc.cluster.local:6379"
    },
    {
      hostname = "redis-dev.hbarve1.com"
      service  = "redis-dev-master.databases.svc.cluster.local:6379"
    },
    # Qdrant
    {
      hostname = "qdrant.hbarve1.com"
      service  = "qdrant.databases.svc.cluster.local:6333"
    },
    # Dgraph
    {
      hostname = "dgraph-alpha.hbarve1.com"
      service  = "dgraph-dgraph-alpha.databases.svc.cluster.local:9080"
    },
    # Gitea databases
    {
      hostname = "gitea-postgres.hbarve1.com"
      service  = "gitea-postgresql-ha-pgpool.gitea.svc.cluster.local:5432"
    },
    {
      hostname = "gitea-valkey.hbarve1.com"
      service  = "gitea-valkey-cluster.gitea.svc.cluster.local:6379"
    },
    # Harbor databases
    {
      hostname = "harbor-postgres.hbarve1.com"
      service  = "harbor-database.harbor.svc.cluster.local:5432"
    },
    {
      hostname = "harbor-redis.hbarve1.com"
      service  = "harbor-redis.harbor.svc.cluster.local:6379"
    }
  ]
  
  # High availability: Multiple replicas across nodes
  replicas = var.cloudflare_tunnel_replicas
}

# Run this on original k8s cluster
# module "cilium" {
#   source = "../networking/cilium"
# }

# module "haproxy" {
#   source = "../../modules/network/haproxy"
# }

# module "envoy" {
#   source = "../../modules/network/envoy"
# }

# module "metallb" {
#   source = "../../modules/network/metallb"
# }

# module "calico" {
#   source = "../../modules/network/calico"
# }

# module "flannel" {
#   source = "../../modules/network/flannel"
# }

# module "harbor" {
#   source = "../../modules/development/harbor"
# }
