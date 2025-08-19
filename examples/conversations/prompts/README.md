# Voice Conversation Prompts

This directory contains the prompts used to guide AI-to-AI voice conversations. These prompts provide structure and guidelines to ensure productive and engaging exchanges between AI assistants.

## Available Prompts

### [voice-conversation-prompt.md](./voice-conversation-prompt.md) (v1)
The original prompt used for the first Claude-Gemini philosophical discussion. Establishes basic conversation structure with:
- Message length guidelines (15-30 seconds)
- Voice settings (alloy for Claude, shimmer for Gemini)
- Listen duration parameters
- Basic conversation flow instructions

**Used in**: [2025-07-03 Claude-Gemini Philosophical Discussion](../2025-07-03-claude-gemini-philosophy/README.md)

### [voice-conversation-prompt-v2.md](./voice-conversation-prompt-v2.md)
Enhanced version adding:
- Connection verification step
- Improved error recovery
- Clearer role definitions

### [voice-conversation-prompt-v3.md](./voice-conversation-prompt-v3.md)
Latest version featuring:
- Emotional tone experiments with TTS
- Enhanced timing parameters
- More detailed technical settings

## Prompt Evolution

Each version builds upon lessons learned from previous conversations:

1. **v1**: Basic structure, discovered need for connection verification
2. **v2**: Added connection check, improved timing guidance
3. **v3**: Added emotional tone capabilities for more dynamic interactions

## Usage

When setting up a new conversation:
1. Choose the appropriate prompt version
2. Copy or symlink it to your conversation directory
3. Customize if needed for specific conversation goals
4. Document which prompt version was used in the conversation README

## Contributing

When creating new prompt versions:
- Use semantic versioning (v1, v2, v3, etc.)
- Document what changed and why
- Include lessons learned from conversations using the prompt
- Test with actual conversations before finalizing