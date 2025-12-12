tunnel: ${tunnel_id}
credentials-file: /etc/cloudflared/credentials.json

# Ingress rules - route traffic to your Kubernetes services
ingress:
%{ if length(http_routes) > 0 ~}
%{ for route in http_routes ~}
  - hostname: ${route.hostname}
    service: ${route.service}
%{ endfor ~}
%{ else ~}
  # Default: route all HTTP traffic to ingress controller
  # Ingress controller will handle hostname-based routing
  - service: http://${ingress_host}:${ingress_port}
%{ endif ~}
%{ if length(tcp_routes) > 0 ~}
%{ for route in tcp_routes ~}
  - hostname: ${route.hostname}
    service: tcp://${route.service}
%{ endfor ~}
%{ endif ~}
  # Catch-all rule (must be last) - returns 404 for unmatched HTTP routes
  - service: http_status:404
