## BLE & Advertising Constraints

- **Service Registration**: Never call `addService` while advertising is active or duplicate services. Always use `BleService.addService` which handles `clearServices` and idempotency.
- **Heartbeat Logic**: `AdvertisingController` restarts advertising every 300s or 111m movement. Do not lower these thresholds without battery/stability testing.
- **iOS Background**: iOS strips Manufacturer Data in background. Fallback to GATT read of `identityCharUuid` for identity sync.

## graphify

This project has a graphify knowledge graph at graphify-out/.

Rules:
- Before answering architecture or codebase questions, read graphify-out/GRAPH_REPORT.md for god nodes and community structure
- If graphify-out/wiki/index.md exists, navigate it instead of reading raw files
- After modifying code files in this session, run `python3 -c "from graphify.watch import _rebuild_code; from pathlib import Path; _rebuild_code(Path('.'))"` to keep the graph current
