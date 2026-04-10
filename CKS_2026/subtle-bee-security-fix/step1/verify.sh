#!/bin/bash
set -e

APP_DIR=/home/candidate/subtle-bee
DOCKERFILE=$APP_DIR/Dockerfile
DEPLOYMENT=$APP_DIR/deployment.yaml
BUILD_MARKER=/opt/course/subtle-bee-docker-build-attempted

if [ -f "$BUILD_MARKER" ]; then
  echo "Do not build the Dockerfile for this task"
  exit 1
fi

echo "[VERIFY] Checking Dockerfile..."
if [ ! -f "$DOCKERFILE" ]; then
  echo "Dockerfile is missing"
  exit 1
fi

USER_COUNT=$(grep -Ec '^[[:space:]]*USER[[:space:]]+' "$DOCKERFILE")
if [ "$USER_COUNT" -ne 1 ]; then
  echo "Do not add or remove Dockerfile USER instructions"
  exit 1
fi

if ! grep -Eq '^[[:space:]]*USER[[:space:]]+nobody[[:space:]]*$' "$DOCKERFILE"; then
  echo "Dockerfile USER instruction must be changed to nobody"
  exit 1
fi

if grep -Eq '^[[:space:]]*USER[[:space:]]+root[[:space:]]*$' "$DOCKERFILE"; then
  echo "Dockerfile must not run as root"
  exit 1
fi

echo "[VERIFY] Checking Deployment manifest..."
if [ ! -f "$DEPLOYMENT" ]; then
  echo "Deployment manifest is missing"
  exit 1
fi

RUN_AS_USER_COUNT=$(grep -Ec '^[[:space:]]*runAsUser:' "$DEPLOYMENT")
if [ "$RUN_AS_USER_COUNT" -ne 1 ]; then
  echo "Do not add or remove runAsUser fields"
  exit 1
fi

if ! grep -Eq '^[[:space:]]*runAsUser:[[:space:]]*65535[[:space:]]*$' "$DEPLOYMENT"; then
  echo "runAsUser must be changed to 65535"
  exit 1
fi

if grep -Eq '^[[:space:]]*runAsUser:[[:space:]]*0[[:space:]]*$' "$DEPLOYMENT"; then
  echo "Deployment must not run as UID 0"
  exit 1
fi

echo "[VERIFY] Security best-practice fields are fixed."
