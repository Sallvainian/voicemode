# OpenAI API Routing and Proxy Patterns

voice-mode uses the OpenAI SDK, which means you can redirect all API traffic through a custom router using the standard `OPENAI_BASE_URL` environment variable - no voice-mode specific code or configuration needed.

## Why OpenAI API Compatibility Matters

By using only standard OpenAI endpoints, voice-mode becomes a simple API client that can work with any OpenAI-compatible service. This design enables:

1. **Service Agnostic**: Works with OpenAI, Azure OpenAI, local services, or any compatible API
2. **Simple Configuration**: Just change the `BASE_URL` environment variable
3. **External Control**: All routing logic lives outside voice-mode
4. **Future Proof**: New providers can be added without code changes

## Routing Patterns

### 1. Simple Proxy with Fallback

```nginx
# nginx configuration example
upstream openai_primary {
    server api.openai.com:443;
}

upstream openai_fallback {
    server 127.0.0.1:8880;  # Local Kokoro TTS
}

location /v1/audio/speech {
    proxy_pass https://openai_primary;
    proxy_intercept_errors on;
    error_page 502 503 504 = @fallback;
}

location @fallback {
    proxy_pass http://openai_fallback;
}
```

### 2. Cost-Optimized Router

```python
# Python routing proxy example
from fastapi import FastAPI, Request
import httpx

app = FastAPI()

@app.post("/v1/audio/speech")
async def route_tts(request: Request):
    body = await request.json()
    
    # Route based on model
    if body.get("model") == "tts-1":
        # Use local Kokoro for standard TTS
        async with httpx.AsyncClient() as client:
            return await client.post(
                "http://127.0.0.1:8880/v1/audio/speech",
                json=body
            )
    else:
        # Use OpenAI for advanced models
        async with httpx.AsyncClient() as client:
            return await client.post(
                "https://api.openai.com/v1/audio/speech",
                json=body,
                headers={"Authorization": request.headers.get("Authorization")}
            )
```

### 3. Voice-Specific Routing

```javascript
// Node.js Express router
app.post('/v1/audio/speech', async (req, res) => {
    const { voice, model } = req.body;
    
    // Route Sky voice to Kokoro, others to OpenAI
    if (voice === 'af_sky') {
        const response = await fetch('http://127.0.0.1:8880/v1/audio/speech', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ ...req.body, model: 'kokoro-v0.87' })
        });
        res.send(await response.arrayBuffer());
    } else {
        // Forward to OpenAI
        const response = await fetch('https://api.openai.com/v1/audio/speech', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': req.headers.authorization
            },
            body: JSON.stringify(req.body)
        });
        res.send(await response.arrayBuffer());
    }
});
```

### 4. Load Balancer with Health Checks

```yaml
# HAProxy configuration
global
    maxconn 4096

defaults
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

backend tts_servers
    balance roundrobin
    option httpchk GET /health
    
    server openai api.openai.com:443 ssl verify none check
    server kokoro1 127.0.0.1:8880 check
    server kokoro2 127.0.0.1:8881 check backup
```

## Configuration

### Simple Global Routing

The easiest approach is to use the OpenAI SDK's built-in support:

```bash
# Route ALL OpenAI API calls through your proxy
export OPENAI_BASE_URL="https://router.example.com/v1"
export OPENAI_API_KEY="your-key"
```

That's it! The OpenAI SDK automatically uses this base URL for all API calls.

**Note**: If `STT_BASE_URL` or `TTS_BASE_URL` are not explicitly set, voice-mode defaults to using the OpenAI API. When `OPENAI_BASE_URL` is set, the OpenAI SDK will use it automatically for these default cases.

### Provider-Specific Routing

For more granular control, voice-mode also supports provider-specific endpoints:

```bash
# Use different endpoints for STT and TTS
export STT_BASE_URL="http://127.0.0.1:2022/v1"  # Local Whisper
export TTS_BASE_URL="http://127.0.0.1:8880/v1"  # Local Kokoro
```

Your router receives all requests and can then:
- Route to different providers
- Add authentication
- Log requests
- Implement rate limiting
- Cache responses
- Transform requests/responses

## Benefits

1. **Zero Code Changes**: voice-mode doesn't need to know about routing logic
2. **Centralized Control**: Manage all API routing in one place
3. **Dynamic Switching**: Change routing rules without restarting voice-mode
4. **Multi-Service**: One router can handle STT, TTS, and other OpenAI APIs
5. **Monitoring**: Add metrics, logging, and observability at the proxy layer

## Example: LiteLLM Proxy

[LiteLLM](https://github.com/BerriAI/litellm) provides a ready-made proxy for OpenAI-compatible routing:

```bash
# Install LiteLLM
pip install litellm[proxy]

# Configure proxy
cat > litellm_config.yaml << EOF
model_list:
  - model_name: tts-1
    litellm_params:
      model: openai/tts-1
      api_key: $OPENAI_API_KEY
  - model_name: whisper-1
    litellm_params:
      model: openai/whisper-1
      api_key: $OPENAI_API_KEY
EOF

# Start proxy
litellm --config litellm_config.yaml --port 9000

# Configure voice-mode
export TTS_BASE_URL="http://127.0.0.1:9000"
export STT_BASE_URL="http://127.0.0.1:9000"
```

This architecture ensures voice-mode remains simple while enabling sophisticated deployment patterns through external routing layers.