# 🚀 Complete GitHub Models Guide - All Available Models & Usage Monitoring

## 📊 **Rate Limits by Copilot Plan** (December 2025)

### **Free Tier (No Copilot)**
- ❌ **No access to GitHub Models** without at least Copilot Free

### **Copilot Free** (FREE for students!)
| Model Type | RPM | RPD | Tokens/Request | Concurrent |
|------------|-----|-----|----------------|------------|
| **Low** (GPT-4o-mini, etc.) | 15 | 150 | 8K in, 4K out | 5 |
| **High** (GPT-4o, Claude, etc.) | 10 | 50 | 8K in, 4K out | 2 |
| **Embedding** | 15 | 150 | 64K | 5 |

### **Copilot Pro** ($10/month)
| Model Type | RPM | RPD | Tokens/Request | Concurrent |
|------------|-----|-----|----------------|------------|
| **Low** | 15 | 150 | 8K in, 4K out | 5 |
| **High** | 10 | 50 | 8K in, 4K out | 2 |
| **Premium** (o1, DeepSeek-R1) | 1-2 | 8-12 | 4K in, 4K out | 1 |

## 🤖 **Complete Model List** (All FREE with Student Copilot!)

### **🔥 High-Performance Models**
```
gpt-4o                    # OpenAI GPT-4 Omni (Premium)
gpt-4o-mini              # OpenAI GPT-4 Mini (Fast)
gpt-5                    # OpenAI GPT-5 (Latest!)
gpt-5-mini               # OpenAI GPT-5 Mini
gpt-5-nano               # OpenAI GPT-5 Nano
gpt-5-chat               # OpenAI GPT-5 Chat
claude-3-5-sonnet        # Anthropic Claude 3.5 Sonnet
claude-3-5-haiku         # Anthropic Claude 3.5 Haiku
```

### **🧠 Reasoning Models**
```
o1-preview               # OpenAI o1 Preview (Advanced reasoning)
o1-mini                  # OpenAI o1 Mini (Fast reasoning)
o3                       # OpenAI o3 (Latest reasoning)
o3-mini                  # OpenAI o3 Mini
o4-mini                  # OpenAI o4 Mini
deepseek-r1              # DeepSeek R1 (Reasoning)
deepseek-r1-0528         # DeepSeek R1 Stable
mai-ds-r1                # MAI DeepSeek R1
```

### **🚀 Ultra-Fast Models**
```
grok-3                   # xAI Grok 3 (Elon Musk's AI)
grok-3-mini              # xAI Grok 3 Mini
llama-3.1-8b-instruct    # Meta Llama 3.1 8B
llama-3.1-70b-instruct   # Meta Llama 3.1 70B
llama-3.2-1b-instruct    # Meta Llama 3.2 1B
llama-3.2-3b-instruct    # Meta Llama 3.2 3B
```

### **🎯 Specialized Models**
```
phi-3-mini-instruct      # Microsoft Phi-3 Mini
phi-3-medium-instruct    # Microsoft Phi-3 Medium
phi-4                    # Microsoft Phi-4 (Latest)
cohere-command-r         # Cohere Command R
cohere-command-r-plus    # Cohere Command R+
mistral-large            # Mistral Large
mistral-nemo             # Mistral Nemo
```

### **📝 Embedding Models**
```
text-embedding-3-small   # OpenAI Embeddings Small
text-embedding-3-large   # OpenAI Embeddings Large
cohere-embed-v3          # Cohere Embed v3
```

## 📊 **Usage Monitoring & Analytics**

### **1. GitHub Web Interface**
- Go to: https://github.com/settings/copilot
- View **Usage Statistics**
- Monitor **Rate Limits**
- Track **Daily/Monthly Usage**

### **2. API Response Headers**
Every API response includes usage info:
```json
{
  "usage": {
    "prompt_tokens": 50,
    "completion_tokens": 100,
    "total_tokens": 150
  },
  "x-ratelimit-limit-requests": "15",
  "x-ratelimit-remaining-requests": "14",
  "x-ratelimit-reset-requests": "60s"
}
```

### **3. Built-in Usage Tracker**
I'll create a usage monitoring script for you!

## 🔧 **Setup for All Models**

### **Prerequisites:**
1. **GitHub Student Pack** (FREE) → https://education.github.com
2. **Copilot Free** (included with Student Pack)
3. **Personal Access Token** with `models:read` permission

### **Model Discovery Script:**
```python
# Discover all available models
import requests
import os

headers = {"Authorization": f"Bearer {os.getenv('GITHUB_TOKEN')}"}
response = requests.get("https://api.github.com/models", headers=headers)
models = response.json()

for model in models:
    print(f"✅ {model['name']} - {model['description']}")
```

## 🎯 **Best Models for Different Tasks**

### **💬 General Chat**
1. `gpt-4o-mini` - Fast, efficient
2. `claude-3-5-haiku` - Creative responses
3. `llama-3.1-8b-instruct` - Open source

### **🧠 Complex Reasoning**
1. `o3` - Latest OpenAI reasoning
2. `deepseek-r1` - Advanced reasoning
3. `grok-3` - Elon's latest AI

### **⚡ Speed Focused**
1. `gpt-5-nano` - Ultra fast
2. `phi-4` - Microsoft's fastest
3. `llama-3.2-1b-instruct` - Lightweight

### **🎨 Creative Writing**
1. `claude-3-5-sonnet` - Best for creative tasks
2. `gpt-5` - Latest capabilities
3. `grok-3` - Unique perspective

## 📈 **Usage Optimization Tips**

### **Maximize Free Usage:**
1. **Use model tiers strategically**:
   - Low tier: 150 requests/day
   - High tier: 50 requests/day
   - Premium: 8-12 requests/day

2. **Batch requests efficiently**
3. **Use shorter prompts when possible**
4. **Monitor rate limits in real-time**

### **Student Benefits:**
- ✅ **All models FREE** with Copilot Free
- 🎓 **No credit card required**
- 🚀 **Access to latest models**
- 📚 **Perfect for learning projects**

## 🛠️ **Next Steps:**
1. **Test model discovery**: `python discover_models.py`
2. **Setup usage monitoring**: `python usage_monitor.py`
3. **Try premium models**: o3, GPT-5, DeepSeek-R1
4. **Build your AI applications**!

---
**With GitHub Student Pack, you get FREE access to $100K+ worth of AI models! 🎉**