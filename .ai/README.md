# VoiceMode AI Documentation

This directory contains AI-specific documentation optimized for LLM consumption.

## Purpose

- **Token-efficient**: Concise, factual information without redundancy
- **AI-focused**: Information specifically relevant to AI assistants
- **Testing ground**: Instructions tested here before promotion to tool docstrings
- **Quick reference**: Fast access to common patterns and solutions

## Files in This Directory

- **audio-files.md** - Where to find audio recordings and how they're organized
- **mcp-tools.md** - Tool usage patterns and common parameter combinations
- **workflows.md** - Common AI workflows for voice interactions
- **troubleshooting.md** - Quick solutions to common issues

## Key Information

### Audio File Location
Audio files are stored in:
```
~/.voicemode/audio/YYYY/MM/
```
**Important**: Files are in year/month subdirectories, not directly in audio/

### Configuration
- User config: `~/.voicemode/.voicemode.env`
- Audio saving: `VOICEMODE_SAVE_AUDIO=true` required for recordings
- Base directory: `VOICEMODE_BASE_DIR` (defaults to ~/.voicemode)

### Quick Commands
```python
# Test voice
mcp__voice-mode__converse("Test", wait_for_response=False)

# Check status
mcp__voice-mode__voice_status()

# View registry
mcp__voice-mode__voice_registry()
```

## Promotion Path

Information that proves useful here should be promoted to:
1. Tool docstrings in the Python code
2. MCP server help text
3. Error messages for better context
4. Main documentation for broader audience