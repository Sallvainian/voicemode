# MCP Environment Variable Precedence

When using voice-mode with MCP hosts (Claude Desktop, VS Code, etc.), it's important to understand how environment variables are handled:

## Key Points

1. **Explicit Declaration Required**: If you include an `env` section in your MCP configuration, ONLY those variables are passed to the server
2. **No Variable Substitution**: MCP does not support `${VARIABLE}` syntax - only literal values work
3. **Inheritance Behavior**: If you omit the `env` section entirely, the server inherits the parent process environment

## Configuration Precedence

- Variables in MCP config `env` section override shell environment variables
- To use shell environment variables, either:
  - Omit the `env` section completely (inherits all)
  - Hardcode values in the `env` section (not recommended for secrets)

## Example Scenarios

```json
// ❌ This does NOT work - no variable substitution
{
  "mcpServers": {
    "voice-mode": {
      "env": {
        "OPENAI_API_KEY": "${OPENAI_API_KEY}"  // Won't expand
      }
    }
  }
}

// ✅ Option 1: Omit env to inherit from shell
{
  "mcpServers": {
    "voice-mode": {
      "command": "uvx",
      "args": ["voice-mode"]
      // No env section - inherits OPENAI_API_KEY from shell
    }
  }
}

// ✅ Option 2: Explicit values (avoid for secrets)
{
  "mcpServers": {
    "voice-mode": {
      "env": {
        "VOICEMODE_DEBUG": "true",
        "VOICEMODE_TTS_VOICE": "af_sky"
      }
    }
  }
}
```

## References

- [MCP Configuration Documentation](../mcp-config-json.md) - Detailed MCP configuration behavior
- [Model Context Protocol Specification](https://modelcontextprotocol.io/docs/specification) - Official MCP specification
- [Known Limitations](https://github.com/microsoft/vscode/issues/245237) - Feature request for variable substitution