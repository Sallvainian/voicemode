# Audio Format Migration Guide

## Overview

Voice Mode now uses **PCM** audio format by default for TTS streaming. This change provides:

- **Zero encoding latency** - No compression overhead for real-time streaming
- **Best streaming performance** - Direct audio data without conversion
- **Maximum compatibility** - Works with all audio systems
- **Instant playback** - No decoding required

For STT uploads and audio saving, compressed formats like Opus are still available.

**Important Note**: While Opus was originally intended for streaming due to its low-latency design, in practice it requires full buffering before playback. PCM is the only format that truly supports progressive streaming for TTS.

## Quick Start

For most users, no action is required. Voice Mode will automatically use PCM format for TTS streaming, providing the best real-time performance.

### To Use Compressed Formats

If you prefer compressed formats (trading latency for smaller file sizes):

```bash
export VOICEMODE_TTS_AUDIO_FORMAT="opus"  # or mp3, aac, etc.
```

Or add to your MCP configuration:

```json
{
  "mcpServers": {
    "voice-mode": {
      "command": "uvx",
      "args": ["voice-mode"],
      "env": {
        "OPENAI_API_KEY": "your-key",
        "VOICEMODE_TTS_AUDIO_FORMAT": "opus"
      }
    }
  }
}
```

## Configuration Options

### Basic Configuration

```bash
# Set default format for all operations
export VOICEMODE_AUDIO_FORMAT="pcm"  # Options: pcm, opus, mp3, wav, flac, aac

# PCM is default for TTS streaming (best performance)
export VOICEMODE_TTS_AUDIO_FORMAT="pcm"
```

### Advanced Configuration

```bash
# Different formats for TTS and STT
export VOICEMODE_TTS_AUDIO_FORMAT="pcm"    # For text-to-speech (default)
export VOICEMODE_STT_AUDIO_FORMAT="opus"   # For speech-to-text upload

# Quality settings (for compressed formats)
export VOICEMODE_OPUS_BITRATE="32000"      # Opus bitrate (default: 32kbps)
export VOICEMODE_MP3_BITRATE="64k"         # MP3 bitrate (default: 64k)
export VOICEMODE_AAC_BITRATE="64k"         # AAC bitrate (default: 64k)
```

## Provider Compatibility

Voice Mode automatically validates format compatibility with your providers:

| Provider | TTS Formats | STT Formats |
|----------|-------------|-------------|
| OpenAI | opus, mp3, aac, flac, wav, pcm | mp3, opus, wav, flac, m4a, webm |
| Kokoro (local) | mp3, wav | N/A |
| Whisper.cpp (local) | N/A | wav, mp3, opus, flac, m4a |

If you select an unsupported format, Voice Mode will automatically fallback to a compatible format.

## Migration from Existing Setup

### Checking Your Current Setup

If you have existing audio files saved with `VOICEMODE_SAVE_AUDIO=true`, they are likely in MP3 or Opus format. You can check:

```bash
ls ~/voicemode_audio/
```

### Gradual Migration

You can run multiple formats side-by-side:

1. Keep existing compressed audio files
2. TTS streaming uses PCM for best performance
3. STT uploads can use compressed formats
4. All formats work seamlessly together

### Converting Existing Files

To convert existing MP3 files to Opus (optional):

```bash
# Using ffmpeg
for file in ~/voicemode_audio/*.mp3; do
    ffmpeg -i "$file" -c:a libopus -b:a 32k "${file%.mp3}.opus"
done
```

## Troubleshooting

### Issue: "Provider doesn't support format"

Voice Mode will automatically fallback to a supported format. You'll see a log message like:
```
Format 'opus' not supported by kokoro, using 'mp3' instead
```

Note: PCM is universally supported for streaming.

### Issue: "Audio playback issues"

Some older systems might have issues with Opus playback. Try:

1. Update your audio libraries:
   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt install libopus0 libopusfile0
   
   # macOS
   brew install opus opus-tools
   ```

2. Or switch to a compressed format:
   ```bash
   export VOICEMODE_TTS_AUDIO_FORMAT="mp3"
   ```

### Issue: "Larger file sizes than expected"

Opus files might appear larger if saved in an OGG container. The actual audio data is still compressed efficiently.

## Format Comparison

| Format | File Size* | Quality | Latency | Best For |
|--------|-----------|---------|---------|----------|
| PCM | N/A (streaming) | Uncompressed | Zero | TTS streaming (default) |
| Opus | Smallest (100KB) | Excellent for voice | High (buffering required) | STT uploads, saving |
| MP3 | Medium (500KB) | Good | Low | Wide compatibility |
| AAC | Medium (450KB) | Good | Low | Apple ecosystem |
| FLAC | Large (2MB) | Lossless | Low | Archival |
| WAV | Largest (5MB) | Uncompressed | Zero | Local processing |

*Approximate sizes for 1 minute of speech

## Benefits of PCM for Streaming

1. **Zero Latency**: No encoding/decoding overhead
2. **Best Performance**: Direct audio playback
3. **Universal Support**: Works on all systems
4. **Streaming Optimized**: No buffering for format conversion
5. **Real-time Ready**: Perfect for live conversations

## Benefits of Opus for Uploads

1. **Bandwidth Efficiency**: Crucial for cloud API calls
2. **Small File Size**: 50-80% smaller than MP3
3. **Voice Optimized**: Designed for speech
4. **Wide Platform Support**: Works on modern systems
5. **Future-proof**: Active development

## Changing Default Formats

To change from PCM streaming to compressed formats:

1. Set environment variables:
   ```bash
   # For TTS streaming (consider latency impact)
   export VOICEMODE_TTS_AUDIO_FORMAT="opus"
   
   # For STT uploads (already uses compression by default)
   export VOICEMODE_STT_AUDIO_FORMAT="mp3"
   ```

2. Or update your MCP configuration as shown above

3. Restart your MCP client

PCM provides the best streaming performance, but compressed formats are useful for:
- Reducing bandwidth usage
- Saving audio files
- STT uploads to cloud services