# LiveKit Setup and Usage Guide

This guide covers the complete setup and usage of LiveKit integration with Voice Mode, including the LiveKit server, frontend management, and voice conversations.

## Overview

Voice Mode now includes full LiveKit integration providing:
- **LiveKit server management** - Install, configure, and manage LiveKit server as a system service
- **Voice Assistant Frontend** - Web-based interface for voice conversations bundled with Voice Mode
- **Service integration** - Unified management alongside Whisper and Kokoro services
- **Development and production** support with proper service lifecycle management

## Quick Start

### 1. Install LiveKit Server

```bash
# Install LiveKit server (automatically detects platform)
voice-mode livekit install

# Enable to start at boot/login
voice-mode livekit enable

# Start the server
voice-mode livekit start
```

### 2. Start Frontend

```bash
# Start the Voice Assistant Frontend
voice-mode frontend start

# Enable to start automatically
voice-mode frontend enable

# Open in browser
voice-mode frontend open
```

### 3. Access Voice Interface

1. Open http://localhost:3000 in your browser
2. Enter password: `voicemode123` (default)
3. Join or create a room for voice conversations

## Installation Details

### LiveKit Server Installation

The `voice-mode livekit install` command:
- Downloads LiveKit server binary for your platform (macOS/Linux)
- Creates configuration file at `~/.voicemode/config/livekit.yaml`
- Sets up systemd (Linux) or launchd (macOS) service files
- Configures development credentials for easy setup

**Installation locations:**
- **macOS**: `/opt/homebrew/bin/livekit-server`
- **Linux**: `/usr/local/bin/livekit-server`
- **Config**: `~/.voicemode/config/livekit.yaml`
- **Logs**: `~/.voicemode/logs/livekit/`

### Frontend Installation

The frontend is bundled with Voice Mode and automatically installed. The system:
- Prioritizes bundled frontend in the Python package
- Falls back to external development locations if needed
- Automatically installs Node.js dependencies on first run
- Supports multiple package managers (pnpm, npm, yarn)

## Configuration

### LiveKit Server Configuration

Edit `~/.voicemode/config/livekit.yaml`:

```yaml
# LiveKit development configuration
port: 7880
rtc:
  port_range_start: 50000
  port_range_end: 50100

keys:
  devkey: secret

# Enable room auto-creation for development
room:
  auto_create: true

# Development logging
logging:
  level: info
  json: false
```

### Frontend Configuration

Create `~/.voicemode/frontend/.env.local` for custom settings:

```bash
# Custom password (optional)
LIVEKIT_ACCESS_PASSWORD=your_custom_password

# LiveKit server URL (if different)
LIVEKIT_SERVER_URL=ws://localhost:7880
```

## Service Management

All LiveKit services integrate with Voice Mode's unified service management:

### Server Commands

```bash
# Status and control
voice-mode livekit status
voice-mode livekit start
voice-mode livekit stop
voice-mode livekit restart

# Service management
voice-mode livekit enable    # Start at boot/login
voice-mode livekit disable   # Don't start automatically

# Logs
voice-mode livekit logs
voice-mode livekit logs --follow
```

### Frontend Commands

```bash
# Status and control
voice-mode frontend status
voice-mode frontend start
voice-mode frontend stop

# Service management
voice-mode frontend enable
voice-mode frontend disable

# Utilities
voice-mode frontend open     # Open in browser
voice-mode frontend logs     # View logs
voice-mode frontend logs -f  # Follow logs
```

### Service Integration

Both LiveKit and frontend services work with the unified service management:

```bash
# Using the service command
voice-mode service livekit status
voice-mode service frontend start
voice-mode service frontend enable
```

## Usage Scenarios

### Development Setup

For active development:

```bash
# Quick start everything
voice-mode livekit start
voice-mode frontend start

# Open the interface
voice-mode frontend open
```

### Production Deployment

For persistent services:

```bash
# Install and enable all services
voice-mode livekit install
voice-mode livekit enable

voice-mode frontend enable

# Services now start automatically at boot/login
# Status check
voice-mode livekit status
voice-mode frontend status
```

### Troubleshooting Setup

```bash
# Check all service status
voice-mode livekit status
voice-mode frontend status

# View logs for issues
voice-mode livekit logs --follow
voice-mode frontend logs --follow

# Restart services
voice-mode livekit restart
voice-mode frontend restart
```

## Voice Conversations

### Web Interface

1. **Access**: Navigate to http://localhost:3000
2. **Authentication**: Enter password (default: `voicemode123`)
3. **Room Management**: Create or join rooms for conversations
4. **Voice Control**: Click to start/stop recording and speaking

### API Integration

LiveKit server provides REST API and WebSocket endpoints:

```bash
# List active rooms
curl -H "Authorization: Bearer <jwt_token>" \
     http://localhost:7880/twirp/livekit.RoomService/ListRooms \
     -H "Content-Type: application/json" -d '{}'
```

**Generate JWT tokens** for API access using development credentials:
- **Key**: `devkey`
- **Secret**: `secret`

### Frontend Features

- **Real-time voice conversations** with AI agents
- **Room-based communication** supporting multiple participants
- **Automatic room creation** for quick setup
- **Responsive web interface** optimized for voice interactions
- **WebRTC audio** with LiveKit's optimized transport

## Advanced Configuration

### Custom Ports

To change default ports, edit configurations and restart services:

**LiveKit server** (`~/.voicemode/config/livekit.yaml`):
```yaml
port: 8880  # Change from default 7880
```

**Frontend** (`.env.local`):
```bash
PORT=4000  # Change from default 3000
```

### SSL/TLS Setup

For production deployments with SSL:

1. Configure reverse proxy (nginx, Apache)
2. Update frontend LIVEKIT_SERVER_URL to use wss://
3. Ensure LiveKit server accepts secure connections

### Multiple Instances

Run multiple LiveKit instances:

```bash
# Custom config file
livekit-server --config /path/to/custom-config.yaml

# Different ports
# Edit config files to use different port ranges
```

## Logs and Monitoring

### Log Locations

- **LiveKit server**: `~/.voicemode/logs/livekit/livekit.log`
- **Frontend**: `~/.voicemode/logs/frontend/frontend.log`
- **System services**: `journalctl --user -u voicemode-livekit.service`

### Health Checks

```bash
# Check if services are responding
curl -f http://localhost:7880/debug/info || echo "LiveKit not responding"
curl -f http://localhost:3000 || echo "Frontend not responding"

# Check process status
voice-mode livekit status
voice-mode frontend status
```

### Performance Monitoring

Monitor resource usage:

```bash
# Service memory and CPU usage
voice-mode livekit status    # Shows memory/CPU
voice-mode frontend status   # Shows resource usage

# System monitoring
ps aux | grep livekit
ps aux | grep next-server    # Frontend process
```

## Uninstallation

### Remove Services

```bash
# Disable and stop services
voice-mode livekit disable
voice-mode livekit stop
voice-mode frontend disable

# Uninstall (removes binaries and configs)
voice-mode livekit uninstall
voice-mode livekit uninstall --remove-all-data  # Includes logs
```

### Clean Removal

Complete cleanup:

```bash
# Remove all LiveKit data
rm -rf ~/.voicemode/logs/livekit/
rm -rf ~/.voicemode/config/livekit.yaml

# Remove frontend data  
rm -rf ~/.voicemode/logs/frontend/

# Remove service files (automatic on uninstall)
```

## Integration with Voice Mode

### MCP Tools

LiveKit services are available as MCP tools for AI agents:

- `livekit_install` / `livekit_uninstall`
- `livekit_server_start` / `livekit_server_stop` / `livekit_server_status`
- `livekit_frontend_start` / `livekit_frontend_stop` / `livekit_frontend_status`
- `livekit_frontend_open` / `livekit_frontend_logs`

### Agent Integration

AI agents can manage LiveKit services programmatically and create voice conversation rooms for direct interaction.

## Troubleshooting

### Common Issues

**Port already in use:**
```bash
# Find conflicting process
lsof -ti :7880  # LiveKit
lsof -ti :3000  # Frontend

# Stop conflicting services
voice-mode livekit stop
voice-mode frontend stop
```

**Permission denied:**
```bash
# Fix service permissions (Linux)
systemctl --user daemon-reload
systemctl --user restart voicemode-livekit.service

# Fix binary permissions
sudo chmod +x /usr/local/bin/livekit-server
```

**Frontend dependencies:**
```bash
# Manual dependency install
cd ~/.voicemode/frontend  # or bundled location
npm install

# Check frontend logs
voice-mode frontend logs
```

**Service won't start:**
```bash
# Check service status
systemctl --user status voicemode-livekit.service
systemctl --user status voicemode-frontend.service

# View system logs
journalctl --user -u voicemode-livekit.service -f
```

### Getting Help

1. **Check logs first**: `voice-mode livekit logs` and `voice-mode frontend logs`
2. **Verify installation**: `voice-mode livekit status`
3. **Test connectivity**: Access http://localhost:3000 and http://localhost:7880
4. **Review configuration**: Check `~/.voicemode/config/livekit.yaml`

For additional support, include log outputs and system information when reporting issues.