# Streaming Audio Playback Specification

## Overview

This specification describes implementing progressive/streaming audio playback in voicemode to reduce latency by playing audio as it arrives rather than waiting for the complete file.

## Current State

- Audio is fully downloaded before playback begins
- Uses `with_streaming_response.create()` but reads entire response
- Adds 3-6 seconds of latency for TTS generation
- All formats are buffered completely before playing

## Proposed Implementation

### 1. Streaming Architecture

```python
async def stream_tts_audio(text: str, client: AsyncOpenAI, **params):
    """Stream TTS audio with progressive playback."""
    
    # Audio pipeline components
    audio_queue = asyncio.Queue(maxsize=10)  # Buffer chunks
    playback_started = asyncio.Event()
    playback_complete = asyncio.Event()
    
    # Download task
    async def download_chunks():
        async with client.audio.speech.with_streaming_response.create(
            **params
        ) as response:
            async for chunk in response.iter_bytes(chunk_size=4096):
                await audio_queue.put(chunk)
        await audio_queue.put(None)  # Signal end
    
    # Playback task
    async def play_chunks():
        # Initialize audio stream
        stream = await create_audio_stream(params['response_format'])
        
        while True:
            chunk = await audio_queue.get()
            if chunk is None:
                break
            
            # Decode and play chunk
            await stream.play_chunk(chunk)
            
            if not playback_started.is_set():
                playback_started.set()
        
        await stream.close()
        playback_complete.set()
    
    # Run both tasks concurrently
    download_task = asyncio.create_task(download_chunks())
    playback_task = asyncio.create_task(play_chunks())
    
    # Wait for playback to start
    await playback_started.wait()
    
    # Continue both tasks
    await asyncio.gather(download_task, playback_task)
```

### 2. Format-Specific Considerations

#### PCM (Recommended for Streaming)
- **Advantage**: No decoding needed, direct playback
- **Disadvantage**: Large bandwidth requirement
- **Use case**: Local TTS with minimal latency

#### Opus
- **Container**: OGG with Opus codec
- **Advantages**: 
  - Designed for low-latency streaming
  - Small chunk sizes (2.5-60ms frames)
  - Built-in error resilience
- **Implementation**: Use `opuslib` or `pyogg` for decoding
- **Critical Limitation**: Doesn't work for streaming - must be fully buffered before playback
- **Recommendation**: Use PCM for streaming TTS, Opus only for file storage

#### MP3
- **Challenge**: Frame boundaries may not align with chunks
- **Solution**: Buffer until valid frame header found
- **Typical frame size**: ~400-1400 bytes

### 3. Audio Playback Backend Options

#### Option 1: PyAudio Streaming (Cross-platform)
```python
import pyaudio

class PyAudioStream:
    def __init__(self, format, channels, rate):
        self.pa = pyaudio.PyAudio()
        self.stream = self.pa.open(
            format=format,
            channels=channels,
            rate=rate,
            output=True,
            stream_callback=self.callback,
            frames_per_buffer=1024
        )
        self.buffer = queue.Queue()
    
    def callback(self, in_data, frame_count, time_info, status):
        # Pull from buffer and play
        data = self.get_audio_data(frame_count)
        return (data, pyaudio.paContinue)
```

#### Option 2: Sounddevice Streaming
```python
import sounddevice as sd
import numpy as np

class SoundDeviceStream:
    def __init__(self, samplerate, channels):
        self.buffer = asyncio.Queue()
        self.stream = sd.OutputStream(
            samplerate=samplerate,
            channels=channels,
            callback=self.audio_callback,
            blocksize=2048
        )
    
    async def play_chunk(self, audio_data):
        await self.buffer.put(audio_data)
```

### 4. Buffering Strategy

- **Initial buffer**: 100-200ms before starting playback
- **Adaptive buffering**: Adjust based on network conditions
- **Underrun handling**: Pause and rebuffer if needed
- **Maximum buffer**: 1-2 seconds to prevent memory issues

### 5. Implementation Phases

#### Phase 1: Basic Streaming (PCM/WAV)
- Implement streaming for uncompressed formats
- Test latency improvements
- Establish buffering parameters

#### Phase 2: Compressed Format Support
- Implement MP3 frame boundary detection
- Handle format-specific quirks

#### Phase 3: Adaptive Streaming
- Monitor buffer health
- Adjust chunk sizes dynamically
- Implement quality fallback

### 6. Configuration

```bash
# Enable streaming playback
VOICEMODE_STREAMING_ENABLED=true

# Initial buffer size (ms)
VOICEMODE_STREAM_BUFFER_MS=150

# Chunk size for download
VOICEMODE_STREAM_CHUNK_SIZE=4096

# Maximum buffer size (seconds)
VOICEMODE_STREAM_MAX_BUFFER=2.0
```

### 7. Error Handling

- **Network interruption**: Pause playback, attempt reconnection
- **Decoder errors**: Skip corrupted chunks, log warnings
- **Buffer underrun**: Insert silence, increase buffer size
- **Format incompatibility**: Fall back to buffered playback

### 8. Metrics and Monitoring

Track these metrics for optimization:
- Time to first audio (TTFA)
- Buffer underrun count
- Average buffer level
- Network throughput
- Chunk decode time

### 9. Testing Strategy

1. **Unit tests**: Mock streaming responses, test decoders
2. **Integration tests**: Real API calls with streaming
3. **Network simulation**: Test with various latencies/bandwidth
4. **Format testing**: Verify each format streams correctly
5. **Stress testing**: Multiple concurrent streams

### 10. Benefits

- **Reduced latency**: Start playback within 150-200ms
- **Better UX**: User hears response beginning immediately
- **Memory efficient**: No need to buffer entire response
- **Scalable**: Handle longer responses without memory issues

### 11. Risks and Mitigations

| Risk | Mitigation |
|------|------------|
| Audio glitches | Adequate buffering, quality monitoring |
| Format incompatibility | Fallback to buffered mode |
| CPU overhead | Efficient decoders, worker threads |
| Network issues | Adaptive buffering, reconnection logic |

### 12. Future Enhancements

- **WebRTC integration**: For ultra-low latency
- **Spatial audio**: Stream multi-channel audio
- **Adaptive bitrate**: Adjust quality based on network
- **Caching**: Stream from cache for repeated phrases
