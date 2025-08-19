# Silence Detection

Voice Mode now includes automatic silence detection that can stop recording when the user stops speaking, eliminating the need to wait for the full duration timeout.

## Overview

When enabled, Voice Mode uses WebRTC's Voice Activity Detection (VAD) to monitor audio input in real-time and automatically stop recording after detecting a configurable period of silence. This significantly improves the user experience, especially for short responses.

### Benefits

- **Reduced latency**: No more waiting 17+ seconds after saying "yes" 
- **Natural conversation flow**: Responds as soon as you finish speaking
- **Configurable sensitivity**: Adjust for different environments and use cases
- **Backwards compatible**: Falls back to fixed duration when disabled

## Configuration

Silence detection is controlled by environment variables:

```bash
# Enable/disable silence detection (default: true)
export VOICEMODE_ENABLE_SILENCE_DETECTION=true

# VAD aggressiveness 0-3 (default: 2)
# 0 = least aggressive (more permissive)
# 3 = most aggressive (filters more non-speech)
export VOICEMODE_VAD_AGGRESSIVENESS=2

# Silence threshold in milliseconds (default: 800)
# How long to wait after speech stops before ending recording
export VOICEMODE_SILENCE_THRESHOLD_MS=800

# Minimum recording duration in seconds (default: 0.5)
# Prevents accidentally cutting off very short utterances
export VOICEMODE_MIN_RECORDING_DURATION=0.5
```

## Installation

Silence detection requires the `webrtcvad` package:

```bash
pip install webrtcvad
```

Or if using uvx:
```bash
uvx voice-mode
```

The package is automatically installed with Voice Mode, but if you encounter issues:

```bash
# For Python 3.11+
pip install webrtcvad-wheels

# For older Python versions
pip install webrtcvad
```

## How It Works

1. **Chunked Recording**: Audio is recorded in small chunks (30ms by default)
2. **VAD Processing**: Each chunk is analyzed by WebRTC VAD to detect speech
3. **Silence Tracking**: Consecutive silence chunks are counted
4. **Stop Condition**: Recording stops when silence exceeds the threshold
5. **Safeguards**: Minimum duration prevents premature cutoff

### Technical Details

- Uses WebRTC VAD, the same technology used in web browsers
- Processes 16-bit PCM audio at supported sample rates (8k, 16k, 32k Hz)
- Automatically resamples from Voice Mode's 24kHz to 16kHz for VAD
- Chunk sizes must be 10, 20, or 30ms (configurable)

## Usage Examples

### Basic Usage

No code changes needed! Just set the environment variable:

```bash
# Enable silence detection
export VOICEMODE_ENABLE_SILENCE_DETECTION=true

# Use voice mode as normal
voice-mode converse "What's your name?"
```

### Adjusting Sensitivity

For noisy environments, increase aggressiveness:

```bash
# More aggressive filtering
export VOICEMODE_VAD_AGGRESSIVENESS=3
export VOICEMODE_SILENCE_THRESHOLD_MS=1000  # Wait longer
```

For quiet environments or soft speakers:

```bash
# Less aggressive filtering  
export VOICEMODE_VAD_AGGRESSIVENESS=1
export VOICEMODE_SILENCE_THRESHOLD_MS=600  # Respond faster
```

### Testing

Test silence detection with the manual test script:

```bash
# Run interactive tests
python tests/manual/test_silence_detection_manual.py

# Test with custom settings
VOICEMODE_VAD_AGGRESSIVENESS=3 python tests/manual/test_silence_detection_manual.py
```

## Troubleshooting

### Cutting off too early

If recording stops before you finish speaking:

1. Increase `VOICEMODE_SILENCE_THRESHOLD_MS` (try 1000-1500ms)
2. Decrease `VOICEMODE_VAD_AGGRESSIVENESS` (try 1 or 0)
3. Check microphone levels - very quiet speech may be detected as silence

### Not detecting silence

If recording doesn't stop after speech:

1. Increase `VOICEMODE_VAD_AGGRESSIVENESS` (try 3)
2. Check for background noise that might be detected as speech
3. Ensure webrtcvad is properly installed

### Fallback Behavior

Voice Mode automatically falls back to fixed-duration recording when:

- `webrtcvad` is not installed
- `VOICEMODE_ENABLE_SILENCE_DETECTION=false` 
- VAD initialization fails
- Any errors occur during VAD processing

## Performance

- **CPU Usage**: Minimal (<5% on modern systems)
- **Memory**: ~500KB for VAD model
- **Latency**: 30ms per chunk (configurable)
- **Accuracy**: ~85% true positive rate, ~97% true negative rate

## Implementation Details

The silence detection uses a continuous audio stream with callbacks to avoid microphone indicator flickering:

- **Continuous Stream**: Uses `sd.InputStream` with callbacks instead of repeated `sd.rec()` calls
- **Single Connection**: Maintains one persistent microphone connection throughout recording
- **Queue-Based Processing**: Audio chunks are passed via thread-safe queue for VAD processing
- **No Flickering**: Prevents rapid microphone access/release that causes indicator flickering on Linux/Fedora

## Future Enhancements

Planned improvements include:

1. **LiveKit Turn Detector Integration**: Semantic understanding of pauses
2. **Adaptive Thresholds**: Learn from user patterns
3. **Energy-Based Validation**: Combine VAD with amplitude detection
4. **Multi-Language Support**: Language-specific pause patterns

## API Reference

The silence detection feature is implemented in:

- `record_audio_with_silence_detection()` in `voice_mode/tools/conversation.py`
- Configuration in `voice_mode/config.py`
- Tests in `tests/test_silence_detection.py`

### Programmatic Control

The `converse()` function supports per-interaction control:

```python
# Disable silence detection for this interaction only
await converse("Tell me a story", disable_silence_detection=True)

# Set minimum recording duration to prevent premature cutoffs
await converse(
    "What's your philosophy on life?", 
    min_listen_duration=2.0,  # Record at least 2 seconds
    listen_duration=60.0      # Maximum 60 seconds
)
```

Parameters:
- `disable_silence_detection`: Override global setting for this interaction
- `min_listen_duration`: Minimum recording time before silence detection can stop (default: 2.0)
- `listen_duration`: Maximum recording time (existing parameter)