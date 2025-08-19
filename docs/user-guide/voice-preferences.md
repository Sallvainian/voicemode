# Voice Preferences

Voice Mode supports file-based voice preferences that allow you to set preferred voices per project or user. This provides a convenient way to maintain consistent voice settings without environment variables.

## Voice Preference Files

Voice Mode looks for voice preference files in the following order:

1. **Project-level** (walks up from current directory):
   - `.voices.txt` (hidden file in project)
   - `.voicemode/voices.txt` (in .voicemode directory)
2. **User-level** (in home directory):
   - `~/.voices.txt` (hidden file in home)
   - `~/.voicemode/voices.txt` (in .voicemode directory)

The first file found is used. Standalone `.voices.txt` files take precedence over those in `.voicemode` directories.

## File Format

The `.voices.txt` file is a simple text file with one voice name per line:

```
# Preferred voices for this project
af_sky
nova
alloy
```

- One voice name per line
- Comments start with `#`
- Empty lines are ignored
- Voices are tried in order listed

## Preference Priority

Voice selection follows this priority order:

1. **Voice preference files** (`.voicemode/voices.txt`)
2. **Environment variable** (`VOICEMODE_TTS_VOICES`)
3. **Built-in defaults** (`alloy`, `nova`, etc.)

## Examples

**Simple project setup** (`/my-project/.voices.txt`):
```
# Project prefers these voices
nova
shimmer
```

**Organized project setup** (`/my-project/.voicemode/voices.txt`):
```
# Creative writing project - use expressive voices
shimmer
fable
```

**User default voices** (`~/.voices.txt` or `~/.voicemode/voices.txt`):
```
# My preferred voices
af_sky  # Kokoro voice when available
nova    # Fallback to OpenAI
```

This allows teams to share voice preferences via version control while individual users can override with their own preferences. The standalone `.voices.txt` option provides a simpler setup for projects that don't need a full `.voicemode` directory.