#!/usr/bin/env bash
set -euo pipefail
NS="${NS:-pbl-security}"; SA="pbl-audit-pod-exec"; POD="$(kubectl -n "${NS}" get pod -l app=backend -o jsonpath='{.items[0].metadata.name}')"
cleanup(){ kubectl -n "${NS}" delete serviceaccount "${SA}" --ignore-not-found >/dev/null 2>&1 || true; }; trap cleanup EXIT
kubectl -n "${NS}" create serviceaccount "${SA}"; TOKEN="$(kubectl -n "${NS}" create token "${SA}" --duration=10m)"; SERVER="$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')"
echo "[category3:abnormal_2] ServiceAccount attempts exec into ${POD}."
URI="${SERVER}/api/v1/namespaces/${NS}/pods/${POD}/exec?command=id&stdout=true&stderr=true"
STATUS="$(curl -k -sS -o /tmp/pbl-exec-response.json -w '%{http_code}' \
  -X POST -H "Authorization: Bearer ${TOKEN}" "${URI}")"
cat /tmp/pbl-exec-response.json
rm -f /tmp/pbl-exec-response.json
if [[ "${STATUS}" != "403" ]]; then
  echo "Expected HTTP 403, got ${STATUS}." >&2
  exit 1
fi
echo "Forbidden as expected. Audit filter: grep '${SA}'"
