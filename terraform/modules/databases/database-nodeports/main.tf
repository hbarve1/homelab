# NodePort services for databases to expose via Cloudflare Tunnel
# This is more reliable than direct TCP routing for database connections

# PostgreSQL 16 NodePort
resource "kubernetes_service_v1" "postgres_16_nodeport" {
  metadata {
    name      = "postgres-16-postgresql-nodeport"
    namespace = "databases"
    labels = {
      app = "postgres-16-nodeport"
    }
  }

  spec {
    type = "NodePort"

    selector = {
      "app.kubernetes.io/component" = "primary"
      "app.kubernetes.io/instance" = "postgres-16"
      "app.kubernetes.io/name"     = "postgresql"
    }

    port {
      name        = "postgresql"
      port        = 5432
      target_port = 5432
      protocol    = "TCP"
      node_port   = 30016
    }
  }
}

# PostgreSQL 17 NodePort
resource "kubernetes_service_v1" "postgres_17_nodeport" {
  metadata {
    name      = "postgres-17-postgresql-nodeport"
    namespace = "databases"
    labels = {
      app = "postgres-17-nodeport"
    }
  }

  spec {
    type = "NodePort"

    selector = {
      "app.kubernetes.io/component" = "primary"
      "app.kubernetes.io/instance" = "postgres-17"
      "app.kubernetes.io/name"     = "postgresql"
    }

    port {
      name        = "postgresql"
      port        = 5432
      target_port = 5432
      protocol    = "TCP"
      node_port   = 30017
    }
  }
}

# PostgreSQL 18 NodePort
resource "kubernetes_service_v1" "postgres_18_nodeport" {
  metadata {
    name      = "postgres-18-postgresql-nodeport"
    namespace = "databases"
    labels = {
      app = "postgres-18-nodeport"
    }
  }

  spec {
    type = "NodePort"

    selector = {
      "app.kubernetes.io/component" = "primary"
      "app.kubernetes.io/instance" = "postgres-18"
      "app.kubernetes.io/name"     = "postgresql"
    }

    port {
      name        = "postgresql"
      port        = 5432
      target_port = 5432
      protocol    = "TCP"
      node_port   = 30018
    }
  }
}

