# Voice Mode Tools Reference

Voice Mode provides several tools through the Model Context Protocol (MCP) for voice interactions.

## Available Tools

### converse

Have a voice conversation - speak a message and optionally listen for response.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `message` | string | required | The message to speak |
| `wait_for_response` | boolean | `true` | Whether to listen for a response after speaking |
| `listen_duration` | number | `30.0` | Maximum time to listen for response in seconds |
| `min_listen_duration` | number | `1.0` | Minimum time to record before silence detection can stop |
| `transport` | string | `"auto"` | Transport method: "auto", "local", or "livekit" |
| `voice` | string | auto | TTS voice override (e.g., "nova", "alloy", "af_sky") |
| `tts_provider` | string | auto | TTS provider: "openai" or "kokoro" |
| `tts_model` | string | auto | TTS model (e.g., "tts-1", "tts-1-hd", "gpt-4o-mini-tts") |
| `tts_instructions` | string | none | Tone/style instructions for gpt-4o-mini-tts model |

**Example:**
```python
converse("Hello, how can I help you today?", wait_for_response=True, listen_duration=45)
```

### listen_for_speech

Listen for speech and convert to text.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `duration` | number | `5.0` | How long to listen in seconds |
| `min_listen_duration` | number | `1.0` | Minimum time to record before silence detection |

### check_room_status

Check LiveKit room status and participants.

**Parameters:** None

### check_audio_devices

List available audio input and output devices.

**Parameters:** None

### voice_status

Check the status of all voice services including TTS, STT, LiveKit, and audio devices.

**Parameters:** None

### kokoro_start

Start the Kokoro TTS service.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `models_dir` | string | `~/Models/kokoro` | Path to Kokoro models directory |

### kokoro_stop

Stop the Kokoro TTS service.

**Parameters:** None

### kokoro_status

Check the status of Kokoro TTS service.

**Parameters:** None

## Voice Statistics Tools

### voice_statistics

Display live statistics dashboard for voice conversation performance.

**Parameters:** None

### voice_statistics_summary

Get a concise summary of voice conversation performance metrics.

**Parameters:** None

### voice_statistics_recent

Show recent voice conversation interactions with timing details.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `limit` | integer | `10` | Maximum number of recent interactions (max: 50) |

### voice_statistics_reset

Reset all voice conversation statistics and start a new session.

**Parameters:** None

### voice_statistics_export

Export detailed voice conversation statistics as JSON data.

**Parameters:** None