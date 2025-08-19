# Voice Mode CLI Tools

Voice Mode provides command-line tools for managing services, testing configurations, and diagnosing issues.

## Available Commands

### Main Command
- `voice-mode` - Main Voice Mode CLI interface

### Service Management
- `voice-mode service <service> <action>` - Manage Whisper, Kokoro, and LiveKit services
  - Services: `whisper`, `kokoro`, `livekit`
  - Actions: `status`, `start`, `stop`, `restart`, `enable`, `disable`, `logs`

### Installation Tools
- `voice-mode install whisper` - Install whisper.cpp for local STT
- `voice-mode install kokoro` - Install Kokoro for local TTS
- `voice-mode install livekit` - Install LiveKit server

### Diagnostic Tools
- `voice-mode check audio` - Check audio device configuration
- `voice-mode check dependencies` - Verify system dependencies
- `voice-mode diagnose` - Run full diagnostic suite

### Configuration
- `voice-mode config show` - Display current configuration
- `voice-mode config set <key> <value>` - Update configuration value
- `voice-mode config list` - List all configuration options

### Voice Testing
- `voice-mode test` - Test voice input/output
- `voice-mode test stt` - Test speech-to-text only
- `voice-mode test tts` - Test text-to-speech only

## Usage Examples

### Check Service Status
```bash
voice-mode service whisper status
voice-mode service kokoro status
voice-mode service livekit status
```

### Start Services
```bash
voice-mode service whisper start
voice-mode service kokoro start
```

### View Service Logs
```bash
voice-mode service whisper logs
voice-mode service kokoro logs --lines 100
```

### Install Local Services
```bash
# Install Whisper with base model
voice-mode install whisper --model base

# Install Kokoro with default voices
voice-mode install kokoro

# Install LiveKit in development mode
voice-mode install livekit --dev
```

### Test Voice Configuration
```bash
# Full voice test
voice-mode test

# Test with specific provider
voice-mode test --provider openai
voice-mode test --provider local
```

## Environment Variables

The CLI respects all Voice Mode environment variables. See [Configuration Reference](../configuration.md) for details.

## Exit Codes

- `0` - Success
- `1` - General error
- `2` - Missing dependencies
- `3` - Service not running
- `4` - Configuration error
- `5` - Permission denied

## See Also

- [MCP Tools Reference](../mcp/tools.md) - Tools available to AI assistants
- [Service Management](../../services/README.md) - Detailed service documentation
- [Configuration Guide](../../user-guide/configuration.md) - User configuration guide