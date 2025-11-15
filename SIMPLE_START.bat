@echo off
title AJStudioz AI API - Simple Global Starter
color 0A
cd /d "c:\New folder\AJ-the-"

echo ================================
echo    AJStudioz AI API Starter
echo ================================
echo.

echo [1] Cleaning processes...
taskkill /F /IM node.exe 2>nul
taskkill /F /IM npx.exe 2>nul

echo [2] Starting Ollama...
start /B ollama serve
timeout /t 3 /nobreak >nul

echo [3] Starting server...
start /B node proxy-server.js
timeout /t 3 /nobreak >nul

echo [4] Starting LocalTunnel...
echo Please wait, creating tunnel...
npx localtunnel --port 3001

echo.
echo API is running! Use the URL shown above.
pause