neo4j:
  password: ${neo4j_password}
  database: ${neo4j_db}
  advertisedHost: ${advertised_host}
persistence:
  size: ${storage_size}
service:
  type: LoadBalancer
  ports:
    http: 7474
    bolt: 7687
  annotations: {}
