# Audio File Management

## Directory Structure

Audio files are stored in the VoiceMode Home Directory with **year/month subdirectories**:

```
~/.voicemode/audio/
└── YYYY/              # Year (e.g., 2025)
    └── MM/            # Month (e.g., 08 for August)
        ├── YYYYMMDD_HHMMSS_*_conversationid_tts.wav
        └── YYYYMMDD_HHMMSS_*_conversationid_stt.wav
```

## File Naming Convention

- **Format**: `YYYYMMDD_HHMMSS_milliseconds_conversationid_type.wav`
- **Example**: `20250819_173229_835_06kph6_tts.wav`
  - Date: 2025-08-19
  - Time: 17:32:29.835
  - Conversation: 06kph6
  - Type: TTS (Text-to-Speech)

## Finding Audio Files

### Check if audio saving is enabled
```bash
grep VOICEMODE_SAVE_AUDIO ~/.voicemode/.voicemode.env
```

### List today's audio files
```bash
ls -la ~/.voicemode/audio/$(date +%Y/%m)/$(date +%Y%m%d)_*.wav
```

### Find audio for specific conversation
```bash
ls ~/.voicemode/audio/2025/08/*_06kph6_*.wav
```

## Creating Playlists

To replay conversations, create `.m3u` playlist files:

```bash
# Example playlist content
/home/user/.voicemode/audio/2025/08/20250819_173229_835_06kph6_tts.wav
/home/user/.voicemode/audio/2025/08/20250819_173316_290_06kph6_stt.wav
/home/user/.voicemode/audio/2025/08/20250819_173414_511_06kph6_tts.wav
```

Play with: `mpv --playlist=conversation.m3u`

## Matching Audio to Logs

Audio filenames correspond to entries in:
```
~/.voicemode/logs/conversations/exchanges_YYYY-MM-DD.jsonl
```

Look for `audio_file` field in JSON entries.

## Common Issues

### No audio files found
- Check `VOICEMODE_SAVE_AUDIO=true` is set
- Verify looking in year/month subdirectories
- Audio only saved for actual voice interactions, not text-only

### Missing conversation audio
- STT audio only saved when user speaks
- TTS audio only saved when assistant speaks
- Silent or no-speech detections won't create files