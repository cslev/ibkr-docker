#!/bin/bash

# Builds a multi-arch IB Gateway Docker image.
# Usage: ./build.sh [--load]
#   --load   build for local use (single-arch, amd64 only, no push)
#
# Pushes both :latest and :$VERSION. Bump VERSION before each release.

set -euo pipefail

LOAD=${1:-}
CHANNEL=latest
VERSION="v1.2"
IMAGE="cslev/ibkr-docker"

if [[ "$LOAD" == "--load" ]]; then
	docker buildx build \
		--platform linux/amd64 \
		--build-arg CHANNEL="$CHANNEL" \
		--tag "$IMAGE:latest" \
		--load \
		.
else
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg CHANNEL="$CHANNEL" \
		--tag "$IMAGE:latest" \
		--tag "$IMAGE:$VERSION" \
		--push \
		.
fi
