# Voice Mode CLI Tools

Voice Mode provides command-line tools for managing services, testing configurations, and diagnosing issues.

## Available Commands

### Main Command
- `voice-mode` - Starts the MCP server (default behavior)
- `voice-mode --debug` - Start with debug mode enabled
- `voice-mode --version` - Show version information
- `voice-mode -h` or `--help` - Show help message

### Service Management
Each service has its own set of commands:

**Whisper (STT)**:
- `voice-mode whisper status|start|stop|restart|enable|disable`
- `voice-mode whisper logs [-n LINES]`
- `voice-mode whisper install [OPTIONS]`
- `voice-mode whisper uninstall [OPTIONS]`
- `voice-mode whisper models` - List available models
- `voice-mode whisper model active [MODEL]` - Show/set active model

**Kokoro (TTS)**:
- `voice-mode kokoro status|start|stop|restart|enable|disable`
- `voice-mode kokoro logs [-n LINES]`
- `voice-mode kokoro install [OPTIONS]`
- `voice-mode kokoro uninstall [OPTIONS]`

**LiveKit (RTC)**:
- `voice-mode livekit status|start|stop|restart|enable|disable`
- `voice-mode livekit logs [-n LINES]`
- `voice-mode livekit install [OPTIONS]`
- `voice-mode livekit uninstall [OPTIONS]`
- `voice-mode livekit frontend [SUBCOMMAND]`

### Configuration
- `voice-mode config list` - List all configuration keys
- `voice-mode config get <key>` - Get a configuration value
- `voice-mode config set <key> <value>` - Set a configuration value

### Diagnostics
- `voice-mode diag info` - Show installation information
- `voice-mode diag devices` - List audio devices
- `voice-mode diag registry` - Show provider registry
- `voice-mode diag dependencies` - Check system dependencies

### Voice Conversation
- `voice-mode converse [OPTIONS]` - Have a voice conversation
- `voice-mode converse --continuous` - Continuous conversation mode

## Usage Examples

### Check Service Status
```bash
voice-mode whisper status
voice-mode kokoro status
voice-mode livekit status
```

### Start Services
```bash
voice-mode whisper start
voice-mode kokoro start
voice-mode livekit start
```

### View Service Logs
```bash
voice-mode whisper logs
voice-mode kokoro logs -n 100
voice-mode livekit logs --lines 50
```

### Install Local Services
```bash
# Install Whisper with specific model
voice-mode whisper install --model large-v2

# Install Kokoro with custom port
voice-mode kokoro install --port 8880

# Install LiveKit with auto-enable
voice-mode livekit install --auto-enable
```

### Manage Whisper Models
```bash
# List all models and their status
voice-mode whisper models

# Set active model
voice-mode whisper model active small.en

# Install a specific model
voice-mode whisper model install large-v3

# Remove a model
voice-mode whisper model remove medium
```

### Voice Conversation
```bash
# Simple conversation
voice-mode converse

# Continuous conversation mode
voice-mode converse --continuous

# Speak without waiting for response
voice-mode converse -m "Hello there!" --no-wait

# Use specific voice
voice-mode converse --voice nova --tts-provider openai
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

- [Complete Commands Reference](commands.md) - Full list of all CLI commands
- [MCP Tools Reference](../mcp/tools.md) - Tools available to AI assistants
- [Service Management](../../services/README.md) - Detailed service documentation
- [Configuration Guide](../../user-guide/configuration.md) - User configuration guide