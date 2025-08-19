# Provider Base URL Lists Specification

## Overview

This specification describes a system for configuring multiple TTS and STT base URLs as comma-separated lists, with automatic discovery, failover, and provider auto-detection.

## Design Principles

1. **OpenAI API Compatibility**: All endpoints must be OpenAI API-compatible
2. **Graceful Degradation**: Handle missing endpoints gracefully
3. **Priority-Based Selection**: Use URLs in the order specified by the user
4. **Transparent to LLM**: The LLM doesn't need to know which provider is being used

## Environment Variables

### Core Configuration (No Backward Compatibility)

```bash
# Comma-separated list of TTS base URLs (tried in order)
VOICEMODE_TTS_BASE_URLS=http://127.0.0.1:8880/v1,https://api.openai.com/v1

# Comma-separated list of STT base URLs (tried in order)
VOICEMODE_STT_BASE_URLS=http://127.0.0.1:2022/v1,https://api.openai.com/v1

# Comma-separated list of preferred TTS voices (tried in order of availability)
VOICEMODE_TTS_VOICES=af_sky,nova,alloy

# Comma-separated list of preferred TTS models (optional)
VOICEMODE_TTS_MODELS=tts-1,gpt-4o-mini-tts

# API key for authentication (required)
OPENAI_API_KEY=sk-...
```

## Discovery Process

### On Startup

1. **Iterate through each base URL** in `VOICEMODE_TTS_BASE_URLS` and `VOICEMODE_STT_BASE_URLS`
2. **Health Check**: Verify endpoint is reachable
3. **Model Discovery**: Query `/v1/models` endpoint
4. **Voice Discovery** (TTS only):
   - If URL contains "openai.com" → assume OpenAI voices: `["alloy", "echo", "fable", "nova", "onyx", "shimmer"]`
   - Otherwise → try `/v1/audio/voices` (Kokoro endpoint)
   - If voices endpoint fails but health check passes → assume OpenAI voices
5. **Build Registry**: Store discovered capabilities for runtime use

### Voice Discovery Logic

```python
async def discover_voices(base_url: str, client: AsyncOpenAI) -> List[str]:
    """Discover available voices for a TTS endpoint."""
    
    # OpenAI doesn't have a voices endpoint, use known list
    if "openai.com" in base_url:
        return ["alloy", "echo", "fable", "nova", "onyx", "shimmer"]
    
    # Try Kokoro-style voices endpoint
    try:
        response = await client.get("/v1/audio/voices")
        return response.json()["voices"]
    except:
        # If endpoint doesn't exist but server is healthy, assume OpenAI voices
        return ["alloy", "echo", "fable", "nova", "onyx", "shimmer"]
```

## Registry Structure

The registry stores discovered capabilities for each base URL:

```json
{
  "tts": {
    "http://127.0.0.1:8880/v1": {
      "healthy": true,
      "models": ["tts-1"],
      "voices": ["af_sky", "af_sarah", "am_adam", "af_nicole", "am_michael"],
      "last_health_check": "2024-01-20T10:30:00Z",
      "response_time_ms": 45
    },
    "https://api.openai.com/v1": {
      "healthy": true,
      "models": ["tts-1", "tts-1-hd", "gpt-4o-mini-tts"],
      "voices": ["alloy", "echo", "fable", "nova", "onyx", "shimmer"],
      "last_health_check": "2024-01-20T10:30:00Z",
      "response_time_ms": 120
    }
  },
  "stt": {
    "http://127.0.0.1:2022/v1": {
      "healthy": true,
      "models": ["whisper-1"],
      "last_health_check": "2024-01-20T10:30:00Z",
      "response_time_ms": 30
    }
  }
}
```

## Selection Algorithm

When a TTS request is made:

1. **Iterate through healthy endpoints** in the order specified by `VOICEMODE_TTS_BASE_URLS`
2. **Find first endpoint** that supports the requested voice (or first preferred voice)
3. **Use that endpoint** for the request

### Selection Priority

1. User-specified voice/model/provider (if provided)
2. First available voice from `VOICEMODE_TTS_VOICES`
3. First available model from `VOICEMODE_TTS_MODELS`
4. First healthy endpoint from `VOICEMODE_TTS_BASE_URLS`

### Example Selection

Given:
```bash
VOICEMODE_TTS_BASE_URLS=http://127.0.0.1:8880/v1,https://api.openai.com/v1
VOICEMODE_TTS_VOICES=af_sky,nova,alloy
```

If 127.0.0.1:8880 is healthy and has `af_sky`, use it. Otherwise, check if OpenAI has `nova` or `alloy`.

## Registry Updates

### When to Update

1. **On startup**: Full discovery of all endpoints
2. **On request failure**: Health check the failed endpoint
3. **Manual refresh**: Via MCP tool/command
4. **No periodic refresh**: Not needed for typical use

### Failure Handling

When a request fails:
1. Mark endpoint as unhealthy in registry
2. Retry with next available endpoint
3. Run health check on failed endpoint
4. Update registry based on health check result

## LLM Integration

The LLM can query the registry to see available options:

```python
async def get_voice_registry() -> Dict:
    """Return the current provider registry for LLM inspection."""
    return {
        "tts": {
            url: {
                "healthy": info["healthy"],
                "models": info["models"],
                "voices": info["voices"],
                "response_time_ms": info["response_time_ms"]
            }
            for url, info in registry["tts"].items()
        },
        "stt": {
            url: {
                "healthy": info["healthy"],
                "models": info["models"],
                "response_time_ms": info["response_time_ms"]
            }
            for url, info in registry["stt"].items()
        }
    }
```

## Configuration Examples

### Minimal Configuration
```bash
# Only API key required - defaults to OpenAI
OPENAI_API_KEY=sk-...
```

### Local Development
```bash
VOICEMODE_TTS_BASE_URLS=http://127.0.0.1:8880/v1,https://api.openai.com/v1
VOICEMODE_STT_BASE_URLS=http://127.0.0.1:2022/v1,https://api.openai.com/v1
VOICEMODE_TTS_VOICES=af_sky,nova,alloy
OPENAI_API_KEY=sk-...
```

### Production with Fallback
```bash
VOICEMODE_TTS_BASE_URLS=http://tts-prod.internal/v1,http://tts-backup.internal/v1,https://api.openai.com/v1
VOICEMODE_STT_BASE_URLS=http://stt-prod.internal/v1,https://api.openai.com/v1
VOICEMODE_TTS_VOICES=nova,alloy,echo
VOICEMODE_TTS_MODELS=gpt-4o-mini-tts,tts-1-hd,tts-1
OPENAI_API_KEY=sk-...
```

## Implementation Notes

1. **Remove all legacy environment variables** (TTS_BASE_URL, STT_BASE_URL, etc.)
2. **No provider-specific code** - everything uses OpenAI API
3. **Graceful fallback** - if primary fails, try next URL
4. **Fast selection** - use pre-discovered registry, no discovery during requests
5. **Simple configuration** - just list URLs and preferences