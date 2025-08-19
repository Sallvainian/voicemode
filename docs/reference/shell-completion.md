# Shell Completion for voice-mode

Voice Mode provides shell completion for both bash and zsh shells, powered by Click's built-in completion system.

## Quick Setup

### Using Click's Built-in Commands

Voice Mode includes built-in commands to help you set up completions:

```bash
# Show bash completion instructions
voice-mode completion bash

# Show zsh completion instructions  
voice-mode completion zsh
```

### Automatic Setup (Recommended)

#### Bash
```bash
# Add to your ~/.bashrc
eval "$(_VOICE_MODE_COMPLETE=bash_source voice-mode)"
```

#### Zsh
```bash
# Add to your ~/.zshrc
eval "$(_VOICE_MODE_COMPLETE=zsh_source voice-mode)"
```

### Performance-Optimized Setup

For faster shell startup, you can pre-generate the completion script:

#### Bash
```bash
# Generate completion script once
_VOICE_MODE_COMPLETE=bash_source voice-mode > ~/.voice-mode-complete.bash

# Add to ~/.bashrc
source ~/.voice-mode-complete.bash
```

#### Zsh
```bash
# Generate completion script once
_VOICE_MODE_COMPLETE=zsh_source voice-mode > ~/.voice-mode-complete.zsh

# Add to ~/.zshrc
source ~/.voice-mode-complete.zsh
```

## Using metool Pattern

If you're using metool for configuration management, Voice Mode provides wrapper scripts that integrate with Click's completion:

### Installation with metool

The completion scripts are located in `shell/completions/`:
- `voice-mode.bash` - Bash completion wrapper
- `voice-mode.zsh` - Zsh completion wrapper

These scripts:
1. Check if `voice-mode` is installed
2. Use Click's completion generation if available
3. Provide helpful fallback messages if not installed

### Manual Sourcing

```bash
# For bash
source ~/.voicemode/shell/completions/voice-mode.bash

# For zsh
source ~/.voicemode/shell/completions/voice-mode.zsh
```


## How It Works

Voice Mode uses Click's shell completion system which:
- Dynamically generates completions based on the current CLI structure
- Supports all commands, subcommands, and options automatically
- Updates completions when new features are added
- Provides context-aware suggestions

## Troubleshooting

### Completions Not Working

1. Ensure voice-mode is installed:
   ```bash
   which voice-mode
   ```

2. Test completion generation:
   ```bash
   _VOICE_MODE_COMPLETE=bash_source voice-mode
   ```

3. Reload your shell configuration:
   ```bash
   source ~/.bashrc  # or ~/.zshrc
   ```

### Performance Issues

If completions are slow, use the pre-generated script method described above instead of the eval method.

## Technical Details

Click's completion system works by:
1. Setting an environment variable (`_VOICE_MODE_COMPLETE`)
2. Running the voice-mode command with this variable set
3. The command detects this and outputs shell completion code
4. The shell evaluates this code to register completions

The wrapper scripts in `shell/completions/` handle this process automatically and provide fallback behavior when voice-mode is not installed.