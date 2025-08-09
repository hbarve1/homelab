apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: neo4j-http
  namespace: ${namespace}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
spec:
  ingressClassName: nginx
  rules:
    - host: ${neo4j_host}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: ${neo4j_service_name}
                port:
                  number: 7474
          - path: /bolt
            pathType: Prefix
            backend:
              service:
                name: ${neo4j_service_name}
                port:
                  number: 7687