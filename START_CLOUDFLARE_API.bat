@echo off
title AJStudioz AI - api.ajstudioz.dev/api/chat
color 0B
cls
echo.
echo ========================================================
echo    AJStudioz AI - CLOUDFLARE TUNNEL FOR GLOBAL ACCESS
echo ========================================================
echo.
echo Starting services to make your local models available at:
echo https://api.ajstudioz.dev/api/chat
echo.
echo Testing with curl:
echo curl -X POST "https://api.ajstudioz.dev/api/chat" \
echo   -H "Content-Type: application/json" \
echo   -H "X-API-Key: aj-demo123456789abcdef" \
echo   -d '{"model": "qwen3", "messages": [{"role": "user", "content": "hello"}], "stream": false}'
echo.
echo ========================================================

cd /d "%~dp0"

REM Step 1: Stop any existing services
echo [1/4] Stopping existing services...
taskkill /F /IM ollama.exe 2>nul
taskkill /F /IM node.exe 2>nul
taskkill /F /IM cloudflared.exe 2>nul
timeout /t 2 >nul

REM Step 2: Start Ollama
echo [2/4] Starting Ollama (local AI models)...
start /B ollama serve
timeout /t 5 >nul

REM Step 3: Start Node.js API server
echo [3/4] Starting API server on http://localhost:3001...
start /B node proxy-server.js
timeout /t 3 >nul

REM Step 4: Start Cloudflare Tunnel
echo [4/4] Starting Cloudflare Tunnel to api.ajstudioz.dev...
echo.
echo ? Your API will be live at: https://api.ajstudioz.dev/api/chat
echo.
echo Press Ctrl+C to stop all services
echo.

REM Start cloudflared with config file
cloudflared.exe tunnel --config config.yml run

REM Cleanup on exit
echo.
echo Stopping all services...
taskkill /F /IM ollama.exe 2>nul
taskkill /F /IM node.exe 2>nul
taskkill /F /IM cloudflared.exe 2>nul
