# Category 3: Kubernetes Audit Log 확인
**한국어** | [English](README_EN.md)

정상 조회와 ServiceAccount 자격증명을 이용한 권한 없는 API 요청을 비교합니다.

## 로그 관찰

터미널 1에서 Audit Log를 계속 관찰합니다.

```bash
docker exec pbl-security-control-plane \
  tail -F /var/log/kubernetes/audit.log | \
grep --line-buffered pbl-security
```

터미널 2에서 프로젝트 루트로 이동해 원하는 시나리오를 실행합니다.

```bash
cd pbl-project

./category3/normal.sh
./category3/abnormal_1.sh
./category3/abnormal_2.sh
./category3/abnormal_3.sh
```

관찰을 끝낼 때는 터미널 1에서 `Ctrl+C`를 누릅니다.

## 시나리오

| 스크립트 | 행위 | 확인할 내용 |
| --- | --- | --- |
| `normal.sh` | Pod, ConfigMap, Service와 자신의 Pod 정보 조회 | `code: 200` |
| `abnormal_1.sh` | ServiceAccount로 Secret 목록 조회 | `pbl-audit-secret-reader`, `code: 403` |
| `abnormal_2.sh` | 다른 Pod의 `pods/exec` API에 POST | `pbl-audit-pod-exec`, `resource: pods`, `subresource: exec`, `code: 403` |
| `abnormal_3.sh` | Pod와 Secret을 짧은 시간에 반복 조회 | `pbl-audit-burst-reader`의 반복 요청 |

시나리오별 이벤트를 다시 확인할 수 있습니다.

```bash
docker exec pbl-security-control-plane \
  grep -E 'pbl-audit-(secret-reader|pod-exec|burst-reader)' \
  /var/log/kubernetes/audit.log | tail -n 30
```
