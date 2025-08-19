# Unified Event Logging System Design

## Overview

This document describes the design for a unified event logging system for Voice Mode. The system will track all significant events during voice interactions, enabling accurate timing calculations, debugging, analytics, and future extensibility.

## Motivation

Current issues:
- Timing calculations show negative response times (e.g., `response_time -34.9s`)
- Timing logic is scattered across different parts of the codebase
- No persistent record of events for debugging or analysis
- Difficult to add new metrics without modifying existing code

## Design Principles

1. **Simple and Extensible**: Easy to add new event types without breaking existing functionality
2. **Self-Describing**: Events contain all necessary context
3. **Performance**: Minimal overhead on voice operations
4. **Parseable**: Machine-readable format for analysis tools
5. **Human-Readable**: Easy to understand when debugging

## Event Structure

Each event is a JSON object on its own line (JSONL format):

```json
{
  "timestamp": "2025-06-23T15:30:45.123456Z",
  "event_type": "TTS_START",
  "session_id": "conv_1234567890",
  "data": {
    "message": "Hello, how can I help?",
    "voice": "alloy",
    "model": "tts-1"
  }
}
```

### Core Fields

- `timestamp`: ISO 8601 timestamp with microsecond precision
- `event_type`: Enumerated event type (see below)
- `session_id`: Unique identifier for the conversation session
- `data`: Event-specific data (optional)

## Event Types

### TTS (Text-to-Speech) Events
- `TTS_REQUEST`: TTS requested
- `TTS_START`: TTS processing started
- `TTS_FIRST_AUDIO`: First audio chunk received (TTFA)
- `TTS_PLAYBACK_START`: Audio playback started
- `TTS_PLAYBACK_END`: Audio playback completed
- `TTS_ERROR`: TTS error occurred

### Recording Events
- `RECORDING_START`: Microphone recording started
- `RECORDING_END`: Microphone recording stopped
- `RECORDING_SAVED`: Audio file saved (if enabled)

### STT (Speech-to-Text) Events
- `STT_REQUEST`: STT requested
- `STT_START`: STT processing started
- `STT_COMPLETE`: STT result received
- `STT_NO_SPEECH`: No speech detected
- `STT_ERROR`: STT error occurred

### System Events
- `SESSION_START`: New conversation session started
- `SESSION_END`: Conversation session ended
- `TRANSPORT_SWITCH`: Changed between local/livekit transport
- `PROVIDER_SWITCH`: Changed TTS/STT provider

## Implementation

### Event Logger Module

Create `voice_mode/event_logger.py`:

```python
import json
import time
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, Any, Optional
import threading
import queue

class EventLogger:
    def __init__(self, log_dir: Optional[Path] = None):
        self.log_dir = log_dir or Path.home() / "voicemode_logs"
        self.log_dir.mkdir(exist_ok=True)
        
        # Current log file (rotated daily)
        self.log_file = None
        self.current_date = None
        
        # Thread-safe queue for async writing
        self.event_queue = queue.Queue()
        self.writer_thread = threading.Thread(target=self._writer_loop, daemon=True)
        self.writer_thread.start()
        
        # In-memory event buffer for current session
        self.session_events = []
        self.session_id = None
    
    def log_event(self, event_type: str, data: Optional[Dict[str, Any]] = None):
        """Log an event with automatic timestamp"""
        event = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "event_type": event_type,
            "session_id": self.session_id,
            "data": data or {}
        }
        
        # Add to queue for file writing
        self.event_queue.put(event)
        
        # Keep in memory for current session
        if self.session_id:
            self.session_events.append(event)
    
    def start_session(self, session_id: str):
        """Start a new conversation session"""
        self.session_id = session_id
        self.session_events = []
        self.log_event("SESSION_START")
    
    def end_session(self):
        """End current session and return timing metrics"""
        if not self.session_id:
            return None
        
        self.log_event("SESSION_END")
        metrics = self._calculate_metrics()
        
        # Clear session
        self.session_id = None
        self.session_events = []
        
        return metrics
    
    def _calculate_metrics(self) -> Dict[str, float]:
        """Calculate timing metrics from session events"""
        metrics = {}
        events_by_type = {}
        
        # Group events by type
        for event in self.session_events:
            event_type = event["event_type"]
            if event_type not in events_by_type:
                events_by_type[event_type] = []
            events_by_type[event_type].append(event)
        
        # Calculate key metrics
        if "TTS_START" in events_by_type and "TTS_FIRST_AUDIO" in events_by_type:
            tts_start = self._parse_timestamp(events_by_type["TTS_START"][0]["timestamp"])
            ttfa = self._parse_timestamp(events_by_type["TTS_FIRST_AUDIO"][0]["timestamp"])
            metrics["ttfa"] = (ttfa - tts_start).total_seconds()
        
        if "RECORDING_START" in events_by_type and "RECORDING_END" in events_by_type:
            rec_start = self._parse_timestamp(events_by_type["RECORDING_START"][0]["timestamp"])
            rec_end = self._parse_timestamp(events_by_type["RECORDING_END"][0]["timestamp"])
            metrics["recording_duration"] = (rec_end - rec_start).total_seconds()
        
        # User-perceived response time: from end of recording to start of TTS
        if "RECORDING_END" in events_by_type and "TTS_START" in events_by_type:
            rec_end = self._parse_timestamp(events_by_type["RECORDING_END"][0]["timestamp"])
            tts_start = self._parse_timestamp(events_by_type["TTS_START"][0]["timestamp"])
            metrics["response_time"] = (tts_start - rec_end).total_seconds()
        
        return metrics
    
    def _parse_timestamp(self, timestamp_str: str) -> datetime:
        """Parse ISO format timestamp"""
        return datetime.fromisoformat(timestamp_str.replace('Z', '+00:00'))
    
    def _writer_loop(self):
        """Background thread for writing events to file"""
        while True:
            try:
                event = self.event_queue.get(timeout=1)
                self._write_event(event)
            except queue.Empty:
                continue
    
    def _write_event(self, event: Dict[str, Any]):
        """Write event to log file"""
        # Check if we need to rotate log file
        today = datetime.now().date()
        if self.current_date != today:
            self.current_date = today
            log_filename = f"voicemode_events_{today.isoformat()}.jsonl"
            self.log_file = self.log_dir / log_filename
        
        # Append event
        with open(self.log_file, 'a') as f:
            f.write(json.dumps(event) + '\n')
```

### Integration Points

1. **In conversation.py**: Add event logging calls
2. **In server.py**: Initialize event logger on startup
3. **In config.py**: Add configuration for event logging

### Configuration

New environment variables:
- `VOICEMODE_EVENT_LOG_DIR`: Directory for event logs (default: `~/voicemode_logs/`)
- `VOICEMODE_EVENT_LOG_ENABLED`: Enable event logging (default: `true`)
- `VOICEMODE_EVENT_LOG_ROTATION`: Log rotation period (default: `daily`)

## Usage Examples

### During a Conversation

```python
# In conversation.py
event_logger.start_session(f"conv_{int(time.time())}")

# When TTS starts
event_logger.log_event("TTS_START", {
    "message": message,
    "voice": voice,
    "model": tts_model
})

# When first audio received
event_logger.log_event("TTS_FIRST_AUDIO")

# When recording starts
event_logger.log_event("RECORDING_START")

# When recording ends
event_logger.log_event("RECORDING_END", {
    "duration": recording_duration,
    "samples": len(audio_data)
})

# At end of conversation
metrics = event_logger.end_session()
```

### Analyzing Logs

```python
# Read and analyze events
import json
from collections import defaultdict

events = []
with open("voicemode_events_2025-06-23.jsonl") as f:
    for line in f:
        events.append(json.loads(line))

# Calculate average TTFA
ttfa_times = []
for i, event in enumerate(events):
    if event["event_type"] == "TTS_START":
        # Find corresponding TTS_FIRST_AUDIO
        for j in range(i+1, len(events)):
            if events[j]["event_type"] == "TTS_FIRST_AUDIO" and \
               events[j]["session_id"] == event["session_id"]:
                start = datetime.fromisoformat(event["timestamp"])
                first_audio = datetime.fromisoformat(events[j]["timestamp"])
                ttfa_times.append((first_audio - start).total_seconds())
                break

avg_ttfa = sum(ttfa_times) / len(ttfa_times) if ttfa_times else 0
print(f"Average TTFA: {avg_ttfa:.3f}s")
```

## Benefits

1. **Accurate Timing**: All calculations based on actual event timestamps
2. **Debugging**: Complete timeline of what happened during each conversation
3. **Analytics**: Can analyze patterns across many conversations
4. **Extensibility**: Easy to add new events without changing existing code
5. **Testing**: Can replay event sequences for testing

## Migration Plan

1. Implement EventLogger class
2. Add event logging to conversation flow (without removing existing timing code)
3. Verify new metrics match existing ones
4. Switch to using event-based metrics
5. Remove old timing calculation code

## Future Extensions

- Event filtering and querying API
- Real-time event streaming for monitoring
- Integration with observability platforms (OpenTelemetry)
- Automatic anomaly detection
- Performance profiling based on events
- User behavior analytics