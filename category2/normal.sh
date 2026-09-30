#!/usr/bin/env bash
set -euo pipefail
NS="${NS:-pbl-security}"
F="$(kubectl -n "${NS}" get pod -l app=frontend -o jsonpath='{.items[0].metadata.name}')"
B="$(kubectl -n "${NS}" get pod -l app=backend -o jsonpath='{.items[0].metadata.name}')"
echo "[1/3] frontend -> backend"; kubectl -n "${NS}" exec "${F}" -- wget -qO- -T 5 http://backend
echo "[2/3] backend -> db"; kubectl -n "${NS}" exec "${B}" -- wget -qO- -T 5 http://db
echo "[3/3] health check and DNS"; kubectl -n "${NS}" exec "${F}" -- wget -qO- -T 5 http://backend; kubectl -n "${NS}" exec "${F}" -- nslookup backend.pbl-security.svc.cluster.local
echo "Hubble: hubble observe --namespace ${NS} --since 10m --output compact"
