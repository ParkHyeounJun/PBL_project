#!/usr/bin/env bash
set -euo pipefail
NS="${NS:-pbl-security}"; POD="$(kubectl -n "${NS}" get pod -l app=frontend -o jsonpath='{.items[0].metadata.name}')"
echo "[category1:abnormal_3] Starting /bin/sh inside the application Pod."
script -qec "kubectl -n ${NS} exec -it ${POD} -- /bin/sh -c 'id; echo pbl-shell-executed; sleep 1'" /dev/null
echo "Falco: kubectl logs -n falco -l app.kubernetes.io/name=falco -c falco --prefix --since=10m"
