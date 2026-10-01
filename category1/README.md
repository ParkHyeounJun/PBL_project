# Category 1: Falco로 Pod 내부 행위 확인
**한국어** | [English](README_EN.md)

Pod 내부의 정상적인 파일·프로세스 활동과 민감 정보 접근 및 셸 실행을 비교합니다.

## 로그 관찰

터미널 1에서 Falco 로그를 계속 관찰합니다.

```bash
kubectl logs -n falco \
  -l app.kubernetes.io/name=falco \
  -c falco --prefix --follow
```

터미널 2에서 프로젝트 루트로 이동해 원하는 시나리오를 실행합니다.

```bash
cd pbl-project

./category1/normal.sh
./category1/abnormal_1.sh
./category1/abnormal_2.sh
./category1/abnormal_3.sh
```

관찰을 끝낼 때는 터미널 1에서 `Ctrl+C`를 누릅니다.

## 시나리오

| 스크립트 | 행위 | 확인할 내용 |
| --- | --- | --- |
| `normal.sh` | 설정 파일 읽기, `/tmp` 파일 생성·수정, health check | 정상 파일·프로세스 활동 |
| `abnormal_1.sh` | `/etc/shadow` 읽기 | `Sensitive file opened for reading` |
| `abnormal_2.sh` | ServiceAccount token 읽기 | token 파일 경로와 `cat` 프로세스 |
| `abnormal_3.sh` | 애플리케이션 Pod에서 TTY 셸 실행 | `A shell was spawned in a container` |

최근 로그를 한 번에 다시 확인할 수 있습니다.

```bash
kubectl logs -n falco \
  -l app.kubernetes.io/name=falco \
  -c falco --prefix --since=10m
```