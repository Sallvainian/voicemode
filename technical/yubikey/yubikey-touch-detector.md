# YubiKey Touch Detector

A tool to detect when your YubiKey is waiting for a touch and trigger notifications or custom actions.

**Project Repository**: https://github.com/maximbaz/yubikey-touch-detector

## Overview

YubiKey Touch Detector monitors various authentication methods (GPG, SSH, U2F/FIDO2) and detects when your YubiKey requires a physical touch. It provides multiple notification methods that can be used to trigger sounds or visual indicators.

## Installation

### Fedora
```bash
sudo dnf install yubikey-touch-detector
```

### From Source
```bash
go install github.com/maximbaz/yubikey-touch-detector@latest
```

## Notification Methods for Sound Playback

### 1. Unix Socket (Recommended for Sound Notifications)

The unix socket notifier is ideal for triggering custom sound notifications:

```bash
# The socket is created at:
# $XDG_RUNTIME_DIR/yubikey-touch-detector.socket

# All messages have a fixed length of 5 bytes:
# - "GPG_1" - GPG operation started, waiting for touch
# - "GPG_0" - GPG operation completed
# - "U2F_1" - U2F operation started, waiting for touch  
# - "U2F_0" - U2F operation completed
# - "SSH_1" - SSH operation started, waiting for touch
# - "SSH_0" - SSH operation completed
```

### 2. Desktop Notifications (libnotify)

Shows system notifications that could be configured to play sounds:

```bash
yubikey-touch-detector --libnotify
```

### 3. stdout Notifier

For simple CLI integrations:

```bash
yubikey-touch-detector --stdout
```

## Sound Notification Script

Create a script to monitor the socket and play sounds:

```bash
#!/bin/bash
# ~/.local/bin/yubikey-sound-notifier

SOCKET="${XDG_RUNTIME_DIR}/yubikey-touch-detector.socket"
SOUND_FILE="/usr/share/sounds/freedesktop/stereo/message.oga"

# Function to play sound
play_sound() {
    # Use paplay for PulseAudio
    paplay "$SOUND_FILE" 2>/dev/null || \
    # Fallback to aplay
    aplay "$SOUND_FILE" 2>/dev/null || \
    # Fallback to speaker-test
    speaker-test -t sine -f 1000 -l 1 &>/dev/null
}

# Monitor the socket
while true; do
    if [[ -S "$SOCKET" ]]; then
        # Connect to socket and read events
        nc -U "$SOCKET" | while read -n 5 event; do
            case "$event" in
                *_1)
                    echo "YubiKey waiting for touch: $event"
                    play_sound
                    ;;
                *_0)
                    echo "YubiKey touch completed: $event"
                    ;;
            esac
        done
    else
        echo "Waiting for yubikey-touch-detector socket..."
        sleep 5
    fi
done
```

## Configuration

### Service Configuration

Create `~/.config/yubikey-touch-detector/service.conf`:

```bash
# Custom GPG home directory (if different from default)
GNUPGHOME=/path/to/gnupg

# Enable verbose logging
YUBIKEY_TOUCH_DETECTOR_VERBOSE=true
```

### Enable the Service

```bash
# Reload systemd user services
systemctl --user daemon-reload

# Enable and start the socket
systemctl --user enable --now yubikey-touch-detector.socket
```

## Testing

Test detection with verbose mode:

```bash
# Run in verbose mode to see all events
yubikey-touch-detector --verbose

# In another terminal, trigger YubiKey operations:
gpg --card-status
ssh-add -l
```

## Integration with Voice Mode

For voice mode integration, we can create a dedicated sound player that connects to the YubiKey Touch Detector socket:

```python
#!/usr/bin/env python3
# ~/.local/bin/yubikey-voice-notifier

import os
import socket
import subprocess
import time

SOCKET_PATH = os.path.join(
    os.environ.get('XDG_RUNTIME_DIR', '/run/user/1000'),
    'yubikey-touch-detector.socket'
)

def play_notification():
    """Play a voice notification for YubiKey touch."""
    try:
        # Use voice mode to speak
        subprocess.run([
            'voicemode', 'converse',
            '--message', 'YubiKey needs touch',
            '--no-wait'
        ])
    except:
        # Fallback to system sound
        subprocess.run(['paplay', '/usr/share/sounds/freedesktop/stereo/message.oga'])

def monitor_yubikey():
    """Monitor YubiKey touch events."""
    while True:
        try:
            if os.path.exists(SOCKET_PATH):
                sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
                sock.connect(SOCKET_PATH)
                
                while True:
                    data = sock.recv(5)
                    if not data:
                        break
                    
                    event = data.decode('utf-8', errors='ignore')
                    if event.endswith('_1'):  # Touch needed
                        print(f"YubiKey touch needed: {event}")
                        play_notification()
                    
        except Exception as e:
            print(f"Connection error: {e}")
            time.sleep(5)

if __name__ == '__main__':
    monitor_yubikey()
```

## Troubleshooting

1. **Socket not found**: Ensure the service is running:
   ```bash
   systemctl --user status yubikey-touch-detector.socket
   ```

2. **No events detected**: Run in verbose mode to debug:
   ```bash
   yubikey-touch-detector --verbose
   ```

3. **Permission issues**: Check socket permissions:
   ```bash
   ls -la $XDG_RUNTIME_DIR/yubikey-touch-detector.socket
   ```