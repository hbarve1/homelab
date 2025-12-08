tunnel: ${tunnel_id}
credentials-file: /etc/cloudflared/credentials.json

# Ingress rules - route traffic to your Kubernetes ingress controller
ingress:
%{ if length(routes) > 0 ~}
%{ for route in routes ~}
  - hostname: ${route.hostname}
    service: ${route.service}
%{ endfor ~}
%{ else ~}
  # Default: route all traffic to ingress controller
  # Ingress controller will handle hostname-based routing
  - service: http://${ingress_host}:${ingress_port}
%{ endif ~}
  # Catch-all rule (must be last) - returns 404 for unmatched routes
  - service: http_status:404

