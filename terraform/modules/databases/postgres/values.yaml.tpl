auth:
  username: ${postgres_user}
  password: ${postgres_password}
  database: ${postgres_db}

global:
  imageRegistry: docker.io
  storageClass: "openebs-hostpath"

primary:
  persistence:
    enabled: true
    size: ${storage_size}
    storageClass: "openebs-hostpath"
  image:
    registry: docker.io
    repository: bitnamilegacy/postgresql
    tag: "${postgres_version}"
    pullPolicy: IfNotPresent
