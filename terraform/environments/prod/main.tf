terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.36.0"
    }
    # kubectl = {
    #   source  = "gavinbunney/kubectl"
    #   version = ">= 1.14.0"
    # }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

# provider "kubernetes" {
#   config_path = "~/codes/homelab/.kube/hbarve1-k8s-production-cluster-1-kubeconfig.yaml"
# }

# provider "helm" {
#   kubernetes {
#     config_path = "~/codes/homelab/.kube/hbarve1-k8s-production-cluster-1-kubeconfig.yaml"
#   }
# }

module "databases" {
  source = "../../modules/databases"
  namespace = kubernetes_namespace.databases.metadata[0].name
}

module "networking" {
  source = "../../modules/networking"
  namespace = kubernetes_namespace.networking.metadata[0].name
  
  # Enable Cloudflare Tunnel
  # Using token-based authentication (configured in Cloudflare dashboard)
  cloudflare_tunnel_enabled = true
  cloudflare_tunnel_token = var.cloudflare_tunnel_token
  cloudflare_tunnel_replicas = 1
}

module serverless {
  source    = "../../modules/serverless"
  namespace = kubernetes_namespace.serverless.metadata[0].name
}

module "automation" {
  source    = "../../modules/automation"
  namespace = kubernetes_namespace.automation.metadata[0].name
}

module "emulators" {
  source    = "../../modules/emulators"
  namespace = kubernetes_namespace.emulators.metadata[0].name
}

module "storage" {
  source    = "../../modules/storage"
  namespace = kubernetes_namespace.storage.metadata[0].name
}

module "apps" {
  source    = "../../modules/apps"
  namespace = kubernetes_namespace.apps.metadata[0].name

  github_username     = var.github_username
  github_pat          = var.github_pat
  ghcr_secret_name    = var.ghcr_secret_name
}

# module "simple_api_server" {
#   source = "../../modules/apps/simple-api-server"
  
#   namespace      = kubernetes_namespace.apps.metadata[0].name
#   # GitHub Container Registry configuration
#   image_registry = "ghcr.io"
#   image_name     = "your-username/your-repo-name"  # e.g., "hbarve1/simple-api-server"
#   image_tag      = "latest"
#   image_pull_secret_name = "ghcr-secret"  # Secret created via: kubectl create secret docker-registry ghcr-secret --docker-server=ghcr.io --docker-username=USERNAME --docker-password=PAT --namespace=apps
  
#   ingress_enabled = true
#   ingress_host    = "api-1.hbarve1.com"
  
#   replicas = 1
# }

module "gitea" {
  source = "../../modules/development/gitea"
}

module "harbor" {
  source = "../../modules/development/harbor"
}

# resource "helm_release" "neo4j" {
#   name       = "neo4j"
#   namespace  = kubernetes_namespace.neo4j.metadata[0].name
#   repository = "oci://registry-1.docker.io/bitnamicharts"
#   chart      = "neo4j"
#   version    = "0.4.3"

#   values = [
#     yamlencode({
#       acceptLicenseAgreement = "yes"
#       password              = var.neo4j_password
#       username              = var.neo4j_username
#       database              = var.neo4j_db
#       resources = {
#         requests = {
#           memory = "2Gi"
#           cpu    = "1"
#         }
#       }
#       persistence = {
#         size = var.neo4j_storage_size
#       }
#       service = {
#         type = "LoadBalancer"
#       }
#       # Add other root-level settings as needed
#     })
#   ]
# }

# module "dgraph" {
#   source = "../../modules/databases/dgraph"
# }

# resource "kubernetes_namespace" "tigergraph" {
#   metadata {
#     name = "tigergraph"
#   }
# }

# resource "helm_release" "tigergraph" {
#   name             = "tigergraph"
#   namespace        = kubernetes_namespace.tigergraph.metadata[0].name
#   repository       = "https://tigergraph-charts.s3.amazonaws.com/"
#   chart            = "tigergraph"
#   version          = "1.5.0" # Use the latest stable version if needed
#   create_namespace = false

#   values = [
#     yamlencode({
#       storage = {
#         class = "standard"
#         size  = "100Gi"
#       }
#       service = {
#         type = "LoadBalancer"
#       }
#       # Add more TigerGraph-specific values as needed
#     })
#   ]
# }
