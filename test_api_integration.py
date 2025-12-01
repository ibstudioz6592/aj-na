#!/usr/bin/env python3
"""
Test GitHub Models Integration in AJ Studios AI API
"""

import requests
import json

# Test data
API_URL = "http://localhost:3000/api/chat"
API_KEY = "aj-demo123456789abcdef"  # Demo key from the API

def test_github_models():
    """Test GitHub Models integration"""
    
    headers = {
        "Content-Type": "application/json",
        "X-API-Key": API_KEY
    }
    
    # Test GPT-4o Mini
    test_cases = [
        {
            "model": "gpt-4o-mini",
            "name": "GPT-4o Mini (GitHub Student FREE)"
        },
        {
            "model": "gpt-4o", 
            "name": "GPT-4o (GitHub Student FREE)"
        }
    ]
    
    print("🧪 Testing GitHub Models Integration")
    print("=" * 50)
    
    for test_case in test_cases:
        print(f"\n🤖 Testing {test_case['name']}...")
        
        data = {
            "model": test_case["model"],
            "messages": [
                {
                    "role": "user",
                    "content": "What is 3+4? Just give the number."
                }
            ],
            "max_tokens": 20,
            "temperature": 0.7
        }
        
        try:
            response = requests.post(API_URL, headers=headers, json=data, timeout=30)
            
            if response.status_code == 200:
                result = response.json()
                
                # Extract response from the structured output
                if "output" in result and len(result["output"]) > 0:
                    message_output = None
                    for output in result["output"]:
                        if output.get("type") == "message":
                            message_output = output
                            break
                    
                    if message_output and "content" in message_output and len(message_output["content"]) > 0:
                        response_text = message_output["content"][0].get("text", "No response")
                        print(f"✅ Response: {response_text}")
                        print(f"📊 Tokens: {result.get('usage', {}).get('total_tokens', 'N/A')}")
                        print(f"⏱️  Time: {result.get('metadata', {}).get('response_time_ms', 'N/A')}ms")
                    else:
                        print("❌ No message content found in response")
                else:
                    print("❌ No output found in response")
                    
            else:
                print(f"❌ HTTP {response.status_code}: {response.text}")
                
        except requests.exceptions.ConnectionError:
            print("❌ Connection failed. Make sure the API server is running on port 3000")
        except requests.exceptions.Timeout:
            print("❌ Request timeout")
        except Exception as e:
            print(f"❌ Error: {str(e)}")
    
    print(f"\n🚀 Test completed!")
    print("\n📝 To start the API server:")
    print("   cd aj-na && npm run dev")

if __name__ == "__main__":
    test_github_models()