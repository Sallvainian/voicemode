# VAD (Voice Activity Detection) Debugging Guide

This guide explains how to debug Voice Activity Detection issues in Voice Mode.

## Enabling VAD Debug Mode

To enable detailed VAD debugging output, set the environment variable:

```bash
export VOICEMODE_VAD_DEBUG=true
```

This will output detailed information to stderr including:
- VAD configuration at startup
- Real-time speech detection decisions
- State transitions (WAITING_FOR_SPEECH → SPEECH_ACTIVE)
- Silence accumulation tracking
- Final recording state

## Debug Output Format

When VAD_DEBUG is enabled, you'll see output like:

```
[VAD_DEBUG] Starting VAD recording with config:
[VAD_DEBUG]   max_duration: 120.0s
[VAD_DEBUG]   min_duration: 2.0s
[VAD_DEBUG]   effective_min_duration: 2.0s
[VAD_DEBUG]   VAD aggressiveness: 2
[VAD_DEBUG]   Silence threshold: 800ms
[VAD_DEBUG]   Sample rate: 24000Hz (VAD using 16000Hz)
[VAD_DEBUG]   Chunk duration: 30ms

[VAD_DEBUG] t=0.5s: speech=False, RMS=125, state=WAITING
[VAD_DEBUG] t=1.0s: speech=False, RMS=132, state=WAITING
[VAD_DEBUG] t=1.5s: speech=True, RMS=1856, state=WAITING
[VAD_DEBUG] STATE CHANGE: WAITING_FOR_SPEECH -> SPEECH_ACTIVE at t=1.5s
[VAD_DEBUG] t=2.0s: speech=True, RMS=2134, state=ACTIVE
[VAD_DEBUG] t=2.5s: speech=False, RMS=145, state=ACTIVE
[VAD_DEBUG] Accumulating silence: 100/800ms, t=2.6s
[VAD_DEBUG] Accumulating silence: 200/800ms, t=2.7s
...
[VAD_DEBUG] Accumulating silence: 800/800ms, t=3.4s
[VAD_DEBUG] STOP: silence_duration=800ms >= threshold=800ms
[VAD_DEBUG] STOP: recording_duration=3.4s >= min_duration=2.0s
[VAD_DEBUG] FINAL STATE: Speech was detected, recording complete
```

## Common Issues and Solutions

### Issue: Recording Stops Before Speech

**Symptom**: Recording ends with "No speech detected" even though you haven't spoken yet.

**Debug with**: 
```bash
export VOICEMODE_VAD_DEBUG=true
python scripts/test-vad-enhancement.py
```

**Look for**: Check if the VAD is incorrectly detecting noise as speech early in the recording.

**Solutions**:
1. Increase VAD aggressiveness: `export VOICEMODE_VAD_AGGRESSIVENESS=3`
2. Ensure you're in a quiet environment
3. Check microphone sensitivity

### Issue: Recording Doesn't Stop After Speech

**Symptom**: Recording continues for the full duration even after you stop speaking.

**Debug output to check**:
- Are silence periods being detected? Look for "Accumulating silence" messages
- Is the silence threshold being reached?

**Solutions**:
1. Decrease VAD aggressiveness: `export VOICEMODE_VAD_AGGRESSIVENESS=1`
2. Reduce silence threshold: `export VOICEMODE_SILENCE_THRESHOLD_MS=600`

### Issue: Recording Cuts Off Mid-Speech

**Symptom**: Recording stops while you're still speaking.

**Debug output to check**:
- Look for rapid state changes between speech and silence
- Check if min_duration is being respected

**Solutions**:
1. Increase min_listen_duration in the converse call
2. Increase silence threshold: `export VOICEMODE_SILENCE_THRESHOLD_MS=1200`

## VAD Configuration Parameters

| Parameter | Environment Variable | Default | Description |
|-----------|---------------------|---------|-------------|
| VAD Aggressiveness | `VOICEMODE_VAD_AGGRESSIVENESS` | 2 | 0-3, higher = more aggressive filtering |
| Silence Threshold | `VOICEMODE_SILENCE_THRESHOLD_MS` | 800ms | How long to wait after speech stops |
| Min Recording Duration | `VOICEMODE_MIN_RECORDING_DURATION` | 0.5s | Global minimum recording time |
| min_listen_duration | Function parameter | 2.0s | Per-call minimum recording time |

## Testing VAD Enhancement

Use the included test script to verify VAD behavior:

```bash
# Test waiting for speech
python scripts/test-vad-enhancement.py

# With debug output
export VOICEMODE_VAD_DEBUG=true
python scripts/test-vad-enhancement.py
```

This script will:
1. Wait indefinitely for you to speak
2. Start recording when speech is detected
3. Stop after silence threshold is reached
4. Report whether speech was detected

## Implementation Details

The VAD operates as a state machine with three states:

1. **WAITING_FOR_SPEECH**: 
   - Initial state
   - No timeout - waits indefinitely
   - Transitions to SPEECH_ACTIVE when speech detected

2. **SPEECH_ACTIVE**:
   - Active recording state
   - Resets silence counter when speech detected
   - Transitions to SILENCE_AFTER_SPEECH when silence detected

3. **SILENCE_AFTER_SPEECH**:
   - Accumulates silence duration
   - Stops recording when:
     - Silence duration >= threshold AND
     - Total recording duration >= min_duration

This ensures recordings don't cut off before speech begins or end prematurely.