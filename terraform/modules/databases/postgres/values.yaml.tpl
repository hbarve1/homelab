auth:
  username: ${postgres_user}
  password: ${postgres_password}
  database: ${postgres_db}

global:
  imageRegistry: docker.io

primary:
  persistence:
    enabled: true
    size: ${storage_size}
  image:
    registry: docker.io
    repository: bitnamilegacy/postgresql
    tag: "16"
    pullPolicy: IfNotPresent
