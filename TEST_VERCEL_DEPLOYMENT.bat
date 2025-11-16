@echo off
title Test Vercel Cloud Deployment
color 0B
cls

echo ================================================================
echo               TEST VERCEL CLOUD DEPLOYMENT
echo ================================================================
echo.

set CLOUD_URL=https://api.ajstudioz.dev/api/chat
set LOCAL_URL=http://localhost:3001/api/chat
set API_KEY=aj-demo123456789abcdef

echo 🌐 Testing Vercel deployment with new cloud models...
echo.

echo ----------------------------------------------------------------
echo [1/5] Testing Vercel Health Check
echo ----------------------------------------------------------------
echo Testing: https://api.ajstudioz.dev/health
curl -s "https://api.ajstudioz.dev/health"
echo.
echo.

echo ----------------------------------------------------------------
echo [2/5] Testing Kimi K2 Instruct (Vercel Cloud)
echo ---------------------------------------------------------------- 
curl -X POST "%VERCEL_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"kimi\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello Kimi! Testing Vercel deployment\"}]}"

echo.
echo.

echo ----------------------------------------------------------------
echo [3/5] Testing Qwen 3 32B (Vercel Cloud)
echo ----------------------------------------------------------------
curl -X POST "%VERCEL_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"qwen3\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello Qwen 3 32B! Testing cloud deployment\"}]}"

echo.
echo.

echo ----------------------------------------------------------------
echo [4/5] Testing Llama 4 Maverick (Vercel Cloud)  
echo ----------------------------------------------------------------
curl -X POST "%VERCEL_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"llama-4\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello Llama 4! Testing 128K context\"}]}"

echo.
echo.

echo ----------------------------------------------------------------
echo [5/5] Testing GPT OSS 20B (Vercel Cloud)
echo ----------------------------------------------------------------
curl -X POST "%VERCEL_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"gpt-oss\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello GPT OSS! Testing open source model\"}]}"

echo.
echo.

echo ================================================================
echo                   DEPLOYMENT TEST RESULTS
echo ================================================================
echo.

echo 💡 What to check in the responses:
echo.
echo ✅ SUCCESS INDICATORS:
echo   • JSON response with "response" field
echo   • "deployment": "vercel_cloud" in metadata
echo   • "always_online": true in metadata  
echo   • "groq_keys_available": 5 in metadata
echo   • Fast response times (^<1 second)
echo.

echo ❌ ERROR INDICATORS:
echo   • HTTP 530 errors = Deployment needs update
echo   • HTTP 500 errors = Missing Groq API keys
echo   • HTTP 404 errors = Routing issues
echo   • Timeout errors = Network/DNS issues
echo.

echo 🔧 TROUBLESHOOTING:
echo.
echo If you see errors:
echo   1. Verify Groq API keys in Vercel environment variables
echo   2. Redeploy to Vercel with latest code changes
echo   3. Check Vercel function logs in dashboard
echo   4. Verify domain DNS settings in Cloudflare
echo.

echo 🚀 NEXT STEPS IF WORKING:
echo   • All 4 cloud models available 24/7
echo   • Multi-key rate limit protection active
echo   • Global fast responses via Vercel edge
echo   • No local startup needed for cloud models
echo.

pause