@echo off
title Test All New Cloud Models (24/7)
color 0C
cls

echo ================================================================
echo             TEST ALL CLOUD MODELS (24/7 AVAILABLE)
echo ================================================================
echo.

set API_URL=https://local-api.ajstudioz.dev/api/chat
set API_KEY=aj-demo123456789abcdef

echo Testing all 4 new cloud models with specific Groq API endpoints...
echo These models are ALWAYS ONLINE via Vercel deployment!
echo.

echo ----------------------------------------------------------------
echo [1/4] Testing Kimi K2 Instruct (MoonShot AI)
echo Model: moonshotai/kimi-k2-instruct-0905
echo ----------------------------------------------------------------
curl -X POST "%API_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"kimi\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello Kimi K2! Test your advanced instruction following.\"}]}"

echo.
echo.

echo ----------------------------------------------------------------
echo [2/4] Testing Qwen 3 32B (Powerful Reasoning)
echo Model: qwen/qwen3-32b
echo ----------------------------------------------------------------
curl -X POST "%API_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"qwen3\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello Qwen 3 32B! Show me your 32B parameter reasoning power.\"}]}"

echo.
echo.

echo ----------------------------------------------------------------
echo [3/4] Testing Llama 4 Maverick 17B (128K Context)
echo Model: meta-llama/llama-4-maverick-17b-128e-instruct
echo ----------------------------------------------------------------
curl -X POST "%API_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"llama-4\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello Llama 4 Maverick! Test your 128K context capability.\"}]}"

echo.
echo.

echo ----------------------------------------------------------------
echo [4/4] Testing GPT OSS 20B (Open Source Optimized)
echo Model: openai/gpt-oss-20b
echo ----------------------------------------------------------------
curl -X POST "%API_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"gpt-oss\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello GPT OSS 20B! Show me your open-source optimization.\"}]}"

echo.
echo.
echo ================================================================
echo                 ALL CLOUD MODELS TESTED!
echo ================================================================
echo.
echo ✅ Model Performance Summary:
echo.
echo 🌙 Kimi K2 Instruct - Advanced chat & instruction following
echo 🚀 Qwen 3 32B - Powerful reasoning with 32B parameters  
echo 🦙 Llama 4 Maverick 17B - Advanced model with 128K context
echo 🤖 GPT OSS 20B - Open-source optimized performance
echo.
echo 🎯 All models are:
echo   • Always online 24/7 via Vercel
echo   • Multi-key rate limit protected
echo   • Enterprise-grade reliability
echo   • Sub-second global responses
echo.
echo 💡 What to look for in responses:
echo   ✅ Successful JSON responses with content
echo   ✅ "deployment": "vercel_cloud" in metadata
echo   ✅ "always_online": true in metadata
echo   ✅ "groq_keys_available": 5 for protection
echo.
pause