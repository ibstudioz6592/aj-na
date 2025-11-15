@echo off
title Stopping AJStudioz AI Services
color 0C
cls

echo.
echo ================================================================
echo            STOPPING AJSTUDIOZ AI SERVICES
echo ================================================================
echo.
echo Stopping all running services...
echo.

REM Stop all services
taskkill /F /IM ollama.exe 2>nul
taskkill /F /IM node.exe 2>nul
taskkill /F /IM cloudflared.exe 2>nul

echo.
echo ✓ All services stopped!
echo.
echo ================================================================
echo.

timeout /t 3
exit
