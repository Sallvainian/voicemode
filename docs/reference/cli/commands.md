# Voice Mode CLI Commands Reference

This is the complete list of all Voice Mode CLI commands extracted from the actual implementation.

## Main Command
```bash
voice-mode [--debug] [--version] [-h|--help]
```
Without subcommands, starts the MCP server.

## Service Commands

### Kokoro (TTS Service)
```bash
voice-mode kokoro status                           # Show service status
voice-mode kokoro start                            # Start service
voice-mode kokoro stop                             # Stop service  
voice-mode kokoro restart                          # Restart service
voice-mode kokoro enable                           # Enable at boot/login
voice-mode kokoro disable                          # Disable at boot/login
voice-mode kokoro logs [-n LINES]                  # View service logs
voice-mode kokoro update-service-files             # Update service files
voice-mode kokoro health                           # Check health endpoint
voice-mode kokoro install [OPTIONS]                # Install kokoro-fastapi
voice-mode kokoro uninstall [OPTIONS]              # Uninstall kokoro-fastapi
```

Install options:
- `--install-dir PATH` - Directory to install kokoro-fastapi
- `--port PORT` - Port to configure (default: 8880)
- `-f, --force` - Force reinstall
- `--version VERSION` - Version to install (default: latest)
- `--auto-enable/--no-auto-enable` - Enable service at boot/login

Uninstall options:
- `--remove-models` - Also remove downloaded models
- `--remove-all-data` - Remove all data including logs

### Whisper (STT Service)
```bash
voice-mode whisper status                          # Show service status
voice-mode whisper start                           # Start service
voice-mode whisper stop                            # Stop service
voice-mode whisper restart                         # Restart service
voice-mode whisper enable                          # Enable at boot/login
voice-mode whisper disable                         # Disable at boot/login
voice-mode whisper logs [-n LINES]                 # View service logs
voice-mode whisper update-service-files            # Update service files
voice-mode whisper health                          # Check health endpoint
voice-mode whisper install [OPTIONS]               # Install whisper.cpp
voice-mode whisper uninstall [OPTIONS]             # Uninstall whisper.cpp
voice-mode whisper models                          # List available models
voice-mode whisper model active [MODEL]            # Show/set active model
voice-mode whisper model install MODEL [OPTIONS]   # Install a model
voice-mode whisper model remove MODEL [OPTIONS]    # Remove a model
```

Install options:
- `--install-dir PATH` - Directory to install whisper.cpp
- `--model MODEL` - Model to download (default: large-v2)
- `--use-gpu/--no-gpu` - Enable GPU support
- `-f, --force` - Force reinstall
- `--version VERSION` - Version to install (default: latest)
- `--auto-enable/--no-auto-enable` - Enable service at boot/login

Model install options:
- `-f, --force` - Re-download even if exists
- `--skip-core-ml` - Skip Core ML conversion on Apple Silicon

### LiveKit (RTC Service)
```bash
voice-mode livekit status                          # Show service status
voice-mode livekit start                           # Start service
voice-mode livekit stop                            # Stop service
voice-mode livekit restart                         # Restart service
voice-mode livekit enable                          # Enable at boot/login
voice-mode livekit disable                         # Disable at boot/login
voice-mode livekit logs [-n LINES]                 # View service logs
voice-mode livekit update                          # Update service files
voice-mode livekit install [OPTIONS]               # Install LiveKit server
voice-mode livekit uninstall [OPTIONS]             # Uninstall LiveKit
voice-mode livekit frontend install [OPTIONS]      # Install frontend
voice-mode livekit frontend start [OPTIONS]        # Start frontend
voice-mode livekit frontend stop                   # Stop frontend
voice-mode livekit frontend status                 # Check frontend status
voice-mode livekit frontend open                   # Open in browser
voice-mode livekit frontend logs [-n LINES] [-f]   # View frontend logs
voice-mode livekit frontend enable                 # Enable at boot/login
voice-mode livekit frontend disable                # Disable at boot/login
voice-mode livekit frontend build [-f]             # Build for production
```

LiveKit install options:
- `--install-dir PATH` - Directory to install LiveKit
- `--port PORT` - Port for server (default: 7880)
- `-f, --force` - Force reinstall
- `--version VERSION` - Version to install (default: latest)
- `--auto-enable/--no-auto-enable` - Enable service at boot/login

Frontend start options:
- `--port PORT` - Port to run on (default: 3000)
- `--host HOST` - Host to bind to (default: 127.0.0.1)

## Configuration Commands
```bash
voice-mode config list                             # List all config keys
voice-mode config get KEY                          # Get a config value
voice-mode config set KEY VALUE                    # Set a config value
```

## Shell Completion
```bash
voice-mode completion bash                         # Generate bash completion
voice-mode completion zsh                          # Generate zsh completion
voice-mode completion fish                         # Generate fish completion
voice-mode completion install [--shell SHELL]      # Show install instructions
```

## Diagnostics
```bash
voice-mode diag info                               # Show installation info
voice-mode diag devices                            # List audio devices
voice-mode diag registry                           # Show provider registry
voice-mode diag dependencies                       # Check system dependencies
```

## Exchange Logs
```bash
voice-mode exchanges tail [OPTIONS]                # Tail exchange logs
```

Tail options:
- `-n, --lines LINES` - Number of lines to show (default: 10)
- `-f, --follow` - Follow log output
- `--json` - Output as JSON
- `--no-color` - Disable colored output

## Voice Conversation
```bash
voice-mode converse [OPTIONS]                      # Have a voice conversation
```

Converse options:
- `-m, --message TEXT` - Initial message to speak
- `--wait/--no-wait` - Wait for response (default: wait)
- `-d, --duration SECONDS` - Listen duration (default: 30)
- `--min-duration SECONDS` - Min listen duration (default: 2)
- `--transport [auto|local|livekit]` - Transport method
- `--room-name NAME` - LiveKit room name
- `--voice VOICE` - TTS voice to use
- `--tts-provider [openai|kokoro]` - TTS provider
- `--tts-model MODEL` - TTS model
- `--tts-instructions TEXT` - Style instructions
- `--audio-feedback/--no-audio-feedback` - Audio feedback
- `--audio-format FORMAT` - Audio format
- `--disable-silence-detection` - Disable silence detection
- `--speed RATE` - Speech rate (0.25-4.0)
- `--vad-aggressiveness LEVEL` - VAD level (0-3)
- `--skip-tts/--no-skip-tts` - Skip TTS
- `-c, --continuous` - Continuous conversation mode

## Notes

1. All service commands support the `-h` or `--help` option for help (after our fix)
2. The main command runs the MCP server when called without subcommands
3. Service management commands are consistent across all three services
4. Model management is specific to Whisper
5. Frontend management is specific to LiveKit