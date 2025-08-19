# Common VoiceMode Workflows

## Retrieving Past Conversations

### 1. Find the conversation in logs
```bash
# Search by keyword
grep -i "keyword" ~/.voicemode/logs/conversations/exchanges_*.jsonl

# Search by date
cat ~/.voicemode/logs/conversations/exchanges_2025-08-19.jsonl | grep "17:35"
```

### 2. Locate audio files
```bash
# Extract conversation ID from logs
# Look for audio files with that ID
ls ~/.voicemode/audio/2025/08/*_06kph6_*.wav
```

### 3. Create playlist
```bash
# Create .m3u file with absolute paths
cat > conversation.m3u << EOF
/home/user/.voicemode/audio/2025/08/20250819_173229_835_06kph6_tts.wav
/home/user/.voicemode/audio/2025/08/20250819_173316_290_06kph6_stt.wav
EOF

# Play the conversation
mpv --playlist=conversation.m3u
```

## Setting Up for First Use

### 1. Enable audio saving
```python
mcp__voice-mode__update_config("VOICEMODE_SAVE_AUDIO", "true")
```

### 2. Check audio devices
```python
mcp__voice-mode__check_audio_devices()
```

### 3. Test voice
```python
mcp__voice-mode__converse("Testing voice mode", wait_for_response=True)
```

## Local/Offline Setup

### 1. Install services
```bash
voice-mode whisper install
voice-mode kokoro install
```

### 2. Start services
```python
mcp__voice-mode__service("whisper", "start")
mcp__voice-mode__service("kokoro", "start")
```

### 3. Verify providers
```python
mcp__voice-mode__voice_registry()  # Should show local endpoints
```

## Troubleshooting Voice Issues

### No audio input
1. Check devices: `mcp__voice-mode__check_audio_devices()`
2. Check dependencies: `mcp__voice-mode__check_audio_dependencies()`
3. Test with different transport: `converse("Test", transport="local")`

### Poor audio quality
1. Try different format: `converse("Test", audio_format="wav")`
2. Adjust VAD: `converse("Test", vad_aggressiveness=2)`
3. Check provider latency: `mcp__voice-mode__voice_statistics()`

### Services not responding
1. Check status: `mcp__voice-mode__service("whisper", "status")`
2. View logs: `mcp__voice-mode__service("whisper", "logs")`
3. Restart: `mcp__voice-mode__service("whisper", "restart")`

## Performance Monitoring

### Check statistics
```python
# Detailed stats
mcp__voice-mode__voice_statistics()

# Summary only
mcp__voice-mode__voice_statistics_summary()

# Recent interactions
mcp__voice-mode__voice_statistics_recent(limit=10)
```

### Monitor providers
```python
# Check health
mcp__voice-mode__voice_status()

# Refresh if stale
mcp__voice-mode__refresh_provider_registry()
```

## Switching Providers

### Use specific provider
```python
# Force OpenAI
converse("Hello", tts_provider="openai")

# Force Kokoro
converse("Hello", tts_provider="kokoro")

# Let system choose (default)
converse("Hello")
```

### Change default voice
```python
mcp__voice-mode__update_config("VOICEMODE_TTS_VOICE", "nova")
```