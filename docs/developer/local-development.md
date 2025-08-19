# Using uvx with Local Development

> **See also:** [Building Voice Mode](development/building.md) for creating development builds and wheels.

## Running the local package with uvx

### 1. Direct local execution (simplest!)
```bash
# Run from the project directory - uvx automatically detects the command
uvx .
```

### 2. Using --from with local path (explicit command)
```bash
# Run from the project directory
uvx --from . voicemode

# Or from anywhere with full path
uvx --from /home/m/Code/github.com/mbailey/voicemode voicemode
```

### 2. Using file:// URL
```bash
uvx --from file:///home/m/Code/github.com/mbailey/voicemode voicemode
```

### 3. Installing in editable mode for development
```bash
# Install the package in editable mode
uv pip install -e .

# Then run directly (not through uvx)
voicemode
```

### 4. Building and installing locally
```bash
# Build the package
uv build

# Install from the built wheel
uvx --from dist/voice_mode-*.whl voicemode
```

## Testing both package variants locally

```bash
# Test voice-mode package (default)
uvx --from . voicemode

# Test voice-mode package (legacy)
UV_PROJECT_FILE=pyproject-voice-mode.toml uvx --from . voice-mode
```

## Common use cases

### Quick test of local changes
```bash
uvx --from . voicemode --help
```

### Test with additional dependencies
```bash
uvx --from . --with rich voicemode
```

### Force reinstall (useful after code changes)
```bash
uvx --refresh --from . voicemode
```