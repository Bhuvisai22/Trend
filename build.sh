#!/usr/bin/env bash
set -e

# Usage:
#   ./build.sh dev
#   ./build.sh prod

ENVIRONMENT=${1:-dev}

if [[ "$ENVIRONMENT" == "dev" ]]; then
  IMAGE_NAME="saidoc540/trend-app-dev"
elif [[ "$ENVIRONMENT" == "prod" ]]; then
  IMAGE_NAME="saidoc540/trend-app-prod"
else
  echo "Unknown environment: $ENVIRONMENT (use dev|prod)"
  exit 1
fi

TAG=${TAG:-latest}

echo "Building image: ${IMAGE_NAME}:${TAG}"

docker build -t "${IMAGE_NAME}:${TAG}" .
