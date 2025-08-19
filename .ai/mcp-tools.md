# MCP Tool Usage Patterns

## Essential Tools

### converse
Primary tool for voice interactions.

```python
# Quick test (no waiting)
mcp__voice-mode__converse("Testing", wait_for_response=False)

# Full conversation
mcp__voice-mode__converse("How are you?", wait_for_response=True, listen_duration=120)

# With specific voice
mcp__voice-mode__converse("Hello", voice="nova", tts_provider="openai")

# Disable silence detection for dictation
mcp__voice-mode__converse("Ready to take notes", disable_silence_detection=True)
```

### service
Manage Whisper and Kokoro services.

```python
# Check status
mcp__voice-mode__service("whisper", "status")
mcp__voice-mode__service("kokoro", "status")

# Start/stop
mcp__voice-mode__service("whisper", "start")
mcp__voice-mode__service("kokoro", "stop")

# View logs
mcp__voice-mode__service("whisper", "logs", lines=50)
```

### voice_status
Quick health check of all voice services.

```python
# Check everything
mcp__voice-mode__voice_status()
```

### voice_registry
View available providers and their capabilities.

```python
# See all providers
mcp__voice-mode__voice_registry()
```

### config
Manage VoiceMode configuration.

```python
# Set configuration
mcp__voice-mode__update_config("VOICEMODE_SAVE_AUDIO", "true")

# List all config keys
mcp__voice-mode__list_config_keys()
```

## Common Parameter Combinations

### Long conversations
```python
converse("Tell me a story", listen_duration=300)  # 5 minutes
```

### Quick confirmations
```python
converse("Got it!", wait_for_response=False)
```

### Testing specific providers
```python
# Force local Kokoro
converse("Test", tts_provider="kokoro")

# Force OpenAI
converse("Test", tts_provider="openai")
```

### Handling noisy environments
```python
# More aggressive VAD
converse("Speak clearly", vad_aggressiveness=3)

# Less aggressive for quiet rooms
converse("Whisper test", vad_aggressiveness=0)
```

## Performance Tips

1. **Use `wait_for_response=False`** for status updates while working
2. **Adjust `listen_duration`** based on expected response length
3. **Check `voice_registry()`** if providers aren't responding
4. **Use `service()` to verify local services are running

## Error Patterns

### Provider not responding
```python
# Refresh and retry
mcp__voice-mode__refresh_provider_registry()
mcp__voice-mode__converse("Testing again")
```

### Audio device issues
```python
# Check devices first
mcp__voice-mode__check_audio_devices()
```

### Service not running
```python
# Start required service
mcp__voice-mode__service("whisper", "start")
mcp__voice-mode__service("kokoro", "start")
```