#!/usr/bin/env bash
set -euo pipefail
NS="${NS:-pbl-security}"
POD="$(kubectl -n "${NS}" get pod -l app=frontend -o jsonpath='{.items[0].metadata.name}')"
echo "[1/3] Read application configuration."
kubectl -n "${NS}" exec "${POD}" -- cat /etc/hostname
echo "[2/3] Create and update a temporary file."
kubectl -n "${NS}" exec "${POD}" -- sh -c 'echo created > /tmp/pbl-normal.tmp; echo updated >> /tmp/pbl-normal.tmp; rm -f /tmp/pbl-normal.tmp'
echo "[3/3] Run the application health check."
kubectl -n "${NS}" exec "${POD}" -- wget -qO- -T 5 http://127.0.0.1/
echo "Falco: kubectl logs -n falco -l app.kubernetes.io/name=falco -c falco --prefix --since=10m"
