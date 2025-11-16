# 🔧 Simple AI Setup Guide

## Two Types of Models

### 🖥️ Local Models (Fast & Private)
- **Qwen 3**: Chat and problem-solving
- **GLM-4.6**: Advanced reasoning
- ⚡ Fastest responses, runs on your PC
- 🔒 Private, no internet needed after setup

### ☁️ Cloud Models (Always Available) 
- **Kimi**: General purpose via Groq
- **Llama 70B**: Powerful reasoning via Groq  
- **Mixtral 8x7B**: Balanced performance via Groq
- 🌐 Always online, internet required
- 🚀 Super fast cloud responses

## Quick Setup

### 1. Get Groq API Key (For Cloud Models)
1. Visit: https://console.groq.com
2. Sign up and create API key
3. Copy key (starts with `gsk_...`)

### 2. Add API Keys (Multiple for Rate Limit Protection)
Open `.env` file and add your keys:
```env
GROQ_API_KEY1=gsk_your_first_key_here
GROQ_API_KEY2=gsk_your_second_key_here
GROQ_API_KEY3=gsk_your_third_key_here
# Add up to 5 keys for best performance
```

**Pro Tip**: Multiple keys = No rate limits! System automatically rotates between them.

### 3. Install Local Models
```bash
ollama pull qwen3:1.7b
ollama pull glm-4.6:latest
```

### 4. Start Everything
Desktop → Double-click `START_AJSTUDIOZ_AI.bat`

## How It Works

- **Each model works independently**
- **No complex fallbacks or confusion**  
- **Local models = Fast but need Ollama running**
- **Cloud models = Always work with internet + API key**
- **Choose the right model for your needs**

## Usage Guide

### For Speed → Use Local Models
- Select "Qwen 3" or "GLM-4.6" 
- Requires Ollama running
- Fastest responses

### For Reliability → Use Cloud Models  
- Select "Kimi", "Llama 70B", or "Mixtral"
- Always available
- No Ollama needed

### Mixed Usage
- Start with local models for speed
- Switch to cloud if local issues
- Both work through same chatbot interface

## Troubleshooting

**Local models not working?**
- Start Ollama: `ollama serve`
- Install models as shown above
- Cloud models still work fine

**Cloud models not working?**  
- Check `.env` has real API key
- Restart server after updating
- Local models still work fine

**Both not working?**
- Check internet connection
- Verify Ollama is installed and running
- Restart services with desktop starter

---

**Simple rule: Local = Fast, Cloud = Reliable. Use what works best!** 🎯