# 🚀 AJStudioz AI - Complete Setup Guide

## ✅ Quick Start

### 1. Double-Click to Start (Easiest Way!)

**On your Desktop, find and double-click:**
```
🚀 START_AJSTUDIOZ_AI.bat
```

This will:
- Start Ollama (AI models)
- Start API Server (port 3001)
- Start Cloudflare Tunnel
- Make your API accessible at: `https://api.ajstudioz.dev/api/chat`

### 2. Stop Services

In the project folder, double-click:
```
STOP_ALL_SERVICES.bat
```

### 3. Test Your API

In the project folder, right-click → "Run with PowerShell":
```
TEST_API.ps1
```

## 🌐 Your API Endpoints

### GitHub Models (FREE for Students - BEST!)
```bash
curl -X POST "https://api.ajstudioz.dev/api/chat" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: aj-demo123456789abcdef" \
  -d '{
    "model": "gpt-4o",
    "messages": [{"role": "user", "content": "Hello from GitHub Models!"}],
    "stream": false
  }'
```

### Cloud Models (24/7 - Recommended)
```bash
curl -X POST "https://api.ajstudioz.dev/api/chat" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: aj-demo123456789abcdef" \
  -d '{
    "model": "kimi",
    "messages": [{"role": "user", "content": "Hello from Vercel cloud!"}],
    "stream": false
  }'
```

### Local Models (When Ollama Running)
```bash
curl -X POST "https://local-api.ajstudioz.dev/api/chat" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: aj-demo123456789abcdef" \
  -d '{
    "model": "qwen3-local",
    "messages": [{"role": "user", "content": "Hello local model!"}],
    "stream": false
  }'
```

## 🤖 Available Models

### 🎓 GitHub Models (FREE Unlimited for Students!)
| Model | Provider | Best For | Status |
|-------|----------|----------|--------|
| `gpt-4o` | OpenAI (GitHub) | Premium GPT-4 Omni - most advanced | 🎓 FREE |
| `gpt-4o-mini` | OpenAI (GitHub) | Fast & efficient GPT-4 | 🎓 FREE |
| `claude-3-5-haiku` | Anthropic (GitHub) | Claude 3.5 Haiku reasoning | 🎓 FREE |
| `llama-3-1-8b` | Meta (GitHub) | Llama 3.1 8B Instruct | 🎓 FREE |

### ☁️ Cloud Models (Always Online 24/7 via Vercel)
| Model | Provider | Best For | Status |
|-------|----------|----------|--------|
| `kimi` | MoonShot AI (Groq) | Advanced chat & instruction following | ✅ 24/7 |
| `qwen3` | Qwen 32B (Groq) | Powerful reasoning with 32B parameters | ✅ 24/7 |
| `llama-4` | Meta Llama 4 (Groq) | Advanced model with 128K context | ✅ 24/7 |
| `gpt-oss` | GPT OSS 20B (Groq) | Open-source optimized performance | ✅ 24/7 |

### 🖥️ Local Models (Optional - Start when needed)
| Model | Size | Best For | Status |
|-------|------|----------|--------|
| `qwen3-local` | 1.7B | Fast responses, chat | 🖥️ Local |
| `glm-4.6` | Latest | Advanced reasoning | 🖥️ Local |

## ⚙️ Configuration

### API Keys
- Demo Key: `aj-demo123456789abcdef`
- Test Key: `aj-test987654321fedcba`

### Endpoints
- **Cloud Models (24/7):** `https://api.ajstudioz.dev/api/chat`
- **Local Models:** `https://local-api.ajstudioz.dev/api/chat`
- **Local Development:** `http://localhost:3001/api/chat`
- **Health Check:** `http://localhost:3001/health`
- **Chatbot Interface:** `https://api.ajstudioz.dev/chatbot.html`

## 📁 Project Files

### Essential Files (Don't Delete!)
- `proxy-server.js` - API server
- `config.yml` - Cloudflare tunnel configuration
- `package.json` - Node.js dependencies
- `cloudflared.exe` - Cloudflare tunnel client
- `api/` - API endpoints
- `public/` - Web interface
- `lib/` - Helper libraries

### Starter Scripts
- `🚀 START_AJSTUDIOZ_AI.bat` - Main starter (also on Desktop)
- `STOP_ALL_SERVICES.bat` - Stop all services
- `START_CLOUDFLARE_API.ps1` - Alternative PowerShell starter
- `TEST_API.ps1` - Test your API

### Documentation
- `README.md` - This file
- `FINAL_SOLUTION.md` - Setup documentation
- `✅ SUCCESS_GUIDE.md` - Success guide

## 🔧 Troubleshooting

### Services Won't Start
```powershell
# Check what's running
Get-Process -Name "ollama","node","cloudflared"

# Kill stuck processes
Get-Process -Name "ollama","node","cloudflared" | Stop-Process -Force
```

### API Returns 404
This means DNS hasn't been updated yet. You need to:

1. Go to **Cloudflare Dashboard**: https://dash.cloudflare.com
2. Select domain: **ajstudioz.dev**
3. Go to **DNS → Records**
4. Find the `api` record
5. If it points to Vercel (or shows an IP), **DELETE** it
6. The tunnel will automatically work once the old record is removed

### Local API Works, Global Doesn't
```powershell
# Test local first
curl http://localhost:3001/health

# If local works, it's a DNS issue - see above
```

### DNS Cache Issues
```powershell
# Clear DNS cache
ipconfig /flushdns

# Or try from different network (mobile hotspot)
```

## 🎯 Important DNS Note

**Current Status:**
- ✅ Cloudflare Tunnel: Configured and running
- ✅ Local API: Working perfectly
- ⚠️ DNS: `api.ajstudioz.dev` may still point to old Vercel deployment

**To Fix DNS:**
Since you deleted the domain from Vercel, the DNS record in Cloudflare Dashboard is now invalid. You need to:

1. **Delete** the old DNS record for `api` in Cloudflare Dashboard
2. DNS will automatically route to your tunnel once the old record is gone
3. Wait 1-2 minutes for DNS propagation

**Alternative:** The tunnel can also work on `local-api.ajstudioz.dev` which is already configured.

## 📊 System Requirements

- Windows 10/11
- Ollama installed
- Node.js installed
- Cloudflare account with tunnel configured

## 🔒 Security

- API requires valid API key in `X-API-Key` header
- Cloudflare provides HTTPS encryption
- Rate limiting enabled per API key
- CORS enabled for web applications

## 📱 Example Usage

### PowerShell (GitHub Models - FREE!)
```powershell
$headers = @{
    "Content-Type" = "application/json"
    "X-API-Key" = "aj-demo123456789abcdef"
}

$body = @{
    model = "gpt-4o-mini"
    messages = @(@{ role = "user"; content = "Hello from GitHub Models FREE!" })
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://api.ajstudioz.dev/api/chat" -Method POST -Headers $headers -Body $body
```

### PowerShell (Vercel Cloud)
```powershell
$headers = @{
    "Content-Type" = "application/json"
    "X-API-Key" = "aj-demo123456789abcdef"
}

$body = @{
    model = "kimi"
    messages = @(@{ role = "user"; content = "Hello from Vercel cloud!" })
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://api.ajstudioz.dev/api/chat" -Method POST -Headers $headers -Body $body
```

### JavaScript (Vercel Cloud)
```javascript
const response = await fetch('https://api.ajstudioz.dev/api/chat', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-API-Key': 'aj-demo123456789abcdef'
  },
  body: JSON.stringify({
    model: 'kimi',
    messages: [{ role: 'user', content: 'Hello from Vercel!' }]
  })
});

const data = await response.json();
console.log(data);
```

### Python
```python
import requests

response = requests.post(
    'https://api.ajstudioz.dev/api/chat',
    headers={
        'Content-Type': 'application/json',
        'X-API-Key': 'aj-demo123456789abcdef'
    },
    json={
        'model': 'qwen3',
        'messages': [{'role': 'user', 'content': 'hello'}]
    }
)

print(response.json())
```

## 🎉 What You've Built

✅ Global AI API accessible from anywhere  
✅ Multiple AI models (Qwen, GLM, DeepSeek)  
✅ OpenAI-compatible API format  
✅ Secure with API key authentication  
✅ Cloudflare's global CDN  
✅ One-click desktop starter  
✅ Professional API documentation  

## 📞 Support

- Check logs in the terminal window
- Test local API first: `http://localhost:3001/health`
- Verify services running: `Get-Process -Name "ollama","node","cloudflared"`
- Check Cloudflare Dashboard for tunnel status

---

**Ready to go!** Double-click `🚀 START_AJSTUDIOZ_AI.bat` on your Desktop to start!
