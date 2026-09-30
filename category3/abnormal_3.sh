#!/usr/bin/env bash
set -euo pipefail
NS="${NS:-pbl-security}"; SA="pbl-audit-burst-reader"
cleanup(){ kubectl -n "${NS}" delete serviceaccount "${SA}" --ignore-not-found >/dev/null 2>&1 || true; }; trap cleanup EXIT
kubectl -n "${NS}" create serviceaccount "${SA}"; TOKEN="$(kubectl -n "${NS}" create token "${SA}" --duration=10m)"; SERVER="$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')"
K=(kubectl --kubeconfig=/dev/null --server="${SERVER}" --insecure-skip-tls-verify --token="${TOKEN}" -n "${NS}")
echo "[category3:abnormal_3] Burst-reading Pods and Secrets."
for i in 1 2 3 4 5; do echo "Burst ${i}/5"; "${K[@]}" get pods >/dev/null 2>&1 || true; "${K[@]}" get secrets >/dev/null 2>&1 || true; done
echo "Burst completed. Audit filter: grep '${SA}'"
