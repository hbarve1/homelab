auth:
  password: ${redis_password}

global:
  imageRegistry: docker.io

volumePermissions:
  enabled: true

master:
  persistence:
    enabled: true
    size: ${storage_size}
  image:
    registry: docker.io
    repository: bitnamilegacy/redis
    tag: "${redis_version}"
    pullPolicy: IfNotPresent

replica:
  persistence:
    enabled: true
    size: ${storage_size}
  image:
    registry: docker.io
    repository: bitnamilegacy/redis
    tag: "${redis_version}"
    pullPolicy: IfNotPresent
