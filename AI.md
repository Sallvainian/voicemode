# Instructions for Claude - Voice Mode Project

## 🎯 Project Overview
Voice Mode brings natural voice conversations to AI assistants through the Model Context Protocol (MCP). It's a Python MCP server that enables voice interactions in Claude Code, Cursor, VS Code, and other MCP-compatible tools.

**Core Value Proposition**: Seamless voice interactions with automatic fallback between cloud (OpenAI) and local (Whisper/Kokoro) services.

## 📚 Essential Reading
- `@README.md` - Project overview and features
- `@GLOSSARY.md` - Key terms and concepts (MUST READ for terminology)
- `@INSIGHTS.md` - Important learnings and design decisions
- `@.repos.txt` - Related repositories and dependencies
- `@CHANGELOG.md` - Recent changes and version history

## 🚀 Wake-Up Protocol

1. Run `git status` to understand current work state
2. Check if any services are running: `service("whisper", "status")`, `service("kokoro", "status")`
3. Check for any existing session notes or context files
4. Review recent commits with `git log --oneline -5`

## 🏗️ Voice Stack Overview

The voice-mode project now has a complete local voice processing stack:

### Services (Optional Local Setup)
Voice Mode works with OpenAI by default. For local/offline use, you can run:
- **Whisper.cpp STT** (Port 2022): Local speech-to-text with OpenAI-compatible API
- **Kokoro TTS** (Port 8880): Local text-to-speech with OpenAI-compatible API  

Voice Mode automatically detects these services and uses them when available, falling back to OpenAI if not found.

### Architecture Notes
- Voice Mode is a pure Python MCP server
- Automatic service discovery and fallback
- Works with any OpenAI-compatible API
- No installation of third-party services required

### OpenAI API Usage
- Use OpenAI API whenever possible as self hosted alternatives support it and we can use them by setting OPENAI_BASE_URL

## 🛠️ Service Management

### Service Management Commands
When the user asks about Kokoro or Whisper service status, starting, stopping, etc.:
- Use the `service` tool with the appropriate service_name and action
- Examples:
  - "start kokoro" → `service("kokoro", "start")`
  - "stop whisper" → `service("whisper", "stop")`
  - "is kokoro running?" → `service("kokoro", "status")`
  - "show whisper logs" → `service("whisper", "logs")`
  
The service tool handles both Whisper (STT) and Kokoro (TTS) services uniformly.

## 📁 VoiceMode Directory Structure

### VoiceMode Home Directory (~/.voicemode/)
The VoiceMode Home Directory stores all user data, services, and configuration:

```
~/.voicemode/                  # VOICEMODE_BASE_DIR
├── audio/                     # Audio recordings (when VOICEMODE_SAVE_AUDIO=true)
│   └── YYYY/                  # Year subdirectory
│       └── MM/                # Month subdirectory
│           ├── YYYYMMDD_HHMMSS_*_tts.wav  # Text-to-speech audio
│           └── YYYYMMDD_HHMMSS_*_stt.wav  # Speech-to-text audio
├── logs/                      # All log files
│   ├── conversations/         # Exchange logs (JSONL format)
│   │   └── exchanges_YYYY-MM-DD.jsonl
│   └── events/                # Event logs
│       └── voicemode_events_YYYY-MM-DD.jsonl
├── services/                  # Installed services
│   ├── whisper.cpp/          # Whisper STT service (if installed)
│   ├── kokoro/               # Kokoro TTS service (if installed)
│   └── livekit/              # LiveKit server (if installed)
├── models/                    # Downloaded models
│   ├── whisper/              # Whisper models
│   └── kokoro/               # Kokoro models
├── cache/                     # Cached data
│   └── kokoro/               # Kokoro cache
├── config/                    # Additional configurations
├── transcriptions/            # Saved transcriptions
├── .voicemode.env            # User configuration
└── whisper-server.log        # Whisper service log (if running)
```

### Important Notes:
- **Audio files are in year/month subdirectories**, not directly in audio/
- Audio only saved when `VOICEMODE_SAVE_AUDIO=true`
- Logs are in JSONL format with one JSON object per line
- Configuration in `.voicemode.env` overrides defaults

## 📝 Code Style & Conventions

### Important Instruction Reminders
- Do what has been asked; nothing more, nothing less
- NEVER create files unless they're absolutely necessary for achieving your goal
- ALWAYS prefer editing an existing file to creating a new one
- NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User

### Personal Preferences Note
- These conventions are personal preferences, not rigid rules
- Adapt suggestions to fit the specific project context
- When in doubt, ask for clarification rather than assume

### File Organization
```
voice_mode/
├── __init__.py          # Package initialization
├── cli.py               # MCP server entry point
├── server.py            # Main MCP server implementation
├── tools/               # Individual tool implementations
├── services/            # Service management (Whisper, Kokoro, etc.)
├── utils/               # Shared utilities
└── provider_registry.py # Provider discovery and management
```

## 🚦 Git Workflow Reminders

- Review and update CHANGELOG before each git commit
- Check for uncommitted service configs
- Verify no API keys in code
- Run tests before committing

### Commit Message Format
```
type: brief description

- Detail 1
- Detail 2

Fixes #issue
```

Types: feat, fix, docs, refactor, test, chore

## 🧪 Testing Voice Interactions

### Quick Test Commands
```python
# Quick test
mcp__voice-mode__converse("Testing voice mode", wait_for_response=False)

# Full conversation test
mcp__voice-mode__converse("How are you today?")

# Check audio devices
mcp__voice-mode__check_audio_devices()

# Check service status
mcp__voice-mode__voice_status()

# View provider registry
mcp__voice-mode__voice_registry()

# View statistics
mcp__voice-mode__voice_statistics()
```

### Before Committing
1. Test core conversation flow: `converse("test")`
2. Verify provider registry: `voice_registry()`
3. Check service status if modified: `service("whisper", "status")`
4. Run linting: `ruff check voice_mode/`
5. Update CHANGELOG.md with changes

## ⚠️ Important Gotchas & Edge Cases

### Audio Format Handling
- **Default**: PCM for lowest latency streaming
- **Opus**: Avoid for streaming (quality issues)
- **Validation**: Always validate format against provider capabilities

### WSL2 Specific Issues
- Requires PulseAudio bridge for microphone access
- Additional packages needed: `pulseaudio`, `libasound2-plugins`
- Debug script: `scripts/diagnose-wsl-audio.py`

### Provider Health Checks
- Initial optimistic assumption (all healthy on start)
- Lazy health checks on first use
- Exponential backoff for failed providers
- Manual refresh: `mcp__voice-mode__refresh_provider_registry()`

## 🐛 Common Issues & Solutions

### "No audio devices found"
- Check: `mcp__voice-mode__check_audio_devices()`
- WSL2: Ensure PulseAudio is running
- macOS: Check terminal permissions

### "Provider not responding"
- Refresh registry: `mcp__voice-mode__refresh_provider_registry()`
- Check service: `service("kokoro", "status")`
- Verify ports: 8880 (Kokoro), 2022 (Whisper)

### "Audio cutting off"
- Increase listen_duration in converse()
- Adjust VAD aggressiveness (0-3)
- Disable silence detection if needed

## 📋 Environment Variables

### Essential
- `OPENAI_API_KEY`: Required for cloud services
- `VOICEMODE_DEBUG`: Enable debug logging
- `VOICEMODE_SAVE_AUDIO`: Save all audio files

### Advanced
- `STT_BASE_URL`: Custom STT endpoint
- `TTS_BASE_URL`: Custom TTS endpoint
- `VOICEMODE_AUDIO_FORMAT`: Audio format (pcm/mp3/wav/etc)
- `VOICEMODE_VAD_AGGRESSIVENESS`: Voice detection (0-3)

## 💡 Quick Decision Guide

**User asks about voice not working?**
→ Check `voice_status()`, then `check_audio_devices()`

**User wants local/offline mode?**
→ Install Whisper and Kokoro services

**Audio quality issues?**
→ Check audio format, try PCM or WAV

**Performance problems?**
→ View statistics, check provider latency

**Can't find audio recordings?**
→ Check `~/.voicemode/audio/YYYY/MM/` (year/month subdirs)
→ Verify `VOICEMODE_SAVE_AUDIO=true` is set

**Want to replay conversations?**
→ Find audio files in `~/.voicemode/audio/YYYY/MM/`
→ Create .m3u playlist with absolute paths
→ Play with `mpv --playlist=conversation.m3u`

**Integration with new tool?**
→ Check docs/integrations/ for examples

## 🔧 Development Tips

1. **Always test with real voice**: Text testing misses audio issues
2. **Monitor provider health**: Registry can get stale
3. **Check service logs**: Often reveal configuration issues
4. **Use debug mode liberally**: `VOICEMODE_DEBUG=true`
5. **Save audio for debugging**: `VOICEMODE_SAVE_AUDIO=true`

---

*Remember: This guide is for AI assistants working on Voice Mode. Keep it practical and actionable.*