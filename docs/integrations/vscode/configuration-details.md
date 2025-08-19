# Configuring VS Code to Use voice-mode

This guide explains how to configure Visual Studio Code to use voice-mode as an MCP (Model Context Protocol) server with GitHub Copilot Chat.

For more information about MCP servers in VS Code, see the [official documentation](https://code.visualstudio.com/docs/copilot/chat/mcp-servers).

## Prerequisites

- VS Code with GitHub Copilot Chat extension
- voice-mode installed and running locally
- MCP support enabled in VS Code settings

## Configuration Steps

### 1. Create MCP Configuration File

Create a `.vscode/mcp.json` file in your workspace root:

```json
{
  "servers": {
    "voice-mode": {
      "type": "stdio",
      "command": "uvx",
      "args": ["voice-mode"],
      "env": {
        "LIVEKIT_HOST": "127.0.0.1:7880",
        "LIVEKIT_API_KEY": "devkey",
        "LIVEKIT_API_SECRET": "secret",
        "OPENAI_API_KEY": "${input:openai-api-key}"
      }
    }
  },
  "inputs": [
    {
      "type": "promptString",
      "id": "openai-api-key",
      "description": "OpenAI API Key (optional - uses local services if not provided)",
      "password": true
    }
  ]
}
```

### 2. Using System Environment Variables

If you have environment variables already set in your system, you can reference them using VS Code's variable substitution:

```json
{
  "servers": {
    "voice-mode": {
      "type": "stdio",
      "command": "uvx",
      "args": ["voice-mode"],
      "envFile": "${workspaceFolder}/.env"
    }
  }
}
```

Or reference specific system environment variables:

```json
{
  "servers": {
    "voice-mode": {
      "type": "stdio",
      "command": "uvx",
      "args": ["voice-mode"],
      "env": {
        "LIVEKIT_HOST": "${env:LIVEKIT_HOST}",
        "LIVEKIT_API_KEY": "${env:LIVEKIT_API_KEY}",
        "LIVEKIT_API_SECRET": "${env:LIVEKIT_API_SECRET}",
        "OPENAI_API_KEY": "${env:OPENAI_API_KEY}"
      }
    }
  }
}
```

Note: Based on the VS Code documentation, environment variables must be explicitly specified in the configuration - they are not automatically inherited from the system environment.

### 3. Alternative: Using Local Services Only

If you're running the complete local voice stack, you can configure voice-mode to use only local services:

```json
{
  "servers": {
    "voice-mode": {
      "type": "stdio",
      "command": "uvx",
      "args": ["voice-mode"],
      "env": {
        "LIVEKIT_HOST": "127.0.0.1:7880",
        "LIVEKIT_API_KEY": "devkey",
        "LIVEKIT_API_SECRET": "secret",
        "STT_SERVICE": "whisper",
        "TTS_SERVICE": "kokoro",
        "WHISPER_API_KEY": "local",
        "WHISPER_BASE_URL": "http://127.0.0.1:2022/v1",
        "KOKORO_API_KEY": "local",
        "KOKORO_BASE_URL": "http://127.0.0.1:8880/v1"
      }
    }
  }
}
```

### 4. Enable MCP Support

Ensure MCP support is enabled in VS Code settings:

1. Open VS Code settings (Cmd/Ctrl + ,)
2. Search for "mcp"
3. Enable the setting for MCP server support

### 5. Start Required Services

Before using voice-mode in VS Code, you may want to run local services:

### Optional: Local Speech Services

Voice Mode works with OpenAI by default, but you can run local services for privacy or offline use:

- **Whisper.cpp** (STT): Install and run on port 2022 - [Instructions](https://github.com/ggerganov/whisper.cpp)
- **Kokoro** (TTS): Install and run on port 8880 - [Instructions](https://huggingface.co/hexgrad/Kokoro-82M)

Voice Mode will automatically detect and use these services when available, falling back to OpenAI if not found.

## Usage in VS Code

Once configured, you can use voice-mode features in GitHub Copilot Chat:

1. Open the Copilot Chat panel
2. Type `@` to see available MCP servers
3. Select `@voice-mode` to access voice functions
4. Available commands:
   - `@voice-mode converse "Hello"` - Speak and listen for response
   - `@voice-mode listen_for_speech` - Listen for speech input
   - `@voice-mode check_room_status` - Check LiveKit room status
   - `@voice-mode check_audio_devices` - List audio devices

## Troubleshooting

### Server Not Appearing
- Ensure `.vscode/mcp.json` is in the workspace root
- Restart VS Code after adding configuration
- Check that MCP support is enabled in settings

### Connection Issues
- Verify all required services are running (`make dev`)
- Check service logs: `make logs`
- Ensure ports are not in use: 7880 (LiveKit), 2022 (Whisper), 8880 (Kokoro)

### Audio Issues
- Run `@voice-mode check_audio_devices` to verify devices are detected
- Check system audio permissions for VS Code
- Ensure no other applications are using the microphone

## Security Notes

- Never commit `.vscode/mcp.json` if it contains sensitive API keys
- Use the `inputs` section for sensitive values instead of hardcoding
- For production use, consider using environment variables or secret management tools