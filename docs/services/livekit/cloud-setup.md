# LiveKit Cloud Setup for Voice MCP

Get Claude talking through your browser or iPhone in under 10 minutes using LiveKit Cloud's free tier.

## Prerequisites

- [ ] Voice MCP installed and working locally
- [ ] OpenAI API key configured
- [ ] Node.js installed (for the web frontend)
- [ ] A web browser
- [ ] (Optional) iPhone with TestFlight for mobile access

## Step 1: Create a LiveKit Cloud Account

1. Go to [LiveKit Cloud](https://cloud.livekit.io)
2. Click **"Sign Up"** or **"Get Started Free"**
3. Create your account (GitHub login recommended)
4. You'll get **10,000 free participant minutes per month** - plenty for personal use (~2.7 hours/day with Claude)

## Step 2: Create a LiveKit Project

1. After logging in, click **"Projects"** in the left sidebar
2. Click **"Create Project"**
3. Name it something like "voice-mode" or "claude-voice"
4. Select your preferred region (closest to you)
5. Click **"Create"**

This creates a permanent project that won't expire like sandboxes do.

## Step 3: Get Your Project Credentials

1. In your new project, click **"Settings"** in the left sidebar
2. Go to **"API Keys"**
3. Click **"Add API Key"** to create your first key
4. Give it a name (e.g., "voice-mode-key")
5. Copy these three values:
   - **URL**: Your project URL (like `wss://your-project.livekit.cloud`)
   - **API Key**: Starts with `API`
   - **API Secret**: Click the eye icon to reveal

**Important**: Save these credentials securely - you'll need them for all future connections.


## Step 4: Configure Voice MCP

Create or update your `.env.local` file with your credentials:

```bash
# Copy the example file
cp .env.local.ignore .env.local

# Edit .env.local and add your credentials:
OPENAI_API_KEY=your-openai-key
LIVEKIT_URL=wss://your-project.livekit.cloud
LIVEKIT_API_KEY=your-api-key
LIVEKIT_API_SECRET=your-api-secret
```

Then restart voice-mode:
```bash
claude mcp restart voice-mode
```

## Step 5: Test Voice MCP Connection

In Claude, say:
```
"Check LiveKit room status"
```

You should see a response confirming LiveKit is connected. If not, double-check your credentials.

## Step 6: Set Up Web Frontend

### Install LiveKit CLI
```bash
curl -sSL https://get.livekit.io/cli | bash
```

### Create Voice Assistant App
From your project root directory:
```bash
lk app create --template voice-assistant-frontend
```

When prompted, enter your project credentials from Step 3.

### Run Your Frontend
```bash
cd voice-assistant-frontend
npm install
npm run dev
```

Visit `http://127.0.0.1:3000` to access your voice interface.

## Step 7: Set Up iPhone (Optional)

The TestFlight beta has expired. To install Voice Assistant on your iPhone, you'll need to build it from source using Xcode.

See [iPhone Installation Guide](./iphone-install.md) for detailed instructions on:
- Building the app from source
- Installing on your device
- Configuring with your LiveKit credentials

## Step 8: Start Talking!

### Web Frontend
1. Open `http://127.0.0.1:3000` in your browser
2. Click "Connect" or start talking
3. You'll hear Claude respond through your browser

### iPhone App
1. In Claude on your computer, say:
   ```
   "Let's have a voice conversation through LiveKit"
   ```
2. On your iPhone, tap **"Connect"** in Voice Assistant
3. Start talking - you'll hear Claude respond through your iPhone!

## Quick Test

To verify everything works:
- **In Claude**: "Check LiveKit room status" 
- **Web Frontend**: Visit 127.0.0.1:3000 and click Connect
- **iPhone App**: Tap Connect, say "Hello Claude"

## Troubleshooting

**"Connection failed" in Claude**
- Make sure URL starts with `wss://` not `https://`
- Run `claude mcp restart voice-mode`

**Can't connect on iPhone**
- Double-check all three credentials
- Make sure you saved the settings
- Try force-closing and reopening the app

**No audio**
- Check iPhone volume and mute switch
- Ensure microphone permissions are granted
- Try using headphones

## Next Steps

Once you have this working:
- Try the [LiveKit Playground](https://cloud.livekit.io) for web access
- Explore other [voice assistant examples](https://github.com/livekit-examples)
- Build your own custom frontend

## Free Tier Usage

With LiveKit Cloud's free tier:
- **10,000 participant minutes/month** included
- **No credit card required**
- Resets on the 1st of each month
- Perfect for personal use (you + Claude = 2 participants = 5,000 minutes/month)

See [pricing guide](./pricing.md) for detailed calculations.

## Resources

- [LiveKit Cloud Dashboard](https://cloud.livekit.io)
- [LiveKit Cloud Docs](https://docs.livekit.io/home/cloud/)
- [Voice MCP Issues](https://github.com/mbailey/voice-mode/issues)
- [LiveKit Pricing](https://livekit.io/pricing)
