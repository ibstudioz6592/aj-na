@echo off
title AJStudioz AI - Starting...
color 0A
cls

REM Get the desktop path
set DESKTOP=%USERPROFILE%\Desktop
set PROJECT_PATH=c:\New folder\aj-fresh

echo.
echo ================================================================
echo              AJSTUDIOZ AI - CLOUDFLARE TUNNEL
echo ================================================================
echo.
echo Starting your AI API with global access...
echo.
echo Endpoint: https://local-api.ajstudioz.dev/api/chat
echo.
echo ================================================================
echo.

cd /d "%PROJECT_PATH%"

REM Step 1: Stop existing services
echo [1/4] Stopping existing services...
taskkill /F /IM ollama.exe 2>nul
taskkill /F /IM node.exe 2>nul
taskkill /F /IM cloudflared.exe 2>nul
timeout /t 2 >nul

REM Step 2: Start Ollama
echo [2/4] Starting Ollama (AI Models)...
start /B ollama serve
timeout /t 5 >nul

REM Step 3: Start Node.js API
echo [3/4] Starting API Server...
start /B node proxy-server.js
timeout /t 3 >nul

REM Step 4: Start Cloudflare Tunnel
echo [4/4] Starting Cloudflare Tunnel...
start /MIN cloudflared.exe tunnel --config config.yml run
timeout /t 5 >nul

echo.
echo ================================================================
echo                    ALL SERVICES STARTED!
echo ================================================================
echo.
echo Your AI API is now accessible at:
echo.
echo   https://local-api.ajstudioz.dev/api/chat
echo.
echo Available Models:
echo   LOCAL (Fast):
echo   - qwen3 (Qwen 3 - Chat & Problem Solving)
echo   - glm-4.6 (GLM 4.6 - Advanced Reasoning)
echo   CLOUD (Always Online):
echo   - kimi (Kimi via Groq - Reliable)
echo   - llama-70b (Llama 70B via Groq - Powerful)
echo   - mixtral (Mixtral 8x7B via Groq - Balanced)
echo.
echo Test Command:
echo   curl -X POST "https://local-api.ajstudioz.dev/api/chat" ^
echo     -H "Content-Type: application/json" ^
echo     -H "X-API-Key: aj-demo123456789abcdef" ^
echo     -d "{\"model\": \"qwen3\", \"messages\": [{\"role\": \"user\", \"content\": \"hello\"}]}"
echo.
echo ================================================================
echo.
echo Services are running in the background.
echo You can close this window safely.
echo.
echo To stop services:
echo   1. Open Task Manager (Ctrl+Shift+Esc)
echo   2. End tasks: ollama.exe, node.exe, cloudflared.exe
echo.
echo Or run: STOP_ALL_SERVICES.bat
echo.
echo ================================================================
echo.

timeout /t 10
exit
