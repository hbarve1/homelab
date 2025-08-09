resource "kubernetes_namespace" "databases" {
  metadata {
    name = "databases"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "automation" {
  metadata {
    name = "automation"
  }
}

resource "kubernetes_namespace" "networking" {
  metadata {
    name = "networking"
  }
}

resource "kubernetes_namespace" "storage" {
  metadata {
    name = "storage"
  }
}

resource "kubernetes_namespace" "backup" {
  metadata {
    name = "backup"
  }
}

resource "kubernetes_namespace" "serverless" {
  metadata {
    name = "serverless"
  }
}

resource "kubernetes_namespace" "openfaas" {
  metadata {
    name = "openfaas"
  }
}

resource "kubernetes_namespace" "openfaas_fn" {
  metadata {
    name = "openfaas-fn"
  }
}

resource "kubernetes_namespace" "security" {
  metadata {
    name = "security"
  }
}

resource "kubernetes_namespace" "analytics" {
  metadata {
    name = "analytics"
  }
}