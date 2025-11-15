# 🚀 AJStudioz AI - Cloudflare Tunnel Quick Start

## ✅ YOUR API IS WORKING!

```bash
curl -X POST "https://local-api.ajstudioz.dev/api/chat" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: aj-demo123456789abcdef" \
  -d '{"model": "qwen3", "messages": [{"role": "user", "content": "hello"}], "stream": false}'
```

## 🎯 Quick Start

1. **Start All Services:**
   ```powershell
   cd "c:\New folder\aj-fresh"
   .\START_CLOUDFLARE_API.ps1
   ```

2. **Test It:**
   ```powershell
   .\TEST_WORKING_ENDPOINT.ps1
   ```

3. **Use It:**
   Your local AI is now accessible at:
   - Local: `http://localhost:3001/api/chat`
   - Global: `https://local-api.ajstudioz.dev/api/chat` ✅

## 📚 Documentation

- **✅ SUCCESS_GUIDE.md** - Complete success summary (READ THIS FIRST!)
- **FINAL_SOLUTION.md** - How to fix api.ajstudioz.dev DNS
- **CLOUDFLARE_SETUP_INSTRUCTIONS.md** - Detailed setup guide
- **TEST_ALL_ENDPOINTS.ps1** - Test all endpoints
- **TEST_WORKING_ENDPOINT.ps1** - Test working tunnel

## 🔥 What's Working

✅ Ollama (AI models)  
✅ Node.js API (port 3001)  
✅ Cloudflare Tunnel  
✅ DNS: local-api.ajstudioz.dev  
✅ **TESTED AND VERIFIED!**

## ⚠️ To Use api.ajstudioz.dev

Your original request was to use `api.ajstudioz.dev`. Currently this points to Vercel.

**Fix:** Delete Vercel DNS record in Cloudflare Dashboard → Route to tunnel

**Details:** See **FINAL_SOLUTION.md**

## 🤖 Available Models

- `qwen3` - Qwen 3 (1.7B) ✅ WORKING
- `glm-4.6` - GLM-4.6 (Cloud)
- `deepseek-r1` - DeepSeek R1 (8B)
- `deepseek-r1-small` - DeepSeek R1 (1.5B)
- `qwen2` - Qwen 2 (0.5B)

## 🛠️ Troubleshooting

```powershell
# Check if services are running
Get-Process -Name "ollama","node","cloudflared"

# Restart everything
Get-Process -Name "ollama","node","cloudflared" | Stop-Process -Force
.\START_CLOUDFLARE_API.ps1

# Test local API
curl http://localhost:3001/health
```

## 📞 Quick Commands

| Action | Command |
|--------|---------|
| Start | `.\START_CLOUDFLARE_API.ps1` |
| Test | `.\TEST_WORKING_ENDPOINT.ps1` |
| Stop | `Get-Process -Name "ollama","node","cloudflared" \| Stop-Process -Force` |
| Check | `Get-Process -Name "ollama","node","cloudflared"` |

---

**🎉 Your local AI models are now accessible globally!**

Use: `https://local-api.ajstudioz.dev/api/chat`
