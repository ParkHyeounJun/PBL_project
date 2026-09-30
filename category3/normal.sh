#!/usr/bin/env bash
set -euo pipefail
NS="${NS:-pbl-security}"
echo "[1/3] List Pods in my namespace."; kubectl -n "${NS}" get pods
echo "[2/3] Read an allowed ConfigMap."; kubectl -n "${NS}" get configmap kube-root-ca.crt
echo "[3/3] Read my Service and Pod information."; kubectl -n "${NS}" get services; kubectl -n "${NS}" get pod -l app=frontend -o wide
echo "Audit: docker exec pbl-security-control-plane grep '\"namespace\":\"${NS}\"' /var/log/kubernetes/audit.log | tail -n 30"
