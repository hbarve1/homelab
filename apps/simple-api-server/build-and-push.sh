#!/bin/bash
# Build and push Simple API Server to MicroK8s registry

set -e

# Get node IP (for external Docker push)
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}' 2>/dev/null || echo "192.168.31.85")
REGISTRY_EXTERNAL="${NODE_IP}:32000"  # For Docker push (external)
REGISTRY_INTERNAL="registry.container-registry.svc.cluster.local:5000"  # For Kubernetes (internal)

IMAGE_NAME="simple-api-server"
IMAGE_TAG="${1:-latest}"

echo "========================================="
echo "Building and Pushing Simple API Server"
echo "========================================="
echo ""
echo "External Registry (for Docker push): ${REGISTRY_EXTERNAL}"
echo "Internal Registry (for Kubernetes):  ${REGISTRY_INTERNAL}"
echo "Image: ${IMAGE_NAME}:${IMAGE_TAG}"
echo ""

# Navigate to app directory
cd "$(dirname "$0")"

# Build image
echo "1. Building Docker image..."
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

# Tag for external registry (for Docker push)
echo ""
echo "2. Tagging for external registry..."
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY_EXTERNAL}/${IMAGE_NAME}:${IMAGE_TAG}

# Push to external registry
echo ""
echo "3. Pushing to external registry (${REGISTRY_EXTERNAL})..."
if docker push ${REGISTRY_EXTERNAL}/${IMAGE_NAME}:${IMAGE_TAG} 2>&1 | grep -q "server gave HTTP response to HTTPS client"; then
    echo ""
    echo "⚠️  Error: Docker needs insecure registry configuration"
    echo ""
    echo "Fix this by:"
    echo "  1. Open Docker Desktop → Settings → Docker Engine"
    echo "  2. Add to JSON:"
    echo "     \"insecure-registries\": [\"${REGISTRY_EXTERNAL}\"]"
    echo "  3. Click 'Apply & Restart'"
    echo ""
    echo "Or run: ./fix-docker-insecure.sh"
    exit 1
fi

echo ""
echo "✅ Successfully pushed to external registry"
echo ""
echo "========================================="
echo "Registry Information"
echo "========================================="
echo "External (Docker push): ${REGISTRY_EXTERNAL}/${IMAGE_NAME}:${IMAGE_TAG}"
echo "Internal (Kubernetes):  ${REGISTRY_INTERNAL}/${IMAGE_NAME}:${IMAGE_TAG}"
echo ""
echo "Note: Kubernetes will use the internal registry endpoint automatically"
echo "      No need to configure insecure registries in Kubernetes"

