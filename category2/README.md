# Category 2: Hubble로 Pod 통신 확인
**한국어** | [English](README_EN.md)

허용된 서비스 경로와 내부 탐색·비정상 포트 연결 시도를 비교합니다.

## 로그 관찰

터미널 1에서 Hubble 연결을 열고 그대로 둡니다.

```bash
cd pbl-project
cilium hubble port-forward
```

터미널 2에서 모든 흐름을 관찰합니다.

```bash
hubble observe --namespace pbl-security --follow --output compact
```

터미널 3에서 프로젝트 루트로 이동해 원하는 시나리오를 실행합니다.

```bash
cd pbl-project

./category2/normal.sh
./category2/abnormal_1.sh
./category2/abnormal_2.sh
./category2/abnormal_3.sh
```

관찰을 끝낼 때는 터미널 1과 2에서 각각 `Ctrl+C`를 누릅니다.

## 시나리오

| 스크립트 | 행위 | 확인할 내용 |
| --- | --- | --- |
| `normal.sh` | frontend → backend, backend → db, health check와 DNS | `FORWARDED`, DNS query |
| `abnormal_1.sh` | frontend → db 직접 접근 | `Blocked as expected.`, `DROPPED` |
| `abnormal_2.sh` | 여러 내부 Pod·Service에 연속 접근 | 연속된 `FORWARDED`와 `DROPPED` |
| `abnormal_3.sh` | 22, 3306, 6379 포트 연결 시도 | 여러 `Policy denied DROPPED` 흐름 |

최근 차단 흐름만 다시 확인할 수 있습니다.

```bash
hubble observe --namespace pbl-security \
  --verdict DROPPED --since 10m --output compact
```