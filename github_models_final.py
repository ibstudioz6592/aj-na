#!/usr/bin/env python3
"""
GitHub Models API - Working Client
Free unlimited access to GPT-4o, Claude, Llama models
"""

import requests
import json
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Your GitHub token from environment
TOKEN = os.getenv("GITHUB_TOKEN")
BASE_URL = "https://models.inference.ai.azure.com/chat/completions"

def ask_ai(question, model="gpt-4o-mini", max_tokens=500):
    """Simple AI question function"""
    if not TOKEN:
        return "Error: GITHUB_TOKEN not found in environment variables. Please set it in .env file."
    
    headers = {
        "Authorization": f"Bearer {TOKEN}",
        "Content-Type": "application/json"
    }
    
    data = {
        "model": model,
        "messages": [{"role": "user", "content": question}],
        "temperature": 0.7,
        "max_tokens": max_tokens
    }
    
    try:
        response = requests.post(BASE_URL, headers=headers, json=data)
        if response.status_code == 200:
            return response.json()["choices"][0]["message"]["content"]
        else:
            return f"Error {response.status_code}: {response.text}"
    except Exception as e:
        return f"Error: {str(e)}"

if __name__ == "__main__":
    # Test all available models
    models = ["gpt-4o-mini", "gpt-4o"]
    
    print("🚀 Testing GitHub Models API...")
    print("=" * 40)
    
    for model in models:
        print(f"\n🤖 Testing {model}:")
        result = ask_ai("What is 5+5? Answer in one word.", model)
        print(f"   Answer: {result}")
    
    print("\n✅ All tests completed!")
    print("\n📝 Usage:")
    print("   result = ask_ai('Your question here')")
    print("   result = ask_ai('Explain AI', model='gpt-4o')")