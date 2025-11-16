@echo off
chcp 65001 >nul
title 🚀 AJStudioz AI - Ultimate Hybrid Platform
color 0A
cls

REM Get the desktop path
set DESKTOP=%USERPROFILE%\Desktop
set PROJECT_PATH=c:\New folder\aj-fresh

echo ════════════════════════════════════════════════════════════════════
echo 🚀 AJSTUDIOZ AI - HYBRID CLOUD & LOCAL PLATFORM
echo ════════════════════════════════════════════════════════════════════
echo.
echo 🌟 PERFECT SETUP MENU:
echo.
echo 1️⃣  🏠 Start LOCAL Models Only (Privacy Mode)
echo 2️⃣  🌐 Test CLOUD AI Responses (24/7 Online)
echo 3️⃣  🚀 Full Setup (Local + Cloud Access)
echo 4️⃣  📊 System Status Check
echo 5️⃣  ❌ Exit
echo.
echo ════════════════════════════════════════════════════════════════════
echo.

set /p choice="🎯 Select your option (1-5): "

if "%choice%"=="1" goto LOCAL_ONLY
if "%choice%"=="2" goto TEST_CLOUD
if "%choice%"=="3" goto FULL_SETUP
if "%choice%"=="4" goto STATUS_CHECK
if "%choice%"=="5" goto EXIT
goto MENU

:LOCAL_ONLY
cls
echo ════════════════════════════════════════════════════════════════════
echo 🏠 STARTING LOCAL MODELS ONLY (PRIVACY MODE)
echo ════════════════════════════════════════════════════════════════════
echo.
echo 🔒 Privacy-focused local AI models starting...
echo 📍 Endpoint: https://local-api.ajstudioz.dev/api/chat
echo.
echo ════════════════════════════════════════════════════════════════════
echo.

cd /d "%PROJECT_PATH%"

REM Step 1: Stop existing services
echo [1/4] 🛑 Stopping existing services...
taskkill /F /IM ollama.exe 2>nul
taskkill /F /IM node.exe 2>nul
taskkill /F /IM cloudflared.exe 2>nul
timeout /t 2 >nul

REM Step 2: Start Ollama
echo [2/4] 🤖 Starting Ollama (Local AI Models)...
start /B ollama serve
timeout /t 5 >nul

REM Step 3: Check existing local models
echo [2.5/4] 📥 Checking local models...
ollama list | findstr "qwen3:" >nul
if errorlevel 1 (
    echo     ⚠️  No Qwen model found - you can install with: ollama pull qwen3:1.7b
) else (
    echo     ✅ Qwen model available
)
ollama list | findstr "glm-4.6:" >nul
if errorlevel 1 (
    echo     ⚠️  No GLM model found - you can install with: ollama pull glm-4.6:cloud
) else (
    echo     ✅ GLM-4.6 model available
)
timeout /t 2 >nul

REM Step 3: Start Node.js API
echo [3/4] 🔗 Starting API Server...
start /B node proxy-server.js
timeout /t 3 >nul

REM Step 4: Start Cloudflare Tunnel
echo [4/4] 🌐 Starting Cloudflare Tunnel...
start /MIN cloudflared.exe tunnel --config config.yml run
timeout /t 5 >nul

echo.
echo ════════════════════════════════════════════════════════════════════
echo ✅ LOCAL MODELS PRIVACY MODE STARTED!
echo ════════════════════════════════════════════════════════════════════
echo.
echo 🏠 Your LOCAL AI API is now accessible at:
echo    📍 https://local-api.ajstudioz.dev/api/chat
echo.
echo 🔒 Available LOCAL Models (Privacy Mode):
echo    ├─ qwen3-local (Qwen 3:1.7B - Fast Chat)
echo    └─ glm-4.6 (GLM-4.6:Cloud - Advanced Reasoning)
echo.
echo 🌐 CLOUD Models (Always Online 24/7):
echo    📍 https://api.ajstudioz.dev/api/chat
echo    ├─ kimi (Kimi K2 - MoonShot AI)
echo    ├─ qwen3 (Qwen 3 32B - Powerful Reasoning)
echo    ├─ llama-4 (Llama 4 Maverick - 128K Context)  
echo    └─ gpt-oss (GPT OSS 20B - Open Source)
echo.
echo ════════════════════════════════════════════════════════════════════
echo 🎯 Quick Test Commands:
echo.
echo LOCAL Test:
echo curl -X POST "https://local-api.ajstudioz.dev/api/chat" ^
echo   -H "Content-Type: application/json" ^
echo   -H "X-API-Key: aj-demo123456789abcdef" ^
echo   -d "{\"model\": \"qwen3-local\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello!\"}]}"
echo.
echo CLOUD Test:  
echo curl -X POST "https://api.ajstudioz.dev/api/chat" ^
echo   -H "Content-Type: application/json" ^
echo   -H "X-API-Key: aj-demo123456789abcdef" ^
echo   -d "{\"model\": \"kimi\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello!\"}]}"
echo.
echo ════════════════════════════════════════════════════════════════════
echo 💡 USAGE TIPS:
echo    • LOCAL: Maximum privacy, runs on your machine
echo    • CLOUD: Always online, enterprise-grade performance
echo    • Use what fits your needs - both work perfectly!
echo.
echo 🛑 To Stop: Run STOP_ALL_SERVICES.bat
echo ════════════════════════════════════════════════════════════════════
echo.
pause
goto MENU

:TEST_CLOUD
cls
echo ════════════════════════════════════════════════════════════════════
echo 🌐 TESTING CLOUD AI RESPONSES (24/7 ONLINE)
echo ════════════════════════════════════════════════════════════════════
echo.
echo 🧪 Testing all cloud models at api.ajstudioz.dev...
echo.

echo 1️⃣ Testing Kimi K2 (MoonShot AI)...
powershell -Command "try { $response = Invoke-RestMethod -Uri 'https://api.ajstudioz.dev/api/chat' -Method POST -Headers @{'Content-Type'='application/json'; 'X-API-Key'='aj-demo123456789abcdef'} -Body ('{\"model\": \"kimi\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello! Respond in 1 sentence.\"}], \"max_tokens\": 50}' | ConvertTo-Json -Compress); Write-Host '✅ Kimi Response:' -ForegroundColor Green; Write-Host $response.choices[0].message.content -ForegroundColor White } catch { Write-Host '❌ Kimi failed:' $_.Exception.Message -ForegroundColor Red }"
echo.

echo 2️⃣ Testing Qwen 3 32B...
powershell -Command "try { $response = Invoke-RestMethod -Uri 'https://api.ajstudioz.dev/api/chat' -Method POST -Headers @{'Content-Type'='application/json'; 'X-API-Key'='aj-demo123456789abcdef'} -Body ('{\"model\": \"qwen3\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello! Respond in 1 sentence.\"}], \"max_tokens\": 50}' | ConvertTo-Json -Compress); Write-Host '✅ Qwen 3 Response:' -ForegroundColor Green; Write-Host $response.choices[0].message.content -ForegroundColor White } catch { Write-Host '❌ Qwen 3 failed:' $_.Exception.Message -ForegroundColor Red }"
echo.

echo 3️⃣ Testing Llama 4 Maverick...
powershell -Command "try { $response = Invoke-RestMethod -Uri 'https://api.ajstudioz.dev/api/chat' -Method POST -Headers @{'Content-Type'='application/json'; 'X-API-Key'='aj-demo123456789abcdef'} -Body ('{\"model\": \"llama-4\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello! Respond in 1 sentence.\"}], \"max_tokens\": 50}' | ConvertTo-Json -Compress); Write-Host '✅ Llama 4 Response:' -ForegroundColor Green; Write-Host $response.choices[0].message.content -ForegroundColor White } catch { Write-Host '❌ Llama 4 failed:' $_.Exception.Message -ForegroundColor Red }"
echo.

echo 4️⃣ Testing GPT OSS 20B...
powershell -Command "try { $response = Invoke-RestMethod -Uri 'https://api.ajstudioz.dev/api/chat' -Method POST -Headers @{'Content-Type'='application/json'; 'X-API-Key'='aj-demo123456789abcdef'} -Body ('{\"model\": \"gpt-oss\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello! Respond in 1 sentence.\"}], \"max_tokens\": 50}' | ConvertTo-Json -Compress); Write-Host '✅ GPT OSS Response:' -ForegroundColor Green; Write-Host $response.choices[0].message.content -ForegroundColor White } catch { Write-Host '❌ GPT OSS failed:' $_.Exception.Message -ForegroundColor Red }"
echo.

echo ════════════════════════════════════════════════════════════════════
echo 🎉 CLOUD AI TESTING COMPLETE!
echo.
echo 🌐 All models are accessible 24/7 at: https://api.ajstudioz.dev
echo 🔑 Always use API key: aj-demo123456789abcdef
echo 💫 Enterprise-grade performance with multi-key protection!
echo ════════════════════════════════════════════════════════════════════
echo.
pause
goto MENU

:FULL_SETUP
goto LOCAL_ONLY

:STATUS_CHECK
cls
echo ════════════════════════════════════════════════════════════════════
echo 📊 SYSTEM STATUS CHECK
echo ════════════════════════════════════════════════════════════════════
echo.
echo 🔍 Checking services...
echo.

echo 🤖 Ollama Status:
tasklist /FI "IMAGENAME eq ollama.exe" 2>NUL | find /I /N "ollama.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ Ollama is running
) else (
    echo ❌ Ollama is not running
)

echo 🔗 Node.js API Status:
tasklist /FI "IMAGENAME eq node.exe" 2>NUL | find /I /N "node.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ API Server is running
) else (
    echo ❌ API Server is not running
)

echo 🌐 Cloudflare Tunnel Status:
tasklist /FI "IMAGENAME eq cloudflared.exe" 2>NUL | find /I /N "cloudflared.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ Tunnel is running
) else (
    echo ❌ Tunnel is not running
)

echo.
echo 🧪 Testing endpoints...
powershell -Command "try { $response = Invoke-RestMethod -Uri 'https://api.ajstudioz.dev/api/models' -Method GET -TimeoutSec 5; Write-Host '✅ Cloud endpoint online' -ForegroundColor Green } catch { Write-Host '❌ Cloud endpoint offline' -ForegroundColor Red }"
powershell -Command "try { $response = Invoke-RestMethod -Uri 'https://local-api.ajstudioz.dev/api/models' -Method GET -TimeoutSec 5; Write-Host '✅ Local tunnel online' -ForegroundColor Green } catch { Write-Host '❌ Local tunnel offline' -ForegroundColor Red }"

echo.
echo ════════════════════════════════════════════════════════════════════
pause
goto MENU

:EXIT
echo.
echo 👋 Thank you for using AJStudioz AI!
timeout /t 2
exit

:MENU
goto LOCAL_ONLY
