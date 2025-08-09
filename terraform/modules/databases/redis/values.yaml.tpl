auth:
  password: ${redis_password}

master:
  persistence:
    enabled: true
    size: ${storage_size}
