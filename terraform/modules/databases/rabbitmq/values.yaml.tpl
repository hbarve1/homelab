auth:
  password: ${rabbitmq_password}

persistence:
  enabled: true
  size: ${storage_size}

readinessProbe:
  enabled: true
  initialDelaySeconds: 60
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 10
