#!/bin/bash

# Builds a multi-arch IB Gateway Docker image.
# Usage: ./build.sh [--load]
#   --load   build for local use (single-arch, amd64 only, no push)

set -euo pipefail

LOAD=${1:-}
CHANNEL=latest
IMAGE="cslev/ibkr-docker:latest"

if [[ "$LOAD" == "--load" ]]; then
	docker buildx build \
		--platform linux/amd64 \
		--build-arg CHANNEL="$CHANNEL" \
		--tag "$IMAGE" \
		--load \
		.
else
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg CHANNEL="$CHANNEL" \
		--tag "$IMAGE" \
		--push \
		.
fi
