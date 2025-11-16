# 🔧 Setup Your Groq API Key

## Why Groq?
- **Always Available**: Cloud backup when local models are offline
- **Lightning Fast**: Groq's hardware acceleration provides ultra-fast responses  
- **Reliable**: 99.9% uptime guarantee
- **Cost Effective**: Free tier includes substantial usage

## Get Your Groq API Key

### Step 1: Create Account
1. Go to: https://console.groq.com
2. Sign up with email or GitHub
3. Verify your account

### Step 2: Generate API Key
1. Go to **API Keys** section
2. Click **Create API Key**
3. Copy the key (starts with `gsk_...`)

### Step 3: Add to Your Project

**Option 1: Environment File (Recommended)**
1. Open: `c:\New folder\aj-fresh\.env`
2. Replace `your_groq_api_key_here` with your actual key:
```
GROQ_API_KEY=gsk_your_actual_key_here
OLLAMA_URL=http://localhost:11434
NODE_ENV=production
PORT=3001
```

**Option 2: Windows Environment Variable**
```powershell
[Environment]::SetEnvironmentVariable("GROQ_API_KEY", "gsk_your_actual_key_here", "User")
```

## Test Your Setup

### 1. Start Services
Desktop → Double-click `START_AJSTUDIOZ_AI.bat`

### 2. Test Groq Models
```bash
curl -X POST "http://localhost:3001/api/chat" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: aj-demo123456789abcdef" \
  -d '{
    "model": "kimi",
    "messages": [{"role": "user", "content": "Hello from Groq!"}]
  }'
```

### 3. Test in Chatbot
1. Open: http://localhost:3001/chatbot.html
2. Select: **Kimi (Groq)** from dropdown
3. Send a message
4. Should get fast response from cloud!

## Model Fallback System

Your setup now has **smart fallback**:

1. **Local First**: Uses Ollama models when available (fastest)
2. **Cloud Backup**: Automatically switches to Groq if local fails
3. **Always Online**: Cloud models work even when Ollama is offline

## Benefits

### ✅ Advantages
- **Reliability**: Always have working AI
- **Speed**: Groq models are extremely fast
- **Backup**: Never lose AI access
- **Quality**: High-quality responses

### 💡 Usage Tips
- Use **local models** for fastest responses
- Use **Kimi/Groq** when local models are busy
- **Llama 3.1 70B** for complex reasoning
- **Gemma 2 9B** for balanced performance

## Free Tier Limits

Groq offers generous free usage:
- **Rate Limits**: High requests per minute
- **Monthly Tokens**: Substantial free allowance
- **No Credit Card**: Required only for higher tiers

Perfect for development and moderate usage!

## Security

- ✅ API key stored in `.env` (not in code)
- ✅ `.env` in `.gitignore` (won't be pushed to GitHub)
- ✅ Local environment only
- ✅ No API key exposure

## Troubleshooting

### "Groq API key not configured"
1. Check `.env` file exists
2. Verify API key is correct (starts with `gsk_`)
3. Restart services after adding key

### "Groq API error: 401"
- API key is invalid
- Get new key from Groq console

### "Groq API error: 429" 
- Rate limit exceeded
- Wait a moment or upgrade Groq plan

---

**You now have the best of both worlds: Fast local models + Reliable cloud backup!** 🚀