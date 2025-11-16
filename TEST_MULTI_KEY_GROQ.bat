@echo off
title Test Multi-Key Groq System
color 0E
cls

echo ================================================================
echo              MULTI-KEY GROQ API TEST
echo ================================================================
echo.

set API_URL=https://local-api.ajstudioz.dev/api/chat
set API_KEY=aj-demo123456789abcdef

echo Testing Groq cloud models with multi-key rotation system...
echo This will test rate limit handling and key rotation.
echo.

echo ----------------------------------------------------------------
echo [1/5] Testing Kimi (Groq) - First Request
echo ----------------------------------------------------------------
curl -X POST "%API_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"kimi\", \"messages\": [{\"role\": \"user\", \"content\": \"Test 1: Hello from multi-key system\"}]}"

echo.
echo.

echo ----------------------------------------------------------------
echo [2/5] Testing Llama 70B (Groq) - Second Request  
echo ----------------------------------------------------------------
curl -X POST "%API_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"llama-70b\", \"messages\": [{\"role\": \"user\", \"content\": \"Test 2: Rate limit protection working?\"}]}"

echo.
echo.

echo ----------------------------------------------------------------
echo [3/5] Testing Mixtral (Groq) - Third Request
echo ----------------------------------------------------------------
curl -X POST "%API_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"mixtral\", \"messages\": [{\"role\": \"user\", \"content\": \"Test 3: Multi-key rotation test\"}]}"

echo.
echo.

echo ----------------------------------------------------------------
echo [4/5] Rapid Fire Test - Kimi (Tests Key Rotation)
echo ----------------------------------------------------------------
curl -X POST "%API_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"kimi\", \"messages\": [{\"role\": \"user\", \"content\": \"Rapid test 1\"}]}"

echo.

curl -X POST "%API_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"kimi\", \"messages\": [{\"role\": \"user\", \"content\": \"Rapid test 2\"}]}"

echo.
echo.

echo ----------------------------------------------------------------
echo [5/5] Final Test - All Models Quick Check
echo ----------------------------------------------------------------
echo Testing local model for comparison:
curl -X POST "%API_URL%" ^
  -H "Content-Type: application/json" ^  
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"qwen3\", \"messages\": [{\"role\": \"user\", \"content\": \"Local model test\"}]}"

echo.
echo.
echo ================================================================
echo                  MULTI-KEY TEST COMPLETE
echo ================================================================
echo.
echo What to look for in the output:
echo  ✅ "Trying Groq API key X/Y" - Shows key rotation
echo  ✅ "Groq API success with key X" - Confirms which key worked  
echo  ✅ "groq_keys_available": N - Shows how many keys loaded
echo  ✅ "rate_limit_protection": true - Confirms multi-key protection
echo.
echo If you see rate limit errors, add more API keys to .env file!
echo.
pause