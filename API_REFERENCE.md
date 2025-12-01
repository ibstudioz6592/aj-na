# 🚀 GitHub Models API - Quick Reference

## Your Setup
- **Token**: Set `GITHUB_TOKEN` in `.env` file
- **Base URL**: `https://models.inference.ai.azure.com`
- **Status**: ✅ FREE unlimited access as student

## Available Models (All FREE!)
```
gpt-4o                    # Premium GPT-4 Omni
gpt-4o-mini              # Fast & efficient GPT-4
claude-3-5-haiku         # Anthropic Claude 3.5
llama-3.1-8b-instruct    # Meta Llama 3.1
llama-3.1-70b-instruct   # Larger Llama model
phi-3-medium-instruct    # Microsoft Phi-3
```

## Quick Test Commands

### PowerShell (Windows)
```powershell
.\test_github_models.ps1
```

### Python 
```python
python github_models_api.py
```

### cURL (Any OS)
```bash
bash test_github_models.sh
```

## Basic cURL Template
```bash
curl -X POST "https://models.inference.ai.azure.com/chat/completions" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o-mini",
    "messages": [{"role": "user", "content": "Your question here"}],
    "temperature": 0.7,
    "max_tokens": 500
  }'
```

## PowerShell One-Liner
```powershell
$headers = @{"Authorization" = "Bearer $env:GITHUB_TOKEN"; "Content-Type" = "application/json"}; $body = '{"model": "gpt-4o-mini", "messages": [{"role": "user", "content": "Hello!"}], "temperature": 0.7, "max_tokens": 100}'; Invoke-RestMethod -Uri "https://models.inference.ai.azure.com/chat/completions" -Method POST -Headers $headers -Body $body
```

## Python One-Liner
```python
import os, requests; requests.post("https://models.inference.ai.azure.com/chat/completions", headers={"Authorization": f"Bearer {os.getenv('GITHUB_TOKEN')}", "Content-Type": "application/json"}, json={"model": "gpt-4o-mini", "messages": [{"role": "user", "content": "Hello!"}]}).json()
```

## Response Format
```json
{
  "choices": [
    {
      "message": {
        "role": "assistant", 
        "content": "Response text here"
      }
    }
  ],
  "usage": {
    "prompt_tokens": 10,
    "completion_tokens": 20,
    "total_tokens": 30
  }
}
```

## Parameters
- `model`: Model name (required)
- `messages`: Array of chat messages (required) 
- `temperature`: 0.0-2.0 (creativity level)
- `max_tokens`: Max response length
- `stream`: true/false (streaming response)

## Rate Limits
✅ **No rate limits for students!**
- Unlimited requests
- All models included
- No credit card required

## Next Steps
1. Run: `.\test_github_models.ps1`
2. Try different models
3. Build your AI app!

---
*Your GitHub student benefits include unlimited access to all these premium AI models for FREE!*