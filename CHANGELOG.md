# Changelog

All notable changes to this project will be documented in this file.

---

## [Unreleased]

### Fixed
- **Healthcheck**: replaced `nc -z localhost 8888` with `socat /dev/null TCP:localhost:8888,connect-timeout=5` — `netcat` is not installed in the image; `socat` is
- Bumped healthcheck `start_period` from 60s to 90s to allow more time for IB Gateway login and 2FA before the first check
- Trimmed trailing whitespace in `docker-compose.yml`

### Added
- **Timezone support**: host `/etc/timezone` and `/etc/localtime` are now mounted read-only into the container via `docker-compose.yml` volumes
- `TZ` environment variable added to `docker-compose.yml` (defaults to `Asia/Singapore`); adjust to your local timezone
- `JAVA_TOOL_OPTIONS=-Duser.timezone=$TZ` exported in `start.sh` so the IB Gateway JVM picks up the correct timezone (Java ignores `/etc/localtime` without this)
- `tzdata` package added to the Dockerfile apt install to ensure timezone data is available in the image

---

## [Initial Release]

- Multi-arch Docker image for IB Gateway (linux/amd64 + linux/arm64)
- noVNC web browser access on port 6080 (no VNC client required)
- IBC integration for automated login and 2FA handling
- Socat TCP proxy forwarding IB Gateway API port 4001/4002 to 8888
- Persistent TWS settings via host-mounted volume (`./tws-settings`)
