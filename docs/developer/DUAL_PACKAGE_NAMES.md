# Package Names and Commands

## Recommended Installation

```bash
# Using uv (recommended)
uvx voice-mode

# Using pip
pip install voice-mode

# Using npm
npx voicemode
```

The command to run is: `voicemode`

## Legacy Support

The original `voice-mcp` package name and command are still available but deprecated:

```bash
pip install voice-mcp  # Still works, but shows deprecation warning
voice-mcp             # Shows deprecation warning, use 'voicemode' instead
```

## Transition Timeline

- **Current**: Both `voicemode` and `voice-mcp` commands work
- **Future**: The `voice-mcp` command will be removed
- **Action Required**: Update your configurations to use `voicemode`

## For Contributors

The GitHub repository remains at the same location. Only the PyPI package name is changing.

## Technical Details

Both packages:
- Share the same codebase
- Have synchronized version numbers
- Are built from the same source
- Will maintain compatibility during the transition period