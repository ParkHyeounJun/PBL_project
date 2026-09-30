#!/usr/bin/env bash
set -euo pipefail
NS="${NS:-pbl-security}"; SA="pbl-audit-secret-reader"
cleanup(){ kubectl -n "${NS}" delete serviceaccount "${SA}" --ignore-not-found >/dev/null 2>&1 || true; }; trap cleanup EXIT
kubectl -n "${NS}" create serviceaccount "${SA}"; TOKEN="$(kubectl -n "${NS}" create token "${SA}" --duration=10m)"; SERVER="$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')"
echo "[category3:abnormal_1] ServiceAccount attempts to list Secrets."
if kubectl --kubeconfig=/dev/null --server="${SERVER}" --insecure-skip-tls-verify --token="${TOKEN}" -n "${NS}" get secrets; then echo "Unexpected success." >&2; exit 1; fi
echo "Forbidden as expected. Audit filter: grep '${SA}'"
