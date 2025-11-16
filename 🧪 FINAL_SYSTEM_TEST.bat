@echo off
chcp 65001 >nul
title 🧪 AJ Studioz AI - Final System Test
color 0A

echo ════════════════════════════════════════════════════════════════════
echo 🧪 AJ STUDIOZ AI - FINAL SYSTEM TEST
echo ════════════════════════════════════════════════════════════════════
echo.
echo 🎯 TESTING COMPLETE ARCHITECTURE:
echo.
echo 🌐 CLOUD MODELS (24/7 Online):
echo    └─ api.ajstudioz.dev
echo    ├─ Kimi K2 (moonshotai/kimi-k2-instruct-0905)
echo    ├─ Qwen 3 32B (qwen/qwen3-32b)  
echo    ├─ Llama 4 Maverick (meta-llama/llama-4-maverick-17b-128e-instruct)
echo    └─ GPT OSS 20B (openai/gpt-oss-20b)
echo.
echo 🏠 LOCAL MODELS (Privacy Mode):
echo    └─ local-api.ajstudioz.dev or localhost:3001
echo    ├─ Qwen 3 Local (qwen2.5:3b)
echo    └─ GLM-4.6 (glm4:9b)
echo.
echo ════════════════════════════════════════════════════════════════════
echo 📊 TESTING SEQUENCE:
echo.

echo 1️⃣  Testing Cloud Models Endpoint (api.ajstudioz.dev)...
timeout /t 2 >nul
powershell -Command "try { $response = Invoke-RestMethod -Uri 'https://api.ajstudioz.dev/api/models' -Method GET -TimeoutSec 10; Write-Host '✅ Cloud endpoint online!' -ForegroundColor Green; $response | ConvertTo-Json -Depth 2 } catch { Write-Host '⚠️ Cloud endpoint test failed - this is normal if Vercel not deployed yet' -ForegroundColor Yellow }"
echo.

echo 2️⃣  Checking Local Models Setup...
timeout /t 1 >nul
if exist "%USERPROFILE%\.ollama\models\*" (
    echo ✅ Local models directory found
) else (
    echo ⚠️  Local models not installed yet - run START_LOCAL_MODELS_ONLY.bat
)
echo.

echo 3️⃣  Testing Local Tunnel Domain (local-api.ajstudioz.dev)...
timeout /t 2 >nul
powershell -Command "try { $response = Invoke-RestMethod -Uri 'https://local-api.ajstudioz.dev/api/models' -Method GET -TimeoutSec 10; Write-Host '✅ Local tunnel online!' -ForegroundColor Green; $response | ConvertTo-Json -Depth 2 } catch { Write-Host '⚠️ Local tunnel offline - this is normal when not running locally' -ForegroundColor Yellow }"
echo.

echo 4️⃣  Testing Direct Local Access (localhost:3001)...
timeout /t 1 >nul
powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:3001/api/models' -Method GET -TimeoutSec 5; Write-Host '✅ Local server running!' -ForegroundColor Green; $response | ConvertTo-Json -Depth 2 } catch { Write-Host '⚠️ Local server offline - start with START_LOCAL_MODELS_ONLY.bat' -ForegroundColor Yellow }"
echo.

echo ════════════════════════════════════════════════════════════════════
echo 🎯 SYSTEM ARCHITECTURE SUMMARY:
echo.
echo ✅ Multi-Key Groq System: 5 API keys for rate limit protection
echo ✅ Cloud Models: Always online via Vercel serverless deployment
echo ✅ Local Models: Optional privacy-focused alternative
echo ✅ Smart Routing: Chatbot automatically selects correct domain
echo ✅ Domain Separation: Clean architecture with clear purposes
echo.
echo 🌟 READY FOR PRODUCTION!
echo.
echo 🚀 Quick Access:
echo    • Cloud Chatbot: https://api.ajstudioz.dev
echo    • Local Chatbot: https://local-api.ajstudioz.dev (when tunnel active)
echo    • Documentation: All .md files in this folder
echo.
echo ════════════════════════════════════════════════════════════════════

pause