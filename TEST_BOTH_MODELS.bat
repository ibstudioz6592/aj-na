@echo off
title Test AI Models - Local & Cloud
color 0B
cls

echo ================================================================
echo                    AI MODEL TESTING
echo ================================================================
echo.

set API_URL=https://local-api.ajstudioz.dev/api/chat
set API_KEY=aj-demo123456789abcdef

echo Testing both LOCAL and CLOUD models...
echo.

echo ----------------------------------------------------------------
echo [1/2] Testing LOCAL model: Qwen 3 (Local)
echo ----------------------------------------------------------------
curl -X POST "%API_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"qwen3-local\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello, test local model\"}]}"

echo.
echo.

echo ----------------------------------------------------------------
echo [2/2] Testing CLOUD model: Kimi K2 Instruct (24/7)
echo ----------------------------------------------------------------
curl -X POST "%API_URL%" ^
  -H "Content-Type: application/json" ^
  -H "X-API-Key: %API_KEY%" ^
  -d "{\"model\": \"kimi\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello, test Kimi K2 Instruct model\"}]}"

echo.
echo.
echo ================================================================
echo                    TEST COMPLETE
echo ================================================================
echo.
echo If both models responded, your setup is working perfectly!
echo.
echo Local models = Fast (requires Ollama)
echo Cloud models = Always available (requires Groq API key)
echo.
pause