# Installing Voice Assistant on iPhone

Since the TestFlight beta has expired, you'll need to build and install the Voice Assistant app directly from source using Xcode.

## Prerequisites

- Mac with Xcode installed (latest version recommended)
- Apple Developer account (free account works for personal use)
- iPhone connected via USB
- Voice MCP with LiveKit Cloud configured

## Step 1: Clone the Voice Assistant Swift Repository

```bash
# From your voice-mode directory
cd .external
git clone https://github.com/livekit-examples/voice-assistant-swift.git
cd voice-assistant-swift
```

## Step 2: Configure LiveKit Credentials

### Option A: Using Sandbox ID (Recommended for testing)
1. Create a new [Sandbox Token Server](https://cloud.livekit.io/projects/p_/sandbox/templates/token-server) in LiveKit Cloud
2. Create `.env.xcconfig` file:
   ```bash
   echo "LIVEKIT_SANDBOX_ID = your_sandbox_id_here" > VoiceAssistant/.env.xcconfig
   ```

### Option B: Using Direct Credentials
1. Open `VoiceAssistant.xcodeproj` in Xcode
2. Navigate to `TokenService.swift`
3. Modify the token generation to use your LiveKit project credentials

## Step 3: Configure Xcode for Your Device

1. Open `VoiceAssistant.xcodeproj` in Xcode
2. Select the VoiceAssistant target
3. Go to "Signing & Capabilities" tab
4. Change the Team to your Apple Developer account
5. Change the Bundle Identifier to something unique (e.g., `com.yourname.voiceassistant`)

## Step 4: Build and Install on iPhone

1. Connect your iPhone via USB
2. Select your iPhone as the build target in Xcode
3. Click the "Run" button (▶️) or press Cmd+R
4. When prompted on your iPhone, trust the developer certificate:
   - Go to Settings → General → VPN & Device Management
   - Tap your developer account
   - Tap "Trust"

## Step 5: Configure the App

1. Open Voice Assistant on your iPhone
2. If using direct credentials:
   - Enter your LiveKit project URL
   - Enter your API Key
   - Enter your API Secret
3. If using sandbox, it should connect automatically

## Step 6: Test the Connection

1. In Claude on your computer:
   ```
   "Create a LiveKit room for voice conversation"
   ```
2. On your iPhone, tap "Connect" in Voice Assistant
3. Start talking - you should hear Claude respond!

## Troubleshooting

**"Untrusted Developer" error**
- Go to Settings → General → VPN & Device Management
- Find your developer account and tap "Trust"

**Build fails in Xcode**
- Ensure you've selected a valid Team in Signing & Capabilities
- Try changing the Bundle Identifier to something unique
- Update to the latest Xcode version

**Can't connect to LiveKit**
- Verify your LiveKit credentials are correct
- Check that voice-mode is running with proper .env.local configuration
- Ensure your iPhone has internet connectivity

**No audio**
- Check iPhone volume and mute switch
- Ensure microphone permissions are granted to Voice Assistant
- Try using headphones or AirPods

## Alternative: Using LiveKit CLI

If you have LiveKit CLI installed, you can use it to set up the app:

```bash
lk app create --template voice-assistant-swift --sandbox <token_server_sandbox_id>
```

This will automatically clone and configure the project with your sandbox credentials.

## Next Steps

Once installed, you can:
- Customize the app appearance in Xcode
- Add features or modify the voice interface
- Build for iPad or Vision Pro (the app supports all Apple platforms)
- Create a proper token server for production use

For more information, see the [Voice Assistant Swift repository](https://github.com/livekit-examples/voice-assistant-swift).