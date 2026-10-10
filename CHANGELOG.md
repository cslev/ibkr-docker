# Changelog

All notable changes to this project will be documented in this file.

---

## [1.2] - 2026-10-10

### Fixed
- **IB System Error 2172**: rebuilt and republished the image to pull IBKR's current standalone installer (Gateway 1045.1 → 1051), resolving the desupport warning ahead of IBKR's 2026-12-15 cutoff (minimum supported version 1050.1)
- **Java path on arm64**: IBC's bundled-JRE auto-detection reported a stale install4j extraction scratch path from build time instead of the permanent JRE under the installed version directory, causing `Can't find suitable Java installation` on Gateway 1051 (arm64). `start.sh` now locates `java` under `~/Jts/ibgateway/<version>/` itself and passes `--java-path` (the directory containing the binary — IBC appends `/java` itself) explicitly instead of relying on IBC's detection

---

## [1.1] - 2026-04-14

### Fixed
- **Healthcheck**: replaced `nc -z localhost 8888` with `socat /dev/null TCP:localhost:8888,connect-timeout=5` — `netcat` is not installed in the image; `socat` is
- Bumped healthcheck `start_period` from 60s to 90s to allow more time for IB Gateway login and 2FA before the first check
- Trimmed trailing whitespace in `docker-compose.yml`
- **Java timezone**: `JAVA_TOOL_OPTIONS` is silently stripped by the install4j launcher before the JVM starts; `-Duser.timezone` is now injected directly into `ibgateway.vmoptions` (under `### keep on update`) which survives IB Gateway auto-updates and cannot be stripped by the launcher

### Added
- **Timezone support**: host `/etc/timezone` and `/etc/localtime` are now mounted read-only into the container via `docker-compose.yml` volumes
- `TZ` environment variable added to `docker-compose.yml` (defaults to `Asia/Singapore`); adjust to your local timezone
- `tzdata` package added to the Dockerfile apt install to ensure timezone data is available in the image
- `start.sh` dynamically locates `ibgateway.vmoptions` and appends `-Duser.timezone=$TZ` on first container start (idempotent — skips if already present)

---

## [Initial Release]

- Multi-arch Docker image for IB Gateway (linux/amd64 + linux/arm64)
- noVNC web browser access on port 6080 (no VNC client required)
- IBC integration for automated login and 2FA handling
- Socat TCP proxy forwarding IB Gateway API port 4001/4002 to 8888
- Persistent TWS settings via host-mounted volume (`./tws-settings`)
