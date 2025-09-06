# Docker Swarm Best Practices

This document outlines best practices for running a production-ready Docker Swarm cluster in your homelab.

## Architecture Best Practices

### 1. Node Planning

#### Manager Nodes
- **Minimum**: 3 manager nodes for high availability
- **Resources**: 2+ CPU cores, 4GB+ RAM
- **Role**: Cluster management, service orchestration
- **Placement**: Distribute across different physical machines

#### Worker Nodes
- **Resources**: Based on workload requirements
- **Specialization**: Label nodes for specific workloads
- **Scaling**: Plan for horizontal scaling

```bash
# Label nodes for specific roles
docker node update --label-add database=true <node-id>
docker node update --label-add storage=true <node-id>
docker node update --label-add compute=true <node-id>
```

### 2. Network Design

#### Network Segmentation
```yaml
# Separate networks for different tiers
networks:
  frontend:    # Public-facing services
  backend:     # Internal services
  database:    # Database services
  monitoring:  # Monitoring services
  logging:     # Logging services
  storage:     # Storage services
```

#### Security Considerations
- Enable network encryption: `encrypted: "true"`
- Use overlay networks for service isolation
- Implement network policies where possible

### 3. Service Design

#### Stateless Services
- Design services to be stateless
- Store state in external databases or volumes
- Use environment variables for configuration

#### Health Checks
```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

#### Resource Limits
```yaml
deploy:
  resources:
    limits:
      cpus: '0.5'
      memory: 512M
    reservations:
      cpus: '0.25'
      memory: 256M
```

## Security Best Practices

### 1. Secrets Management

#### Use Docker Secrets
```bash
# Create secrets
echo "password123" | docker secret create db_password -
echo "api-key-here" | docker secret create api_key -
```

#### Never Store Secrets in Images
```yaml
# Good: Use secrets
environment:
  DB_PASSWORD_FILE: /run/secrets/db_password
secrets:
  - db_password

# Bad: Hardcoded secrets
environment:
  DB_PASSWORD: password123
```

### 2. Image Security

#### Use Official Images
- Prefer official images from Docker Hub
- Use specific version tags, not `latest`
- Regularly update base images

#### Image Scanning
```bash
# Scan images for vulnerabilities
docker scan nginx:alpine
docker scan postgres:15-alpine
```

#### Multi-stage Builds
```dockerfile
# Use multi-stage builds to reduce image size
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

### 3. Network Security

#### TLS/SSL
- Use Let's Encrypt for automatic certificates
- Enable HTTPS for all public services
- Use internal networks for service communication

#### Firewall Rules
```bash
# Allow only necessary ports
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw allow 2377/tcp  # Swarm management
sudo ufw deny 2376/tcp   # Docker daemon (if not needed)
```

## Monitoring and Observability

### 1. Metrics Collection

#### Prometheus Configuration
```yaml
# Comprehensive metrics collection
scrape_configs:
  - job_name: 'docker-swarm-nodes'
    static_configs:
      - targets: ['node-exporter:9100']
  
  - job_name: 'docker-swarm-services'
    static_configs:
      - targets: ['cadvisor:8080']
  
  - job_name: 'application-metrics'
    static_configs:
      - targets: ['app:8080']
```

#### Custom Metrics
```javascript
// Expose custom application metrics
const prometheus = require('prom-client');

const httpRequestDuration = new prometheus.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status']
});
```

### 2. Logging Strategy

#### Centralized Logging
```yaml
# Use ELK stack for centralized logging
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

#### Log Aggregation
```yaml
# Send logs to centralized system
logstash:
  image: docker.elastic.co/logstash/logstash:8.11.0
  volumes:
    - ./configs/logstash/logstash.conf:/usr/share/logstash/pipeline/logstash.conf
```

### 3. Alerting

#### Grafana Alerts
- Set up alerts for service downtime
- Monitor resource usage
- Alert on error rates

#### Health Checks
```yaml
# Comprehensive health checks
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

## Performance Optimization

### 1. Resource Management

#### CPU and Memory Limits
```yaml
deploy:
  resources:
    limits:
      cpus: '0.5'
      memory: 512M
    reservations:
      cpus: '0.25'
      memory: 256M
```

#### Node Affinity
```yaml
deploy:
  placement:
    constraints:
      - node.role == worker
      - node.labels.compute == true
```

### 2. Storage Optimization

#### Volume Management
```yaml
volumes:
  postgres_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /opt/docker-volumes/postgres
```

#### Backup Strategy
```bash
# Automated backups
#!/bin/bash
docker run --rm -v postgres_data:/data -v $(pwd)/backups:/backup alpine \
  tar czf /backup/postgres-$(date +%Y%m%d).tar.gz -C /data .
```

### 3. Network Performance

#### Load Balancing
```yaml
# Use multiple replicas for load balancing
deploy:
  replicas: 3
  update_config:
    parallelism: 1
    delay: 10s
    failure_action: rollback
```

#### Service Discovery
```yaml
# Use service names for internal communication
environment:
  DATABASE_URL: postgresql://user:pass@postgres:5432/db
  REDIS_URL: redis://redis:6379
```

## Deployment Best Practices

### 1. Rolling Updates

#### Zero-Downtime Deployments
```yaml
deploy:
  update_config:
    parallelism: 1
    delay: 10s
    failure_action: rollback
    order: start-first
```

#### Blue-Green Deployments
```bash
# Deploy new version alongside old
docker service update --image app:v2.0 homelab_web

# Rollback if needed
docker service rollback homelab_web
```

### 2. Configuration Management

#### Environment-Specific Configs
```yaml
# Use different configs for different environments
configs:
  app_config:
    file: ./configs/${ENVIRONMENT}/app.conf
```

#### Configuration Validation
```bash
# Validate configuration before deployment
docker-compose config
docker stack deploy --compose-file docker-compose.yml --dry-run
```

### 3. Service Dependencies

#### Health Check Dependencies
```yaml
# Wait for dependencies to be healthy
depends_on:
  postgres:
    condition: service_healthy
  redis:
    condition: service_healthy
```

## Backup and Disaster Recovery

### 1. Data Backup

#### Automated Backups
```bash
#!/bin/bash
# Daily backup script
DATE=$(date +%Y%m%d)
BACKUP_DIR="/opt/backups/$DATE"

mkdir -p "$BACKUP_DIR"

# Backup databases
docker run --rm -v postgres_data:/data -v "$BACKUP_DIR":/backup alpine \
  tar czf /backup/postgres.tar.gz -C /data .

# Backup configurations
tar czf "$BACKUP_DIR/configs.tar.gz" configs/

# Cleanup old backups
find /opt/backups -type d -mtime +30 -exec rm -rf {} +
```

#### Volume Snapshots
```bash
# Create volume snapshots
docker run --rm -v postgres_data:/data -v $(pwd):/backup alpine \
  tar czf /backup/postgres-snapshot.tar.gz -C /data .
```

### 2. Disaster Recovery

#### Cluster Recovery
```bash
# Rebuild cluster from backup
docker swarm init --advertise-addr <manager-ip>
docker stack deploy -c docker-compose.yml homelab
```

#### Data Recovery
```bash
# Restore from backup
docker run --rm -v postgres_data:/data -v $(pwd)/backups:/backup alpine \
  tar xzf /backup/postgres-20240101.tar.gz -C /data
```

## Maintenance and Updates

### 1. Regular Maintenance

#### System Updates
```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Update Docker
sudo apt install docker-ce docker-ce-cli containerd.io
```

#### Image Updates
```bash
# Update service images
docker service update --image nginx:latest homelab_web
docker service update --image postgres:15-alpine homelab_postgres
```

### 2. Monitoring Maintenance

#### Log Rotation
```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

#### Metrics Cleanup
```yaml
# Prometheus retention
command:
  - '--storage.tsdb.retention.time=30d'
  - '--storage.tsdb.retention.size=10GB'
```

## Troubleshooting Best Practices

### 1. Log Analysis

#### Centralized Logging
- Use ELK stack for log aggregation
- Implement structured logging
- Set up log alerts

#### Debug Mode
```yaml
# Enable debug logging
environment:
  LOG_LEVEL: debug
  DEBUG: true
```

### 2. Performance Monitoring

#### Resource Monitoring
- Monitor CPU, memory, and disk usage
- Set up alerts for resource thresholds
- Use Grafana dashboards for visualization

#### Service Health
- Implement comprehensive health checks
- Monitor service response times
- Track error rates and availability

### 3. Incident Response

#### Runbooks
- Document common issues and solutions
- Create escalation procedures
- Maintain contact information

#### Post-Incident Reviews
- Analyze root causes
- Update procedures and documentation
- Implement preventive measures

---

Following these best practices will help you maintain a robust, secure, and performant Docker Swarm cluster in your homelab environment.
