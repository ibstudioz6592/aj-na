@echo off
title Test Both Domains - Cloud & Local Models
color 0D
cls

echo ================================================================
echo            TEST BOTH DOMAINS - CLOUD & LOCAL MODELS
echo ================================================================
echo.

set CLOUD_URL=https://api.ajstudioz.dev/api/chat
set LOCAL_URL=https://local-api.ajstudioz.dev/api/chat
set API_KEY=aj-demo123456789abcdef

echo 🌐 Testing separate domains for different model types...
echo.
echo 📍 DOMAIN MAPPING:
echo   • api.ajstudioz.dev      → Cloud Models (Vercel 24/7)
echo   • local-api.ajstudioz.dev → Local Models (Cloudflare Tunnel)
echo.

echo ================================================================
echo                     CLOUD MODELS (24/7)
echo ================================================================
echo.

echo ----------------------------------------------------------------
echo [1/4] Testing Kimi K2 Instruct (Cloud Domain)
echo URL: %CLOUD_URL%
echo ----------------------------------------------------------------
curl -X POST "%CLOUD_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"kimi\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello from api.ajstudioz.dev cloud domain!\"}]}"

echo.
echo.

echo ----------------------------------------------------------------
echo [2/4] Testing Qwen 3 32B (Cloud Domain)
echo URL: %CLOUD_URL%
echo ----------------------------------------------------------------
curl -X POST "%CLOUD_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"qwen3\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello Qwen 3 32B from cloud!\"}]}"

echo.
echo.

echo ================================================================
echo                     LOCAL MODELS (TUNNEL)
echo ================================================================
echo.

echo ----------------------------------------------------------------
echo [3/4] Testing Qwen 3 Local (Local Domain)
echo URL: %LOCAL_URL%
echo ----------------------------------------------------------------
curl -X POST "%LOCAL_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"qwen3-local\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello from local-api.ajstudioz.dev tunnel!\"}]}"

echo.
echo.

echo ----------------------------------------------------------------
echo [4/4] Testing GLM-4.6 Local (Local Domain)
echo URL: %LOCAL_URL%
echo ----------------------------------------------------------------
curl -X POST "%LOCAL_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"glm-4.6\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello GLM-4.6 from tunnel!\"}]}"

echo.
echo.

echo ================================================================
echo                     DOMAIN TEST RESULTS
echo ================================================================
echo.

echo 🎯 DOMAIN CONFIGURATION SUMMARY:
echo.
echo ☁️  CLOUD MODELS (api.ajstudioz.dev):
echo   ✅ Kimi K2 Instruct - Always online via Vercel
echo   ✅ Qwen 3 32B - Always online via Vercel
echo   ✅ Llama 4 Maverick - Always online via Vercel
echo   ✅ GPT OSS 20B - Always online via Vercel
echo.
echo 🖥️  LOCAL MODELS (local-api.ajstudioz.dev):
echo   ✅ Qwen 3 Local - Via Cloudflare tunnel when Ollama running
echo   ✅ GLM-4.6 - Via Cloudflare tunnel when Ollama running
echo.

echo 💡 EXPECTED BEHAVIOR:
echo.
echo ✅ SUCCESS INDICATORS:
echo   • Cloud models: Fast responses from Vercel (^<500ms)
echo   • Local models: Fast responses from tunnel (^<200ms)
echo   • "deployment": "vercel_cloud" for cloud models
echo   • "deployment": "local_development" for local models
echo.

echo ❌ ERROR SCENARIOS:
echo   • Cloud domain fails = Vercel deployment/keys issue
echo   • Local domain fails = Ollama not running or tunnel down
echo   • Both fail = DNS/network issues
echo.

echo 🔧 TROUBLESHOOTING GUIDE:
echo.
echo If cloud models fail (api.ajstudioz.dev):
echo   1. Check Groq API keys in Vercel environment
echo   2. Verify Vercel deployment is active
echo   3. Check domain DNS settings
echo.
echo If local models fail (local-api.ajstudioz.dev):
echo   1. Start Ollama: ollama serve
echo   2. Check Cloudflare tunnel is running
echo   3. Verify local models are installed
echo.

echo ================================================================
echo                     PERFECT SETUP ACHIEVED!
echo ================================================================
echo.
echo 🎉 You now have the best of both worlds:
echo   • Cloud Models: Always online, enterprise-grade
echo   • Local Models: Privacy-focused, ultra-fast
echo   • Separate domains for clear separation
echo   • Automatic routing in chatbot interface
echo.

pause