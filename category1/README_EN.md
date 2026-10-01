# Category 1: Observe In-Pod Activity with Falco

[한국어](README.md) | **English**

Compare expected file/process activity with sensitive data access and interactive shell execution inside application Pods.

## Observe Logs

In terminal 1, follow all Falco events:

```bash
kubectl logs -n falco \
  -l app.kubernetes.io/name=falco \
  -c falco --prefix --follow
```

In terminal 2, move to the project root and run any scenario:

```bash
cd pbl-project

./category1/normal.sh
./category1/abnormal_1.sh
./category1/abnormal_2.sh
./category1/abnormal_3.sh
```

Press `Ctrl+C` in terminal 1 when finished.

## Scenarios

| Script | Activity | Expected evidence |
| --- | --- | --- |
| `normal.sh` | Read configuration, create/update a `/tmp` file, run a health check | `scenario=normal`, `action=config_read` |
| `abnormal_1.sh` | Read `/etc/shadow` | `scenario=abnormal_1`, `action=shadow_read` |
| `abnormal_2.sh` | Read the ServiceAccount token | `scenario=abnormal_2`, `action=token_read` |
| `abnormal_3.sh` | Start a TTY shell in an application Pod | `scenario=abnormal_3`, `action=shell_exec` |

Show recent PBL events with one command:

```bash
kubectl logs -n falco \
  -l app.kubernetes.io/name=falco \
  -c falco --prefix --since=10m | grep PBL_EVENT
```

All four example files use the same Falco JSON structure:

- `logs/normal.log`
- `logs/abnormal_1.log`
- `logs/abnormal_2.log`
- `logs/abnormal_3.log`
