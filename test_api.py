#!/usr/bin/env python3
"""
AJStudioz API Platform - Test Suite
Test your API endpoints once DNS is configured
"""

import requests
import json
from typing import Dict, Any

# Configuration
API_BASE_URL = "https://api.ajstudioz.dev/api"
MAIN_URL = "https://ajstudioz.dev"
API_KEY = "ak-demo123456789"

def test_api_endpoint(endpoint: str, method: str = "GET", data: Dict = None) -> Dict[str, Any]:
    """Test an API endpoint and return results"""
    headers = {
        "Content-Type": "application/json",
        "X-API-Key": API_KEY
    }
    
    url = f"{API_BASE_URL}/{endpoint}"
    
    try:
        if method == "GET":
            response = requests.get(url, headers=headers, timeout=10)
        elif method == "POST":
            response = requests.post(url, headers=headers, json=data, timeout=30)
        
        return {
            "status": "success",
            "status_code": response.status_code,
            "headers": dict(response.headers),
            "data": response.json() if response.headers.get('content-type', '').startswith('application/json') else response.text
        }
    except Exception as e:
        return {
            "status": "error",
            "error": str(e)
        }

def main():
    """Run comprehensive API tests"""
    print("🚀 AJStudioz AI Platform - API Test Suite")
    print("=" * 50)
    
    # Test 1: Health Check
    print("\n1. Testing API Health...")
    result = test_api_endpoint("dashboard", "GET")
    print(f"   Status: {result['status']}")
    if result['status'] == 'success':
        print(f"   Response Code: {result['status_code']}")
        print(f"   Domain Type: {result['headers'].get('X-Domain-Type', 'unknown')}")
    
    # Test 2: Models List
    print("\n2. Testing Models Endpoint...")
    result = test_api_endpoint("models", "GET")
    print(f"   Status: {result['status']}")
    if result['status'] == 'success' and result['status_code'] == 200:
        models = result['data'].get('data', [])
        print(f"   Available Models: {len(models)}")
        for model in models:
            print(f"     - {model.get('id', 'unknown')}")
    
    # Test 3: Chat Completion - GLM-4.6
    print("\n3. Testing Chat Completion (GLM-4.6)...")
    chat_data = {
        "model": "glm-4.6",
        "messages": [
            {"role": "user", "content": "Hello! What model are you?"}
        ],
        "max_tokens": 100
    }
    result = test_api_endpoint("chat", "POST", chat_data)
    print(f"   Status: {result['status']}")
    if result['status'] == 'success' and result['status_code'] == 200:
        response_text = result['data']['choices'][0]['message']['content']
        print(f"   Response: {response_text[:100]}...")
        print(f"   Usage: {result['data'].get('usage', {})}")
    
    # Test 4: Chat Completion - DeepSeek-R1
    print("\n4. Testing Chat Completion (DeepSeek-R1)...")
    chat_data = {
        "model": "deepseek-r1:1.5b",
        "messages": [
            {"role": "user", "content": "Explain AI in one sentence."}
        ],
        "max_tokens": 50
    }
    result = test_api_endpoint("chat", "POST", chat_data)
    print(f"   Status: {result['status']}")
    if result['status'] == 'success' and result['status_code'] == 200:
        response_text = result['data']['choices'][0]['message']['content']
        print(f"   Response: {response_text[:100]}...")
    
    # Test 5: Main Website
    print("\n5. Testing Main Website...")
    try:
        response = requests.get(MAIN_URL, timeout=10)
        print(f"   Status: success")
        print(f"   Response Code: {response.status_code}")
        print(f"   Content-Type: {response.headers.get('content-type', 'unknown')}")
        print(f"   Domain Type: {response.headers.get('X-Main-Domain', 'unknown')}")
    except Exception as e:
        print(f"   Status: error - {str(e)}")
    
    print("\n" + "=" * 50)
    print("✅ Test Suite Complete!")
    print("\nIf all tests pass, your AJStudioz AI Platform is working correctly!")
    print("Use these endpoints in your applications:")
    print(f"  • API Base URL: {API_BASE_URL}")
    print(f"  • Main Website: {MAIN_URL}")
    print(f"  • API Key: {API_KEY}")

if __name__ == "__main__":
    main()
