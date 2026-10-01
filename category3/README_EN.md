# Category 3: Inspect Kubernetes Audit Logs

[한국어](README.md) | **English**

Compare normal API queries with unauthorized requests made using ServiceAccount credentials.

## Observe Logs

In terminal 1, follow the Kubernetes Audit Log:

```bash
docker exec pbl-security-control-plane \
  tail -F /var/log/kubernetes/audit.log | \
grep --line-buffered pbl-security
```

In terminal 2, move to the project root and run any scenario:

```bash
cd pbl-project

./category3/normal.sh
./category3/abnormal_1.sh
./category3/abnormal_2.sh
./category3/abnormal_3.sh
```

Press `Ctrl+C` in terminal 1 when finished.

## Scenarios

| Script | Activity | Expected evidence |
| --- | --- | --- |
| `normal.sh` | Query Pods, a ConfigMap, Services, and the frontend Pod | `code: 200` |
| `abnormal_1.sh` | List Secrets using a ServiceAccount | `pbl-audit-secret-reader`, `code: 403` |
| `abnormal_2.sh` | POST to another Pod's `pods/exec` API | `pbl-audit-pod-exec`, `subresource: exec`, `code: 403` |
| `abnormal_3.sh` | Query Pods and Secrets repeatedly in a short burst | Repeated requests from `pbl-audit-burst-reader` |

Show events for the abnormal scenario identities:

```bash
docker exec pbl-security-control-plane \
  grep -E 'pbl-audit-(secret-reader|pod-exec|burst-reader)' \
  /var/log/kubernetes/audit.log | tail -n 30
```

Example logs:

- `logs/normal.log`
- `logs/abnormal_1.log`
- `logs/abnormal_2.log`
- `logs/abnormal_3.log`
