#!/usr/bin/env bash
set -euo pipefail
NS="${NS:-pbl-security}"; P="$(kubectl -n "${NS}" get pod -l app=frontend -o jsonpath='{.items[0].metadata.name}')"
echo "[category2:abnormal_3] Connecting to unusual ports on internal targets."
for target in backend db; do for port in 22 3306 6379; do echo "Trying ${target}:${port}"; kubectl -n "${NS}" exec "${P}" -- nc -z -w 1 "${target}" "${port}" >/dev/null 2>&1 || true; done; done
echo "Attempts completed; inspect DROPPED flows in Hubble."
