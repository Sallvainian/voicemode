# Building Voice Mode

This guide covers building Voice Mode for local development and testing.

## Prerequisites

- Python >= 3.10
- [uv](https://github.com/astral-sh/uv) installed

Note: Development builds temporarily modify the version file, but `make build-dev` automatically restores it.

## Building a Development Version

### Automatic Dev Versioning (Recommended)

Use the `make build-dev` command for automatic versioning:

```bash
# Automatically appends .dev + timestamp to current version
make build-dev
```

This creates a unique development version like `2.4.2.dev20240627123456`.

The command safely handles version updates with automatic rollback on errors.

### Manual Version Update

If you prefer to set a specific dev version:

```bash
# Edit voice_mode/__version__.py
__version__ = "2.4.2.dev0"  # Example dev version

# Then build
uv build
```

This creates wheel and source distributions in the `dist/` directory:
- `dist/voice_mode-2.4.2.dev0-py3-none-any.whl`
- `dist/voice_mode-2.4.2.dev0.tar.gz`

## Installing Your Build

### In Another Project

```bash
# Install the wheel directly
pip install /path/to/voicemode/dist/voice_mode-2.4.2.dev0-py3-none-any.whl

# Or with uv
uv pip install /path/to/voicemode/dist/voice_mode-2.4.2.dev0-py3-none-any.whl
```

### In MCP Configuration

For testing with Claude Code or other MCP clients:

```json
{
  "mcpServers": {
    "voice-mode-dev": {
      "command": "python",
      "args": ["-m", "voice_mode"],
      "env": {
        "PYTHONPATH": "/path/to/voicemode",
        "OPENAI_API_KEY": "your-key"
      }
    }
  }
}
```

## Version Management

### Development Versions

- Use `.devN` suffix: `2.4.2.dev0`, `2.4.2.dev1`, etc.
- These won't be published to PyPI by CI/CD
- Increment the dev number for each test build

### Release Versions

- Use semantic versioning: `2.4.2`, `2.5.0`, etc.
- Only create release versions when ready to publish
- Use `make release` for official releases

## Testing Your Build

1. Create a test environment:
```bash
uv venv test-env
source test-env/bin/activate  # On Windows: test-env\Scripts\activate
```

2. Install your build:
```bash
uv pip install dist/voice_mode-*.whl
```

3. Test the installation:
```bash
python -m voice_mode --help
```

## Troubleshooting

### Build Errors

- Ensure you're in the project root directory
- Check that `pyproject.toml` is valid
- Run `uv sync` to ensure dependencies are installed

### Import Errors

- Verify the wheel installed correctly: `pip show voice-mode`
- Check Python path: `python -c "import voice_mode; print(voice_mode.__file__)"`

### Version Conflicts

- Uninstall existing versions: `pip uninstall voice-mode`
- Use virtual environments to isolate installations