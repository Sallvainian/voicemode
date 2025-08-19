# Quick Troubleshooting Guide

## Audio Files Not Found

**Symptom**: Can't find audio recordings
**Solution**: 
1. Check year/month subdirectories: `~/.voicemode/audio/YYYY/MM/`
2. Verify `VOICEMODE_SAVE_AUDIO=true` in config
3. Restart after enabling audio saving

## No Voice Output

**Symptom**: No audio plays
**Solution**:
```python
# Check devices
mcp__voice-mode__check_audio_devices()

# Verify providers
mcp__voice-mode__voice_status()

# Test with simple message
mcp__voice-mode__converse("Test", wait_for_response=False)
```

## Whisper/Kokoro Not Working

**Symptom**: Local services not responding
**Solution**:
```python
# Check service status
mcp__voice-mode__service("whisper", "status")
mcp__voice-mode__service("kokoro", "status")

# Start if needed
mcp__voice-mode__service("whisper", "start")
mcp__voice-mode__service("kokoro", "start")

# Check logs for errors
mcp__voice-mode__service("whisper", "logs", lines=20)
```

## Voice Cutting Off

**Symptom**: Speech gets cut off mid-sentence
**Solution**:
```python
# Increase listen duration
converse("Question", listen_duration=180)  # 3 minutes

# Disable silence detection
converse("Question", disable_silence_detection=True)

# Adjust VAD
converse("Question", vad_aggressiveness=1)  # Less aggressive
```

## WSL2 Audio Issues

**Symptom**: No audio in WSL2
**Solution**:
1. Install PulseAudio: `sudo apt install pulseaudio`
2. Check with: `mcp__voice-mode__check_audio_dependencies()`
3. Run diagnostic: `python scripts/diagnose-wsl-audio.py`

## Provider Errors

**Symptom**: "Provider not responding"
**Solution**:
```python
# Refresh registry
mcp__voice-mode__refresh_provider_registry(optimistic=False)

# Check specific provider
mcp__voice-mode__get_provider_details("http://127.0.0.1:8880/v1")

# Force fallback to OpenAI
converse("Test", tts_provider="openai")
```

## Configuration Not Taking Effect

**Symptom**: Changed config but no effect
**Solution**:
1. Config changes need restart for MCP session
2. Use runtime parameters instead:
   ```python
   converse("Test", voice="nova", tts_provider="kokoro")
   ```

## Memory/Performance Issues

**Symptom**: Slow responses or high memory
**Solution**:
```python
# Check statistics
mcp__voice-mode__voice_statistics()

# Clear old audio files
# rm ~/.voicemode/audio/2025/07/*.wav  # Old month

# Use more efficient format
converse("Test", audio_format="mp3")
```

## Quick Diagnostic Commands

```python
# Full system check
mcp__voice-mode__voice_status()
mcp__voice-mode__check_audio_devices()
mcp__voice-mode__voice_registry()

# Service health
mcp__voice-mode__service("whisper", "status")
mcp__voice-mode__service("kokoro", "status")

# Test voice
mcp__voice-mode__converse("System test", wait_for_response=False)
```