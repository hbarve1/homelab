resource "kubernetes_namespace" "databases" {
  metadata {
    name = "databases"
  }
  # lifecycle {
  #   ignore_changes = [metadata[0].annotations, metadata[0].labels]
  # }
}

# resource "kubernetes_namespace" "neo4j" {
#   metadata {
#     name = "neo4j"
#   }
# }

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
  # lifecycle {
  #   ignore_changes = [metadata[0].annotations, metadata[0].labels]
  # }
}

resource "kubernetes_namespace" "automation" {
  metadata {
    name = "automation"
  }
  # lifecycle {
  #   ignore_changes = [metadata[0].annotations, metadata[0].labels]
  # }
}

resource "kubernetes_namespace" "networking" {
  metadata {
    name = "networking"
  }
  # lifecycle {
  #   ignore_changes = [metadata[0].annotations, metadata[0].labels]
  # }
}

resource "kubernetes_namespace" "storage" {
  metadata {
    name = "storage"
  }
  # lifecycle {
  #   ignore_changes = [metadata[0].annotations, metadata[0].labels]
  # }
}

resource "kubernetes_namespace" "serverless" {
  metadata {
    name = "serverless"
  }
  # lifecycle {
  #   ignore_changes = [metadata[0].annotations, metadata[0].labels]
  # }
}
