auth:
  password: ${elasticsearch_password}

volumeClaimTemplate:
  accessModes: [ "ReadWriteOnce" ]
  resources:
    requests:
      storage: ${storage_size}
