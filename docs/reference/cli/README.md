# Voice Mode CLI Tools

Voice Mode provides command-line tools for managing services, testing configurations, and diagnosing issues.

## Available Commands

### Main Command
- `voicemode` - Main Voice Mode CLI interface
- `voice-mode` - Alias for voicemode

### Service Management
- `voicemode service <service> <action>` - Manage Whisper, Kokoro, and LiveKit services
  - Services: `whisper`, `kokoro`, `livekit`
  - Actions: `status`, `start`, `stop`, `restart`, `enable`, `disable`, `logs`

### Installation Tools
- `voicemode install whisper` - Install whisper.cpp for local STT
- `voicemode install kokoro` - Install Kokoro for local TTS
- `voicemode install livekit` - Install LiveKit server

### Diagnostic Tools
- `voicemode check audio` - Check audio device configuration
- `voicemode check dependencies` - Verify system dependencies
- `voicemode diagnose` - Run full diagnostic suite

### Configuration
- `voicemode config show` - Display current configuration
- `voicemode config set <key> <value>` - Update configuration value
- `voicemode config list` - List all configuration options

### Voice Testing
- `voicemode test` - Test voice input/output
- `voicemode test stt` - Test speech-to-text only
- `voicemode test tts` - Test text-to-speech only

## Usage Examples

### Check Service Status
```bash
voicemode service whisper status
voicemode service kokoro status
voicemode service livekit status
```

### Start Services
```bash
voicemode service whisper start
voicemode service kokoro start
```

### View Service Logs
```bash
voicemode service whisper logs
voicemode service kokoro logs --lines 100
```

### Install Local Services
```bash
# Install Whisper with base model
voicemode install whisper --model base

# Install Kokoro with default voices
voicemode install kokoro

# Install LiveKit in development mode
voicemode install livekit --dev
```

### Test Voice Configuration
```bash
# Full voice test
voicemode test

# Test with specific provider
voicemode test --provider openai
voicemode test --provider local
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