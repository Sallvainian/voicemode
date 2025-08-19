# LiveKit Service Integration Design

## Overview

This document outlines the design for integrating LiveKit as a managed service in Voice Mode, similar to how Whisper and Kokoro are currently managed.

## Architecture Overview

```
Voice Mode
├── CLI Commands
│   ├── voice-mode livekit install
│   ├── voice-mode livekit start/stop/status
│   └── voice-mode livekit uninstall
├── MCP Tools
│   ├── install_livekit()
│   ├── Extended service() tool
│   └── livekit_status()
└── Service Management
    ├── systemd/launchd templates
    ├── Health checks
    └── Auto-discovery
```

## Installation Strategy

### Binary Installation
1. **macOS**: Use `brew install livekit` (already available)
2. **Linux**: Use official install script: `curl -sSL https://get.livekit.io | bash`
3. **Fallback**: Direct binary download from GitHub releases

### Service Location
- Install to: `~/.voicemode/services/livekit/`
- Binary: `~/.voicemode/services/livekit/livekit-server`
- Config: `~/.voicemode/services/livekit/livekit.yaml`
- Logs: `~/.voicemode/logs/livekit/`

## Configuration

### Dev Mode (Default)
```yaml
# ~/.voicemode/services/livekit/livekit.yaml
port: 7880
rtc:
  port_range_start: 50000
  port_range_end: 60000
  use_external_ip: false
keys:
  devkey: secret
log_level: info
```

### Environment Variables
```bash
LIVEKIT_URL=ws://localhost:7880
LIVEKIT_API_KEY=devkey
LIVEKIT_API_SECRET=secret
```

## Service Templates

### systemd Template
```ini
[Unit]
Description=Voice Mode LiveKit Server
After=network.target

[Service]
Type=simple
ExecStart={LIVEKIT_BIN} --config {CONFIG_FILE} --dev
WorkingDirectory={WORKING_DIR}
ExecStartPost=/bin/sh -c 'while ! curl -sf http://127.0.0.1:{LIVEKIT_PORT}/health >/dev/null 2>&1; do echo "Waiting for LiveKit..."; sleep 1; done'
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
```

### launchd Template
```xml
<dict>
    <key>Label</key>
    <string>com.voicemode.livekit</string>
    <key>ProgramArguments</key>
    <array>
        <string>{LIVEKIT_BIN}</string>
        <string>--config</string>
        <string>{CONFIG_FILE}</string>
        <string>--dev</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
```

## Implementation Plan

### Phase 1: Core Installation
1. Create `voice_mode/tools/services/livekit/install.py`
   - Platform detection (macOS/Linux)
   - Binary installation (brew/curl/direct download)
   - Service file generation
   - Config file creation

2. Create `voice_mode/tools/services/livekit/uninstall.py`
   - Service removal
   - Binary cleanup
   - Config cleanup

### Phase 2: Service Management
1. Extend `voice_mode/tools/service.py`
   - Add LiveKit support
   - Health check integration
   - Status reporting

2. Create service templates
   - `voice_mode/templates/systemd/voicemode-livekit.service`
   - `voice_mode/templates/launchd/com.voicemode.livekit.plist`

### Phase 3: CLI Integration
1. Add to `voice_mode/cli.py`
   - Create `@voice_mode_main_cli.group()` for livekit
   - Add all subcommands (install, start, stop, etc.)

### Phase 4: MCP Tools
1. Create/update MCP tools
   - `install_livekit` tool
   - Update existing `service` tool
   - Add `livekit_status` tool

### Phase 5: Web Interface
1. Update web interface in `docs/web/`
   - Auto-detect local LiveKit server
   - Connection configuration
   - Fallback to cloud

## Health Checks

LiveKit exposes health endpoints:
- `/health` - Basic health check
- `/` - Returns LiveKit version info

## Auto-Discovery

Add to provider discovery:
- Check port 7880 for LiveKit server
- Verify with health endpoint
- Add to provider registry

## Testing Strategy

1. **Installation Testing**
   - Test on macOS (brew)
   - Test on Linux (curl script)
   - Test fallback binary download

2. **Service Testing**
   - Start/stop/restart
   - Auto-start on boot
   - Log rotation

3. **Integration Testing**
   - Web interface connection
   - Token generation
   - Room creation

## Migration from Previous Work

From the voice-mcp.tgz analysis:
- Reuse livekit-admin-mcp concepts for room management
- Adapt web interface from livekit/voice-assistant-frontend
- Use existing LiveKit documentation structure

## Success Metrics

- [ ] One-command installation: `voice-mode livekit install`
- [ ] Service management parity with Whisper/Kokoro
- [ ] Web interface works locally
- [ ] TailScale remote access functional
- [ ] Graceful fallback to cloud LiveKit

## Open Questions

1. Should we bundle the web interface or serve from docs/web/?
2. How to handle TURN server configuration for NAT traversal?
3. Should we auto-install during first `converse` if not present?

## Next Steps

1. Start with install.py implementation
2. Test on both macOS and Linux
3. Create service templates
4. Integrate with CLI
5. Update documentation