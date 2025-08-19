# OpenAI-Compatible API Endpoints

For voice-mode, we exclusively use OpenAI-compatible API endpoints to ensure consistency and compatibility across different TTS/STT providers.

## Documentation Endpoints

### OpenAPI/Swagger
- `/docs` - Interactive Swagger UI (FastAPI default)
- `/redoc` - Alternative ReDoc UI documentation
- `/openapi.json` - Raw OpenAPI 3.0 specification
- `/swagger.json` - Legacy Swagger 2.0 specification
- `/api-docs` - Common alternative path
- `/api/docs` - Another common variant

### GraphQL
- `/graphql` - GraphQL playground
- `/graphiql` - GraphQL IDE
- `/__graphql` - Apollo Server default

## Discovery & Health Endpoints

### Service Information
- `/` - Root endpoint, often lists available resources
- `/health` - Basic health check
- `/healthz` - Kubernetes-style health check
- `/ready` or `/readyz` - Readiness check
- `/status` - Detailed service status
- `/ping` - Simple connectivity check
- `/version` - API version information
- `/info` - General service information

### API Resources
- `/api` - API root, lists versions
- `/v1` - Version-specific root
- `/api/v1` - Combined API version root

## OpenAI-Compatible Endpoints (Used by voice-mode)

These are the standard OpenAI API endpoints we use:

### Core Endpoints
- `/v1/models` - List available models
- `/v1/models/{model}` - Get specific model details

### Audio Endpoints
- `/v1/audio/speech` - Text-to-speech generation
- `/v1/audio/transcriptions` - Speech-to-text transcription

### Health/Status
- `/health` - Basic health check (provider-specific)

**Note**: We intentionally avoid provider-specific endpoints like `/v1/audio/voices` to maintain compatibility across different providers.

## Examples

### Kokoro TTS
```bash
# Documentation
curl http://127.0.0.1:8880/docs
curl http://127.0.0.1:8880/openapi.json

# API endpoints
curl http://127.0.0.1:8880/v1/models
curl http://127.0.0.1:8880/v1/audio/voices
curl http://127.0.0.1:8880/health
```

### OpenAI API
```bash
# Models
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY"
```

## Tips

1. **Always check `/docs` first** - Most modern APIs provide interactive documentation
2. **Look for OpenAPI spec** - `/openapi.json` provides machine-readable API definition
3. **Try without authentication first** - Many discovery endpoints don't require auth
4. **Check response headers** - Often contain API version and rate limit info
5. **Use browser for UI endpoints** - `/docs`, `/redoc`, `/graphql` are meant for browsers