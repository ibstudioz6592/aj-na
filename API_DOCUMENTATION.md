# AJ MEOW API Documentation

## 🚀 Professional AI API Platform

AJ MEOW provides enterprise-grade API endpoints compatible with OpenAI's format but with enhanced structured responses and reasoning capabilities.

## 🔗 Base URL
```
Production: https://api.ajstudioz.dev
Local Dev:  http://localhost:3001
```

## 🔐 Authentication

All requests require an API key in the header:
```bash
X-API-Key: aj-demo123456789abcdef
```

### Available API Keys (Demo)
- `aj-demo123456789abcdef` - Enterprise plan (unlimited)
- `aj-test987654321fedcba` - Pro plan (10K requests/month)

## 📊 Available Models

### GET `/api/models`

Returns list of available AI models.

**Response:**
```json
{
  "object": "list",
  "data": [
    {
      "id": "glm-4.6",
      "object": "model",
      "owned_by": "zhipu-ai",
      "description": "GLM-4.6 is a powerful conversational AI model with strong general capabilities",
      "max_tokens": 8192,
      "features": ["chat", "completion", "reasoning"],
      "capabilities": {
        "reasoning": "high",
        "coding": "high",
        "math": "high"
      }
    }
  ]
}
```

## 💬 Chat Completions

### POST `/api/chat`

Create a chat completion with structured response format.

**Request:**
```json
{
  "model": "qwen3:1.7b",
  "messages": [
    {"role": "user", "content": "Explain quantum computing"}
  ],
  "max_tokens": 2000,
  "temperature": 0.7,
  "stream": false
}
```

**Response (New Structured Format):**
```json
{
  "id": "resp_01ka32c8s9f6qbnzv5xaev37g6",
  "object": "response", 
  "status": "completed",
  "created_at": 1763187237,
  "output": [
    {
      "type": "reasoning",
      "id": "resp_01ka32c8s9f6qtdrp53em622xg",
      "status": "completed",
      "content": [
        {
          "type": "reasoning_text",
          "text": "The user is asking about quantum computing. I should explain..."
        }
      ]
    },
    {
      "type": "message",
      "id": "msg_01ka32c8s9f6rbargb2g311d2v", 
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "Quantum computing is a revolutionary computing paradigm...",
          "annotations": [],
          "logprobs": null
        }
      ]
    }
  ],
  "model": "qwen/qwen3:1.7b",
  "reasoning": {
    "effort": "medium"
  },
  "usage": {
    "input_tokens": 78,
    "output_tokens": 1890,
    "output_tokens_details": {
      "reasoning_tokens": 365
    },
    "total_tokens": 1968
  },
  "metadata": {
    "request_id": "req_abc123",
    "response_time_ms": 1250,
    "model_provider": "ollama"
  }
}
```

## 🧠 Reasoning Models

Models like GLM-4.6 and Qwen 3 include reasoning steps:

1. **Reasoning Output** - Shows the model's thinking process
2. **Message Output** - Contains the final response
3. **Effort Level** - Indicates reasoning complexity (low/medium/high)

## 📝 Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `model` | string | required | Model ID (see /api/models) |
| `messages` | array | required | Chat messages in OpenAI format |
| `max_tokens` | integer | 2000 | Maximum tokens to generate |
| `temperature` | float | 0.7 | Sampling temperature (0-2) |
| `top_p` | float | 0.9 | Nucleus sampling parameter |
| `stream` | boolean | false | Enable streaming responses |
| `user` | string | null | User identifier for tracking |

## 🔄 Streaming

Enable streaming with `"stream": true`:

```bash
curl -X POST "https://api.ajstudioz.dev/api/chat" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: aj-demo123456789abcdef" \
  -d '{
    "model": "qwen3:1.7b",
    "messages": [{"role": "user", "content": "Count to 10"}],
    "stream": true
  }'
```

**Streaming Response:**
```
data: {"id":"chatcmpl-abc","object":"chat.completion.chunk","choices":[{"delta":{"role":"assistant"},"finish_reason":null}]}

data: {"id":"chatcmpl-abc","object":"chat.completion.chunk","choices":[{"delta":{"content":"1"},"finish_reason":null}]}

data: [DONE]
```

## 🏥 Health Check

### GET `/health`

Check API status:

```json
{
  "status": "healthy",
  "timestamp": "2025-11-15T12:00:00.000Z",
  "version": "1.0.0"
}
```

## ⚡ Example Usage

### cURL
```bash
curl -X POST "https://api.ajstudioz.dev/api/chat" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: aj-demo123456789abcdef" \
  -d '{
    "model": "qwen3:1.7b",
    "messages": [
      {"role": "user", "content": "Write a Python function to calculate fibonacci"}
    ],
    "stream": false
  }'
```

### Python
```python
import requests

response = requests.post(
    "https://api.ajstudioz.dev/api/chat",
    headers={
        "Content-Type": "application/json",
        "X-API-Key": "aj-demo123456789abcdef"
    },
    json={
        "model": "qwen3:1.7b",
        "messages": [
            {"role": "user", "content": "Hello!"}
        ],
        "stream": False
    }
)

data = response.json()
message = data["output"][1]["content"][0]["text"]
print(message)
```

### JavaScript
```javascript
const response = await fetch('https://api.ajstudioz.dev/api/chat', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'X-API-Key': 'aj-demo123456789abcdef'
    },
    body: JSON.stringify({
        model: 'qwen3:1.7b',
        messages: [
            {role: 'user', content: 'Hello!'}
        ],
        stream: false
    })
});

const data = await response.json();
const message = data.output.find(o => o.type === 'message').content[0].text;
console.log(message);
```

## 🚨 Error Handling

All errors follow this format:

```json
{
  "error": {
    "type": "invalid_request_error",
    "code": "model_not_found", 
    "message": "Model 'invalid-model' not found",
    "param": "model",
    "request_id": "req_abc123"
  }
}
```

### Common Error Codes
- `invalid_api_key` - API key missing or invalid
- `model_not_found` - Requested model not available  
- `missing_required_parameter` - Required field missing
- `rate_limit_exceeded` - Too many requests
- `internal_server_error` - Server processing error

## 📊 Rate Limits

| Plan | Requests/minute | Tokens/month |
|------|-----------------|--------------|
| Free | 20 | 100K |
| Pro | 100 | 1M |
| Enterprise | Unlimited | Unlimited |

## 🎯 Response Format Comparison

**AJ MEOW (New Format):**
- Structured `output` array with reasoning and message separation
- Detailed `metadata` with performance metrics
- Enhanced `usage` stats with reasoning token counts

**OpenAI Compatible:**
- Standard `choices` array format supported as fallback
- Compatible with existing OpenAI client libraries

## 🔧 Integration Notes

1. **Reasoning Models**: Check for `reasoning` output type for chain-of-thought
2. **Error Handling**: Always check `error` field first
3. **Streaming**: Use Server-Sent Events (SSE) format
4. **Rate Limits**: Implement exponential backoff
5. **API Keys**: Rotate keys regularly for security

---

**Need Help?** Check our GitHub repository: https://github.com/tomo-academy/AJ-the-