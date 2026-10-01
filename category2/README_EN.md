# Category 2: Observe Pod Communication with Hubble

[한국어](README.md) | **English**

Compare allowed service traffic with direct access, internal discovery, and unusual-port connection attempts.

## Observe Logs

In terminal 1, start the Hubble port forward and leave it running:

```bash
cd pbl-project
cilium hubble port-forward
```

In terminal 2, follow all flows in the lab namespace:

```bash
hubble observe --namespace pbl-security --follow --output compact
```

In terminal 3, move to the project root and run any scenario:

```bash
cd pbl-project

./category2/normal.sh
./category2/abnormal_1.sh
./category2/abnormal_2.sh
./category2/abnormal_3.sh
```

Press `Ctrl+C` in terminals 1 and 2 when finished.

## Scenarios

| Script | Activity | Expected evidence |
| --- | --- | --- |
| `normal.sh` | frontend → backend, backend → db, health check, DNS | `FORWARDED` TCP and UDP/53 flows |
| `abnormal_1.sh` | Direct frontend → db access | `Blocked as expected.`, `DROPPED` |
| `abnormal_2.sh` | Sequential access to internal Pods and Services | A sequence of `FORWARDED` and `DROPPED` flows |
| `abnormal_3.sh` | Connect to ports 22, 3306, and 6379 | Multiple `Policy denied DROPPED` flows |

Show only recent dropped flows:

```bash
hubble observe --namespace pbl-security \
  --verdict DROPPED --since 10m --output compact
```

Example logs:

- `logs/normal.log`
- `logs/abnormal_1.log`
- `logs/abnormal_2.log`
- `logs/abnormal_3.log`
