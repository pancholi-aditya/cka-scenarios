#!/bin/bash

# Find server pod and namespace dynamically
SERVER_INFO=$(kubectl get pods -A \
  -l networkpolicy-test-role=server \
  -o jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' \
  2>/dev/null | head -n1)

CLIENT_INFO=$(kubectl get pods -A \
  -l networkpolicy-test-role=client \
  -o jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' \
  2>/dev/null | head -n1)

# Fail if required pods are missing
if [ -z "$SERVER_INFO" ] || [ -z "$CLIENT_INFO" ]; then
  exit 1
fi

SERVER_NS=$(echo "$SERVER_INFO" | awk '{print $1}')
CLIENT_NS=$(echo "$CLIENT_INFO" | awk '{print $1}')
CLIENT_POD=$(echo "$CLIENT_INFO" | awk '{print $2}')

# Discover service targeting the server pod (same namespace)
SERVICE_NAME=$(kubectl get svc -n "$SERVER_NS" \
  -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.spec.selector.networkpolicy-test-role}{"\n"}{end}' \
  2>/dev/null | awk '$2=="server"{print $1}' | head -n1)

if [ -z "$SERVICE_NAME" ]; then
  exit 1
fi

# Attempt traffic from client to server service
kubectl exec -n "$CLIENT_NS" "$CLIENT_POD" -- \
  wget -qO- --timeout=3 "$SERVICE_NAME.$SERVER_NS" >/dev/null 2>&1

# If traffic succeeds → NetworkPolicy NOT enforced → fail
# If traffic fails → NetworkPolicy enforced → pass
if [ $? -eq 0 ]; then
  exit 1
else
  exit 0
fi
