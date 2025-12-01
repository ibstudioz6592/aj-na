#!/usr/bin/env python3
"""
GitHub Models - Complete Model Discovery & Usage Monitor
Discover all available models and monitor your usage in real-time
"""

import requests
import json
import os
import time
from datetime import datetime
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

class GitHubModelsMonitor:
    def __init__(self):
        self.token = os.getenv("GITHUB_TOKEN")
        if not self.token:
            raise ValueError("GITHUB_TOKEN not found in environment variables")
        
        self.headers = {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json",
            "Accept": "application/vnd.github+json"
        }
        
        self.base_url = "https://models.inference.ai.azure.com"
        self.usage_log = []
    
    def discover_available_models(self):
        """Discover all available models on GitHub"""
        print("🔍 Discovering available GitHub Models...")
        print("=" * 60)
        
        # Test known models to see which ones work
        known_models = [
            # OpenAI Models
            {"name": "gpt-4o", "provider": "OpenAI", "type": "High"},
            {"name": "gpt-4o-mini", "provider": "OpenAI", "type": "Low"},
            {"name": "gpt-5", "provider": "OpenAI", "type": "High"},
            {"name": "gpt-5-mini", "provider": "OpenAI", "type": "Low"},
            {"name": "gpt-5-nano", "provider": "OpenAI", "type": "Low"},
            {"name": "o1-preview", "provider": "OpenAI", "type": "Premium"},
            {"name": "o1-mini", "provider": "OpenAI", "type": "Premium"},
            {"name": "o3", "provider": "OpenAI", "type": "Premium"},
            {"name": "o3-mini", "provider": "OpenAI", "type": "Premium"},
            
            # Anthropic Models
            {"name": "claude-3-5-sonnet", "provider": "Anthropic", "type": "High"},
            {"name": "claude-3-5-haiku", "provider": "Anthropic", "type": "Low"},
            
            # Meta Models
            {"name": "llama-3.1-8b-instruct", "provider": "Meta", "type": "Low"},
            {"name": "llama-3.1-70b-instruct", "provider": "Meta", "type": "High"},
            {"name": "llama-3.2-1b-instruct", "provider": "Meta", "type": "Low"},
            {"name": "llama-3.2-3b-instruct", "provider": "Meta", "type": "Low"},
            
            # xAI Models
            {"name": "grok-3", "provider": "xAI", "type": "Premium"},
            {"name": "grok-3-mini", "provider": "xAI", "type": "High"},
            
            # Microsoft Models
            {"name": "phi-3-mini-instruct", "provider": "Microsoft", "type": "Low"},
            {"name": "phi-3-medium-instruct", "provider": "Microsoft", "type": "Low"},
            {"name": "phi-4", "provider": "Microsoft", "type": "High"},
            
            # DeepSeek Models
            {"name": "deepseek-r1", "provider": "DeepSeek", "type": "Premium"},
            {"name": "deepseek-r1-0528", "provider": "DeepSeek", "type": "Premium"},
            
            # Cohere Models
            {"name": "cohere-command-r", "provider": "Cohere", "type": "High"},
            {"name": "cohere-command-r-plus", "provider": "Cohere", "type": "High"},
            
            # Mistral Models
            {"name": "mistral-large", "provider": "Mistral", "type": "High"},
            {"name": "mistral-nemo", "provider": "Mistral", "type": "Low"},
        ]
        
        available_models = []
        
        for model_info in known_models:
            if self.test_model_availability(model_info["name"]):
                available_models.append(model_info)
                status = "✅ Available"
                color = "\033[92m"  # Green
            else:
                status = "❌ Not Available"
                color = "\033[91m"  # Red
            
            print(f"{color}{status:<15}\033[0m {model_info['name']:<25} {model_info['provider']:<12} [{model_info['type']}]")
        
        print(f"\n📊 Summary: {len(available_models)}/{len(known_models)} models available")
        return available_models
    
    def test_model_availability(self, model_name):
        """Test if a model is available by making a small request"""
        try:
            data = {
                "model": model_name,
                "messages": [{"role": "user", "content": "Hi"}],
                "max_tokens": 1
            }
            
            response = requests.post(
                f"{self.base_url}/chat/completions",
                headers=self.headers,
                json=data,
                timeout=10
            )
            
            return response.status_code == 200
            
        except Exception:
            return False
    
    def get_usage_stats(self, model_name="gpt-4o-mini"):
        """Get detailed usage statistics for a model"""
        try:
            data = {
                "model": model_name,
                "messages": [{"role": "user", "content": "Return usage info"}],
                "max_tokens": 10
            }
            
            response = requests.post(
                f"{self.base_url}/chat/completions",
                headers=self.headers,
                json=data,
                timeout=30
            )
            
            if response.status_code == 200:
                result = response.json()
                usage = result.get("usage", {})
                
                # Extract rate limit info from headers
                rate_limits = {
                    "requests_remaining": response.headers.get("x-ratelimit-remaining-requests", "Unknown"),
                    "requests_limit": response.headers.get("x-ratelimit-limit-requests", "Unknown"),
                    "tokens_remaining": response.headers.get("x-ratelimit-remaining-tokens", "Unknown"),
                    "reset_time": response.headers.get("x-ratelimit-reset-requests", "Unknown")
                }
                
                usage_info = {
                    "timestamp": datetime.now().isoformat(),
                    "model": model_name,
                    "tokens_used": usage.get("total_tokens", 0),
                    "prompt_tokens": usage.get("prompt_tokens", 0),
                    "completion_tokens": usage.get("completion_tokens", 0),
                    "rate_limits": rate_limits,
                    "status": "success"
                }
                
                self.usage_log.append(usage_info)
                return usage_info
            else:
                return {
                    "timestamp": datetime.now().isoformat(),
                    "model": model_name,
                    "status": "error",
                    "error": f"HTTP {response.status_code}: {response.text}"
                }
                
        except Exception as e:
            return {
                "timestamp": datetime.now().isoformat(),
                "model": model_name,
                "status": "error",
                "error": str(e)
            }
    
    def monitor_usage_realtime(self, models=None, interval=60):
        """Monitor usage for multiple models in real-time"""
        if models is None:
            models = ["gpt-4o-mini", "gpt-4o", "claude-3-5-haiku"]
        
        print(f"📊 Starting real-time usage monitoring for: {', '.join(models)}")
        print(f"⏱️  Checking every {interval} seconds. Press Ctrl+C to stop.")
        print("=" * 80)
        
        try:
            while True:
                print(f"\n🕐 {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
                print("-" * 50)
                
                for model in models:
                    usage = self.get_usage_stats(model)
                    
                    if usage["status"] == "success":
                        print(f"✅ {model:<20} | Tokens: {usage['tokens_used']:<3} | "
                              f"Requests Left: {usage['rate_limits']['requests_remaining']}")
                    else:
                        print(f"❌ {model:<20} | Error: {usage.get('error', 'Unknown')}")
                
                time.sleep(interval)
                
        except KeyboardInterrupt:
            print("\n\n🛑 Monitoring stopped by user")
            self.save_usage_log()
    
    def test_premium_models(self):
        """Test premium models with reasoning capabilities"""
        premium_models = [
            "o3", "o1-preview", "deepseek-r1", 
            "grok-3", "gpt-5"
        ]
        
        print("🧠 Testing Premium Reasoning Models...")
        print("=" * 50)
        
        test_prompt = "What is 2+2? Think step by step."
        
        for model in premium_models:
            print(f"\n🤖 Testing {model}...")
            
            try:
                data = {
                    "model": model,
                    "messages": [{"role": "user", "content": test_prompt}],
                    "max_tokens": 100,
                    "temperature": 0.7
                }
                
                response = requests.post(
                    f"{self.base_url}/chat/completions",
                    headers=self.headers,
                    json=data,
                    timeout=60
                )
                
                if response.status_code == 200:
                    result = response.json()
                    content = result["choices"][0]["message"]["content"]
                    tokens = result.get("usage", {}).get("total_tokens", 0)
                    
                    print(f"✅ Success! Tokens used: {tokens}")
                    print(f"📝 Response: {content[:100]}...")
                else:
                    print(f"❌ Error {response.status_code}: {response.text}")
                    
            except Exception as e:
                print(f"❌ Exception: {str(e)}")
    
    def save_usage_log(self):
        """Save usage log to file"""
        filename = f"github_models_usage_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        
        with open(filename, 'w') as f:
            json.dump(self.usage_log, f, indent=2)
        
        print(f"💾 Usage log saved to: {filename}")
    
    def show_rate_limits_info(self):
        """Show current rate limits based on Copilot plan"""
        print("📋 GitHub Models Rate Limits (December 2025)")
        print("=" * 60)
        
        plans = {
            "Copilot Free": {
                "Low Models": "15 RPM, 150 RPD, 8K in/4K out",
                "High Models": "10 RPM, 50 RPD, 8K in/4K out", 
                "Premium Models": "1-2 RPM, 8-12 RPD, 4K in/4K out"
            },
            "Copilot Pro": {
                "Low Models": "15 RPM, 150 RPD, 8K in/4K out",
                "High Models": "10 RPM, 50 RPD, 8K in/4K out",
                "Premium Models": "1-2 RPM, 8-12 RPD, 4K in/4K out"
            }
        }
        
        for plan, limits in plans.items():
            print(f"\n🎯 {plan}:")
            for tier, limit in limits.items():
                print(f"   {tier}: {limit}")

def main():
    """Main function with interactive menu"""
    try:
        monitor = GitHubModelsMonitor()
        
        while True:
            print("\n🚀 GitHub Models Monitor & Discovery Tool")
            print("=" * 50)
            print("1. 🔍 Discover Available Models")
            print("2. 📊 Check Usage Stats")
            print("3. 📈 Monitor Usage (Real-time)")
            print("4. 🧠 Test Premium Models")
            print("5. 📋 Show Rate Limits Info")
            print("6. 💾 Save Usage Log")
            print("0. ❌ Exit")
            
            choice = input("\nChoose option (0-6): ").strip()
            
            if choice == "1":
                monitor.discover_available_models()
            elif choice == "2":
                model = input("Enter model name (default: gpt-4o-mini): ").strip() or "gpt-4o-mini"
                usage = monitor.get_usage_stats(model)
                print(f"\n📊 Usage Stats for {model}:")
                print(json.dumps(usage, indent=2))
            elif choice == "3":
                models = input("Enter models to monitor (comma-separated, default: gpt-4o-mini,gpt-4o): ").strip()
                if models:
                    models = [m.strip() for m in models.split(",")]
                else:
                    models = ["gpt-4o-mini", "gpt-4o"]
                monitor.monitor_usage_realtime(models)
            elif choice == "4":
                monitor.test_premium_models()
            elif choice == "5":
                monitor.show_rate_limits_info()
            elif choice == "6":
                monitor.save_usage_log()
            elif choice == "0":
                print("👋 Goodbye!")
                break
            else:
                print("❌ Invalid choice. Please try again.")
    
    except ValueError as e:
        print(f"❌ Configuration Error: {e}")
        print("💡 Make sure GITHUB_TOKEN is set in your .env file")
    except KeyboardInterrupt:
        print("\n👋 Goodbye!")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")

if __name__ == "__main__":
    main()