# Voice Mode Testing

MVP testing scripts to verify Claude Code + Voice Mode setup works correctly on fresh systems.

## Goals

This is an MVP to help us quickly test that users can:
1. Install Claude Code following the docs
2. Add Voice Mode via `claude mcp add`
3. Successfully use voice conversations

Focus is on Claude Code integration only for now. Other integrations will be added after this foundation is solid.

## Prerequisites

Users must have already installed system dependencies following the instructions in the main README.md.

## Configuration

Create a `.env` file to customize test settings:

```bash
# Create .env file with your settings
cat > .env <<EOF
TEST_USER=testuser
REPO_URL=https://github.com/mbailey/voicemode.git
OPENAI_API_KEY=your-key-here
EOF
```

## What Gets Tested

1. **System Dependencies** - Verifies audio libraries are installed
2. **Claude Code Installation** - Checks npm global install works
3. **Voice Mode MCP** - Tests `claude mcp add voice-mode`
4. **Voice Functionality** - Basic conversation test
5. **Local Services** (optional) - Whisper/Kokoro installation

## Quick Start

### macOS
```bash
# Creates test user 'voicemodetest' and sets up environment
./setup-macos.sh
```

### Ubuntu/Debian  
```bash
# Verifies dependencies and sets up test environment
./setup-ubuntu.sh
```

### Fedora
```bash
# Verifies dependencies and sets up test environment
./setup-fedora.sh
```

### Run Tests
```bash
# Tests Claude Code + Voice Mode integration
./run-tests.sh
```

### Cleanup
```bash
# Removes test installations
./cleanup.sh
```

## Manual Testing Steps

After setup, follow these steps to verify everything works:

1. **Install Claude Code** (if not already installed):
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

2. **Add Voice Mode**:
   ```bash
   claude mcp add --scope user voice-mode uvx voice-mode
   ```

3. **Set API Key**:
   ```bash
   export OPENAI_API_KEY="your-key"
   ```

4. **Test Voice**:
   ```bash
   claude converse
   # Speak: "Hello, can you hear me?"
   ```