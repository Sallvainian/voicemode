# Voice Conversation Statistics Dashboard

The voice-mode system now includes a comprehensive live statistics dashboard that tracks and displays conversation performance metrics in real-time.

## Features

### Real-time Performance Tracking
- **Time to First Audio (TTFA)**: How quickly voice synthesis begins
- **TTS Generation Time**: Time to generate speech audio
- **TTS Playback Time**: Time to play the generated audio
- **STT Processing Time**: Time to process speech-to-text
- **Total Turnaround Time**: Complete conversation round-trip time

### Session Statistics
- Total conversation count
- Success/failure rate tracking
- Session duration monitoring
- Provider usage analytics
- Voice and model usage patterns

### Live Dashboard
- Real-time updates as conversations occur
- Min/max/average performance metrics
- Recent interaction history
- Provider performance comparison

## MCP Tools

### `voice_statistics`
Display the complete live statistics dashboard with all performance metrics, provider usage, and recent interaction history.

```bash
# Example usage in Claude
> Use the voice_statistics tool to show current performance
```

### `voice_statistics_summary`
Get a concise summary of key performance indicators including session duration, success rate, and average turnaround times.

### `voice_statistics_recent`
Show detailed timing information for recent voice interactions.

```bash
# Show last 5 interactions
voice_statistics_recent(limit=5)
```

### `voice_statistics_reset`
Clear all tracked statistics and start a new session. Useful for testing performance changes.

### `voice_statistics_export`
Export all statistics and raw metrics as JSON for external analysis.

## MCP Resources

The statistics are also available as MCP resources for programmatic access:

### `voice://statistics/current`
Real-time JSON data with complete session statistics, performance metrics, and recent interactions.

### `voice://statistics/summary/json`
Lightweight JSON summary with key performance indicators.

### `voice://statistics/export/latest`
Complete dataset export including all raw metrics for analysis.

## Integration

The statistics system automatically tracks all voice interactions from the `converse` tool:

- **Speak-only interactions**: Tracks TTS performance
- **Full conversations**: Tracks complete round-trip timing
- **LiveKit interactions**: Tracks transport-level metrics
- **Error cases**: Records failures and error messages

## Example Dashboard Output

```
🎙️ VOICE CONVERSATION STATISTICS
==================================================

📊 SESSION OVERVIEW
Duration: 0:05:23
Total Interactions: 12
Successful: 11
Failed: 1
Success Rate: 91.7%

⚡ PERFORMANCE METRICS (seconds)
------------------------------
Time to First Audio:   0.65s  (min:  0.31s, max:  1.20s)
TTS Generation:        1.24s  (min:  0.80s, max:  2.10s)
TTS Playback:          2.15s  (min:  1.20s, max:  3.80s)
STT Processing:        0.78s  (min:  0.50s, max:  1.10s)
Total Turnaround:     18.50s  (min: 12.50s, max: 27.00s)

🔧 PROVIDER USAGE
------------------------------
Voice Providers:
  openai: 7 uses
  kokoro: 4 uses
Transports:
  local: 10 uses
  livekit: 1 uses
Voices:
  nova: 4 uses
  af_sky: 3 uses
  shimmer: 3 uses

📝 RECENT INTERACTIONS (5 of 12)
------------------------------
1. 15:42:18 ✅  12.5s [kokoro] What time is it?...
2. 15:41:45 ✅  19.0s [openai] Hello, how are you?...
3. 15:41:20 ❌   N/A  [openai] Can you hear me?...
4. 15:40:55 ✅  27.0s [openai] Tell me a joke...
5. 15:40:30 ✅  15.2s [livekit] Test LiveKit...
```

## Performance Analysis

The dashboard helps identify:

- **Fastest providers**: Compare TTS generation times across OpenAI and Kokoro
- **Optimal configurations**: Track which voice/model combinations perform best
- **Session patterns**: Monitor success rates and identify failure causes
- **Timing bottlenecks**: Identify whether delays are in TTS, STT, or network

## Usage Recommendations

1. **Before performance testing**: Use `voice_statistics_reset` to start fresh tracking
2. **During conversations**: Monitor real-time metrics with `voice_statistics_summary`
3. **After testing**: Use `voice_statistics` for complete analysis
4. **For debugging**: Check `voice_statistics_recent` for detailed timing of failed interactions
5. **For reporting**: Export data with `voice_statistics_export` for external analysis

## Technical Details

- **Thread-safe**: Statistics tracking works across concurrent voice operations
- **Memory efficient**: Maintains last 1000 interactions to prevent memory bloat
- **Automatic integration**: No manual calls needed - statistics track automatically
- **Error resilient**: Statistics tracking failures don't interrupt voice operations

The statistics system provides valuable insights into voice conversation performance and helps optimize the voice-mode system for the best user experience.