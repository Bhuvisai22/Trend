#!/usr/bin/env bash
set -e

# Usage:
#   IMAGE_NAME=saidoc540/trend-app-dev IMAGE_TAG=latest ./deploy.sh

IMAGE_NAME=${IMAGE_NAME:-saidoc540/trend-app-dev}
IMAGE_TAG=${IMAGE_TAG:-latest}

echo "Deploying ${IMAGE_NAME}:${IMAGE_TAG}"

# Update image
docker pull "${IMAGE_NAME}:${IMAGE_TAG}"

# Export vars for docker-compose
export IMAGE_NAME
export IMAGE_TAG

# Run using docker-compose
docker compose down || true
docker compose up -d

docker ps
