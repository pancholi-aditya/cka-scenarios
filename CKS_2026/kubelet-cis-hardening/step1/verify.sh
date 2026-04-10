#!/bin/bash
set -e

INITIAL_REPORT=/opt/course/kube-bench-initial.txt
USER_REPORT=/opt/course/kube-bench-report.txt

echo "[VERIFY] Checking kube-bench availability..."
command -v kube-bench >/dev/null

if [ ! -s "$INITIAL_REPORT" ]; then
  echo "initial kube-bench report is missing"
  exit 1
fi

if [ ! -s "$USER_REPORT" ]; then
  echo "Run kube-bench and save the output to $USER_REPORT"
  exit 1
fi

if ! grep -q "anonymous-auth" "$USER_REPORT" || ! grep -q "AlwaysAllow" "$USER_REPORT"; then
  echo "$USER_REPORT must include the kubelet CIS findings"
  exit 1
fi

echo "[VERIFY] kube-bench CIS findings were collected."
