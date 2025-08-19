# FOR IMMEDIATE RELEASE

## Voice Mode Introduces "Total Recall" with YubiKey-Protected Privacy: The First Life Logging System Your AI Can't Read

### Revolutionary approach captures everything you say while keeping it locked away from AI access

**MELBOURNE, AUSTRALIA** – Voice Mode, the open-source voice AI platform, today announced Total Recall, a groundbreaking life logging feature that creates a comprehensive archive of spoken words while maintaining unprecedented privacy through hardware-encrypted storage that even the AI assistant cannot access without explicit permission.

Unlike existing voice assistants that process and potentially store conversations in the cloud, Voice Mode's Total Recall feature captures and immediately encrypts all transcriptions using GPG encryption with YubiKey hardware authentication. This creates an impenetrable vault of personal history that remains completely inaccessible to the AI unless explicitly unlocked by physical user presence.

"We're entering an age where AI assistants are becoming integral to daily life, but that doesn't mean we should sacrifice privacy," said the Voice Mode team. "Total Recall proves you can have both – a perfect memory of everything you've said, and complete control over who can access it, including the AI itself."

### Key Features of Total Recall:

- **Hardware-Secured Encryption**: All transcriptions are immediately encrypted using GPG with YubiKey authentication
- **AI-Blind Storage**: The AI assistant cannot access historical data without explicit YubiKey-verified permission
- **Selective Sharing**: Users control exactly what context the AI can see, maintaining conversational privacy
- **Life Logging**: Creates a searchable archive of thoughts, conversations, and ideas spanning years
- **Local First**: All processing and storage happens on the user's device, not in the cloud

### How It Works:

When in standby mode, Voice Mode continuously transcribes speech but immediately encrypts it before any AI processing. Only content spoken after the wake word "Hey Claude" is sent to the AI assistant. Historical data remains locked in the user's personal vault, requiring physical YubiKey authentication to access.

This architecture enables powerful use cases:
- "What was that idea I had last Tuesday?" – requires YubiKey touch to search
- "Hey Claude, remind me to buy milk" – processed immediately without storing context
- Complete privacy for sensitive conversations while still maintaining a personal record

### Technical Innovation:

Voice Mode leverages the Model Context Protocol (MCP) to create a security boundary between the transcription system and the AI model. The MCP server handles all encryption and storage, never exposing raw historical data to the language model without explicit user authentication.

"This isn't just about privacy – it's about data sovereignty," the team explained. "Your thoughts and conversations are yours. The AI is a tool that serves you, not a system that surveils you."

### Availability:

Total Recall is currently in development as part of Voice Mode's wake word detection feature. The open-source project welcomes contributions from developers interested in privacy-preserving AI systems.

Voice Mode is available now via PyPI and can be installed with `pip install voice-mode`. The project is actively seeking feedback from privacy-conscious users and developers.

### About Voice Mode:

Voice Mode is an open-source platform that enables natural voice conversations with AI assistants while prioritizing user privacy and local processing. Built on the Model Context Protocol, it supports multiple TTS/STT providers and runs entirely on user devices.

### Contact:
- GitHub: https://github.com/mbailey/voicemode
- Discord: https://discord.gg/gVHPPK5U
- Email: hello@getvoicemode.com

###

*Note: YubiKey is a trademark of Yubico. Voice Mode is not affiliated with Yubico or Anthropic.*