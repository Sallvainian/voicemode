# Using uv/uvx with Voice Mode

This guide covers how to use the [uv](https://github.com/astral-sh/uv) package manager and its `uvx` tool to install and manage Voice Mode.

## What is uv?

`uv` is an extremely fast Python package and project manager, written in Rust. It's designed to be a drop-in replacement for pip, pip-tools, pipx, poetry, pyenv, virtualenv, and more.

`uvx` is uv's tool for running Python applications in isolated environments (similar to pipx).

## Installing Voice Mode with uvx

### Quick Start

The simplest way to run Voice Mode is:

```bash
# Run directly (auto-installs if needed)
uvx voicemode

# Or explicitly install first
uvx install voice-mode
```

### Installing Specific Versions

```bash
# Install a specific version
uvx install voice-mode==2.2.0

# Upgrade to the latest version
uvx upgrade voice-mode

# Downgrade to an older version
uvx install --force voice-mode==2.1.0
```

## Checking Versions

### List Available Versions on PyPI

To see all available versions of Voice Mode on PyPI:

```bash
# Using curl and jq
curl -s https://pypi.org/pypi/voice-mode/json | jq -r '.releases | keys[]' | sort -V

# Show only the last 10 versions
curl -s https://pypi.org/pypi/voice-mode/json | jq -r '.releases | keys[]' | sort -V | tail -10
```

Recent versions include:
- 2.3.0 (latest)
- 2.2.0
- 2.1.3
- 2.1.1
- 2.1.0
- 2.0.3

### Check Installed Version

```bash
# List all uv tools
uv tool list

# Check if voice-mode is installed
uv tool list | grep voice-mode

# Run voicemode with version flag
uvx voicemode --version
```

## Managing Voice Mode with uv

### Uninstalling

```bash
uv tool uninstall voice-mode
```

### Running with Different Python Versions

```bash
# Use a specific Python version
uvx --python 3.11 voicemode
```

### Accessing the Installed Location

uv tools are installed in isolated virtual environments. To find the installation:

```bash
# On Linux/macOS
~/.local/share/uv/tools/voice-mode/

# On Windows
%LOCALAPPDATA%\uv\tools\voice-mode\
```

## Development with uv

If you're developing Voice Mode locally:

### Installing from Local Source

```bash
# In the voice-mode repository directory
uv pip install -e .

# Or using uvx from a local path
uvx install --from . voice-mode
```

### Creating a Development Environment

```bash
# Create a virtual environment
uv venv

# Activate it
source .venv/bin/activate  # On Linux/macOS
# or
.venv\Scripts\activate  # On Windows

# Install voice-mode in development mode
uv pip install -e .
```

### Running Tests

```bash
# Install test dependencies
uv pip install -e ".[test]"

# Run tests
pytest
```

## Troubleshooting

### Voice Mode Not Found

If `uvx voicemode` doesn't work:

```bash
# Try the full package name
uvx voice-mode

# Or install explicitly first
uvx install voice-mode
uvx voicemode
```

### Version Conflicts

If you have version conflicts:

```bash
# Force reinstall
uvx install --force voice-mode

# Or uninstall first
uv tool uninstall voice-mode
uvx install voice-mode
```

### Python Version Issues

Voice Mode requires Python 3.10+. If you encounter Python version issues:

```bash
# Check your Python version
python --version

# Use uv with a specific Python
uvx --python 3.12 voicemode
```

## Integration with Claude Desktop

When using Voice Mode with Claude Desktop, you typically don't need to worry about uv/uvx as the MCP server is launched automatically. However, you can specify the exact command in your Claude Desktop configuration:

```json
{
  "mcpServers": {
    "voice-mode": {
      "command": "uvx",
      "args": ["voicemode"],
      "env": {
        "OPENAI_API_KEY": "your-api-key"
      }
    }
  }
}
```

This ensures Claude Desktop always uses the uvx-installed version of Voice Mode.

## See Also

- [uv Documentation](https://github.com/astral-sh/uv)
- [Voice Mode Installation Guide](../README.md#installation)
- [Local Development Guide](local-development-uvx.md)