# Docker Swarm Setup Guide

This guide will walk you through setting up a multi-machine Docker Swarm cluster for your homelab.

## Prerequisites

### Hardware Requirements
- **Manager Node**: 2+ CPU cores, 4GB+ RAM, 20GB+ storage
- **Worker Nodes**: 1+ CPU cores, 2GB+ RAM, 10GB+ storage
- **Network**: All nodes must be able to communicate with each other

### Software Requirements
- **Docker Engine**: 20.10+ on all nodes
- **Docker Compose**: 2.0+ on manager node
- **Operating System**: Ubuntu 20.04+ or macOS 10.15+

## Installation

### 1. Install Docker on All Nodes

#### Ubuntu/Debian
```bash
# Update package index
sudo apt update

# Install required packages
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker
```

#### macOS
```bash
# Install Docker Desktop
brew install --cask docker

# Or download from: https://www.docker.com/products/docker-desktop
```

### 2. Configure Firewall (Ubuntu)

```bash
# Allow Docker Swarm ports
sudo ufw allow 2376/tcp
sudo ufw allow 2377/tcp
sudo ufw allow 7946/tcp
sudo ufw allow 7946/udp
sudo ufw allow 4789/udp

# Allow application ports
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8080/tcp

# Enable firewall
sudo ufw enable
```

## Setup Process

### 1. Initialize Swarm on Manager Node

```bash
# Clone or copy the docker-swarm directory to your manager node
cd docker-swarm

# Make scripts executable
chmod +x scripts/*.sh

# Initialize the swarm
./scripts/init-swarm.sh
```

This script will:
- Check Docker installation
- Initialize Docker Swarm
- Create necessary secrets
- Set up overlay networks
- Label the manager node
- Display join commands for worker nodes

### 2. Join Worker Nodes

On each worker node:

```bash
# Copy the docker-swarm directory to the worker node
cd docker-swarm

# Make scripts executable
chmod +x scripts/*.sh

# Join the swarm (replace <manager-ip> with actual IP)
./scripts/join-worker.sh <manager-ip>
```

This script will:
- Check Docker installation
- Join the Docker Swarm cluster
- Label the worker node appropriately
- Display node information

### 3. Configure Environment

```bash
# Copy environment template
cp env.example .env

# Edit environment variables
nano .env
```

Key variables to configure:
- `DOMAIN`: Your domain name (e.g., `local` or `homelab.local`)
- `ACME_EMAIL`: Email for Let's Encrypt certificates
- `POSTGRES_PASSWORD`: Database password
- `REDIS_PASSWORD`: Redis password
- `MINIO_ROOT_PASSWORD`: MinIO password
- `GRAFANA_PASSWORD`: Grafana admin password

### 4. Deploy Services

```bash
# Deploy the complete stack
./scripts/deploy-stack.sh

# Or deploy with custom stack name
./scripts/deploy-stack.sh my-homelab
```

This script will:
- Validate environment configuration
- Create Docker secrets
- Deploy all services
- Wait for services to be ready
- Display access information

## Network Configuration

### Update Hosts File

Add the following to `/etc/hosts` on all machines that need to access the services:

```bash
# Replace 192.168.1.100 with your manager node IP
192.168.1.100 app.local
192.168.1.100 api.local
192.168.1.100 grafana.local
192.168.1.100 prometheus.local
192.168.1.100 kibana.local
192.168.1.100 minio.local
192.168.1.100 traefik.local
```

### DNS Configuration (Optional)

For automatic DNS resolution, you can set up a local DNS server or use a tool like `dnsmasq`:

```bash
# Install dnsmasq
sudo apt install dnsmasq

# Configure dnsmasq
echo "address=/.local/192.168.1.100" | sudo tee -a /etc/dnsmasq.conf

# Restart dnsmasq
sudo systemctl restart dnsmasq
```

## Service Management

### View Services
```bash
# List all services
docker service ls

# View service details
docker service ps <service-name>

# View service logs
docker service logs <service-name>
```

### Scale Services
```bash
# Scale web service to 5 replicas
docker service scale homelab_web=5

# Scale API service to 3 replicas
docker service scale homelab_api=3
```

### Update Services
```bash
# Update service image
docker service update --image nginx:latest homelab_web

# Update service with new environment variables
docker service update --env-add NEW_VAR=value homelab_api
```

### Remove Services
```bash
# Remove a specific service
docker service rm <service-name>

# Remove entire stack
docker stack rm homelab
```

## Monitoring and Logging

### Access Monitoring Dashboards

- **Grafana**: http://grafana.local (admin/password from secrets)
- **Prometheus**: http://prometheus.local
- **Traefik Dashboard**: http://traefik.local:8080

### View Logs

```bash
# View logs for all services
docker service logs homelab_web
docker service logs homelab_api
docker service logs homelab_postgres

# Follow logs in real-time
docker service logs -f homelab_web
```

### Health Checks

```bash
# Check service health
curl http://app.local/health
curl http://api.local/health

# Check Prometheus targets
curl http://prometheus.local/api/v1/targets
```

## Backup and Recovery

### Backup Volumes
```bash
# Run backup script
./scripts/backup-volumes.sh

# Manual backup
docker run --rm -v postgres_data:/data -v $(pwd)/backups:/backup alpine tar czf /backup/postgres-$(date +%Y%m%d).tar.gz -C /data .
```

### Restore Volumes
```bash
# Restore from backup
docker run --rm -v postgres_data:/data -v $(pwd)/backups:/backup alpine tar xzf /backup/postgres-20240101.tar.gz -C /data
```

## Troubleshooting

### Common Issues

#### Services Not Starting
```bash
# Check service status
docker service ps <service-name>

# Check node resources
docker node ls
docker node inspect <node-id>

# Check logs
docker service logs <service-name>
```

#### Network Issues
```bash
# Check networks
docker network ls
docker network inspect <network-name>

# Test connectivity
docker run --rm --network <network-name> alpine ping <service-name>
```

#### Secret Issues
```bash
# List secrets
docker secret ls

# Inspect secret
docker secret inspect <secret-name>

# Recreate secret
echo "new-password" | docker secret create <secret-name> -
```

### Performance Tuning

#### Resource Limits
```yaml
# In docker-compose.yml
deploy:
  resources:
    limits:
      cpus: '0.5'
      memory: 512M
    reservations:
      cpus: '0.25'
      memory: 256M
```

#### Node Constraints
```yaml
# Deploy to specific nodes
deploy:
  placement:
    constraints:
      - node.role == manager
      - node.labels.database == true
```

## Security Best Practices

1. **Use Docker Secrets**: Store sensitive data in Docker secrets
2. **Enable TLS**: Use Let's Encrypt certificates for HTTPS
3. **Network Segmentation**: Use separate networks for different services
4. **Regular Updates**: Keep Docker and images updated
5. **Access Control**: Limit access to management interfaces
6. **Monitoring**: Monitor for security events and anomalies

## Next Steps

1. **Add More Services**: Extend the stack with additional services
2. **Implement CI/CD**: Set up automated deployments
3. **Add Monitoring**: Configure alerts and notifications
4. **Backup Strategy**: Implement automated backups
5. **Security Hardening**: Apply additional security measures

## Support

For issues and questions:
- Check the troubleshooting section above
- Review Docker Swarm documentation
- Check service logs for error messages
- Ensure all prerequisites are met

---

**Happy Homelabbing! 🐳**
