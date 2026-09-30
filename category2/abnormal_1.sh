#!/usr/bin/env bash
set -euo pipefail
NS="${NS:-pbl-security}"; P="$(kubectl -n "${NS}" get pod -l app=frontend -o jsonpath='{.items[0].metadata.name}')"
echo "[category2:abnormal_1] frontend -> db direct access"
if kubectl -n "${NS}" exec "${P}" -- wget -qO- -T 3 http://db; then echo "Unexpected success." >&2; exit 1; fi
echo "Blocked as expected."
