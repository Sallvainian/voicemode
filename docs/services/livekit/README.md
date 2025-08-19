# LiveKit Integration for Voice Mode

## Overview

LiveKit is a powerful real-time voice and video infrastructure that enables voice-mode to work beyond your local computer. With LiveKit, you can have voice conversations with Claude from anywhere - your phone, tablet, or any device with a web browser.

## Why LiveKit for Voice Mode?

### 🌐 Access from Anywhere
- Talk to Claude from your iPhone, Android, or any web browser
- No need to be at your computer with microphone access
- Works great on mobile devices

### 🚀 Zero Setup for End Users
- No local installations required
- Just open a web page and start talking
- LiveKit Cloud handles all the infrastructure

### 🔧 Simple for Developers
- Use LiveKit Cloud's free sandbox to get started in minutes
- No servers to manage or configure
- Same voice-mode experience, now accessible remotely

## Quick Start Options

### Option 1: LiveKit Cloud (Recommended for Tonight!)
**Perfect for:** Getting started quickly, testing, and personal use

[**→ Follow the LiveKit Cloud Setup Guide**](cloud-setup.md)

This guide will walk you through:
1. Creating a free LiveKit Cloud account
2. Setting up a sandbox project
3. Configuring voice-mode to connect
4. Using a web frontend to talk to Claude from any device

**Time required:** ~15 minutes

### Option 2: Local LiveKit Server
**Perfect for:** Development, customization, and self-hosting

[**→ Local LiveKit Setup Guide**](local-setup.md) *(Coming soon)*

## How It Works

```
Your Device          LiveKit Cloud         Voice Mode
(iPhone/Web)         (Sandbox)            (with Claude)
    │                    │                     │
    ├──── Voice ────────►│                     │
    │                    ├──── Audio ─────────►│
    │                    │                     ├─ Claude
    │                    │◄──── Response ──────┤
    │◄─── Speech ────────┤                     │
```

1. You speak into your device (phone, tablet, computer)
2. LiveKit Cloud captures and transmits your voice
3. Voice-mcp receives the audio and sends it to Claude
4. Claude's response is spoken back through LiveKit
5. You hear the response on your device

## Tonight's Goal

By the end of tonight, you'll be able to:
- ✅ Talk to Claude from your iPhone using voice-assistant-swift
- ✅ Access voice-mode from any web browser
- ✅ Have natural voice conversations without being at your computer

Ready? [**Let's set up LiveKit Cloud →**](cloud-setup.md)