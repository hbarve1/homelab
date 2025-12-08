# Quick Start - Simple API Server

## 1. Build and Push Image

```bash
cd apps/simple-api-server
./build-and-push.sh
```

## 2. Deploy with Terraform

```bash
cd terraform/environments/prod
terraform init
terraform apply
```

## 3. Test Locally

```bash
kubectl port-forward -n apps svc/simple-api-server 8080:80
curl http://localhost:8080/health
```

## 4. Access via Cloudflare

Once Cloudflare tunnel is configured:
- DNS: `api-1` → `<tunnel-id>.cfargotunnel.com`
- Access: `https://api-1.hbarve1.com`

## API Endpoints

- `GET /` - API info
- `GET /health` - Health check
- `GET /api/info` - Server info
- `GET /api/echo` - Echo GET
- `POST /api/echo` - Echo POST
