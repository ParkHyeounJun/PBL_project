#!/usr/bin/env bash
set -euo pipefail
NS="${NS:-pbl-security}"; P="$(kubectl -n "${NS}" get pod -l app=frontend -o jsonpath='{.items[0].metadata.name}')"
echo "[category2:abnormal_2] Sequential access to internal Pods and Services."
for target in frontend backend db kubernetes.default.svc; do echo "Trying http://${target}:80"; kubectl -n "${NS}" exec "${P}" -- wget -qO- -T 2 "http://${target}:80" >/dev/null 2>&1 || true; done
echo "Attempts completed; inspect FORWARDED and DROPPED flows in Hubble."
