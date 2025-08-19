# Local LiveKit Setup Guide for Voice MCP

*Coming soon!*

This guide will cover:

## Running LiveKit Server Locally

- Docker setup
- Native installation
- Configuration options
- Security considerations

## Development Setup

- Running LiveKit alongside voice-mode development
- Debug configurations
- Testing with local services

## Advanced Configuration

- Custom TURN servers
- Recording setup
- Scaling considerations

For now, we recommend using [LiveKit Cloud](cloud-setup.md) for the easiest setup experience.

## Quick Docker Start

If you want to experiment with local LiveKit:

```bash
docker run -d \
  -p 7880:7880 \
  -p 7881:7881 \
  -p 7882:7882/udp \
  -e LIVEKIT_KEYS="devkey: secret" \
  livekit/livekit-server \
  --dev
```

Then set:
```bash
export LIVEKIT_URL="ws://127.0.0.1:7880"
export LIVEKIT_API_KEY="devkey"
export LIVEKIT_API_SECRET="secret"
```

See the [LiveKit self-hosting docs](https://docs.livekit.io/home/self-hosting/vm/) for more details.