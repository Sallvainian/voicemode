# Voice Mode Skip TTS Feature

## Overview
Add a `skip_tts` parameter to the `converse` tool that allows the LLM to dynamically control whether text-to-speech is used, enabling faster voice interactions when only text responses are needed.

## Background
Currently, Voice Mode has a global environment variable `VOICEMODE_SKIP_TTS` that completely disables TTS. However, this is an all-or-nothing setting. By adding a parameter to the converse tool, the LLM can make intelligent decisions about when to use voice and when to skip it for faster responses.

## Requirements

### 1. Add `skip_tts` Parameter
- Add a new optional parameter `skip_tts` to the `converse` function
- Type: `Optional[Union[bool, str]]` (to handle both boolean and string "true"/"false" from MCP)
- Default: `None` (use global setting)
- When `True`: Skip TTS regardless of global `SKIP_TTS` setting
- When `False`: Use TTS regardless of global `SKIP_TTS` setting
- When `None`: Follow global `SKIP_TTS` setting

### 2. Implementation Logic
```python
# Determine whether to skip TTS
if skip_tts is not None:
    # Parameter explicitly set, use it
    should_skip_tts = skip_tts if isinstance(skip_tts, bool) else skip_tts.lower() in ("true", "1", "yes")
else:
    # Use global setting
    should_skip_tts = SKIP_TTS
```

### 3. Update Documentation
- Add parameter to the converse tool's docstring
- Document the interaction with `VOICEMODE_SKIP_TTS` environment variable
- Add examples showing when to use skip_tts

### 4. Benefits
- LLM can optimize for speed when appropriate (e.g., quick confirmations)
- LLM can ensure voice is used for important messages
- User maintains ultimate control via environment variable
- Consistent naming between parameter and env var aids discoverability

## Implementation Steps

1. **Create feature branch**: `feature/skip-tts-parameter`
2. **Modify converse function**: Add parameter and implement logic
3. **Update docstring**: Document the new parameter thoroughly
4. **Test**: Verify parameter works correctly with all combinations
5. **Update configuration docs**: Document `VOICEMODE_SKIP_TTS` in main docs

## Testing Plan

1. Test with `skip_tts=True` - should skip TTS
2. Test with `skip_tts=False` - should use TTS
3. Test with `skip_tts=None` and `VOICEMODE_SKIP_TTS=true` - should skip TTS
4. Test with `skip_tts=None` and `VOICEMODE_SKIP_TTS=false` - should use TTS
5. Test with `skip_tts=True` and `VOICEMODE_SKIP_TTS=false` - should skip TTS (parameter overrides)
6. Test with `skip_tts=False` and `VOICEMODE_SKIP_TTS=true` - should use TTS (parameter overrides)

## Notes
- The audio feedback pips at start/end ensure transparency
- Users can set `VOICEMODE_SKIP_TTS=true` for permanent text-only mode
- LLM can use `update_config` tool to help users set this permanently