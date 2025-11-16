@echo off
title AJStudioz AI - Local Models Only
color 0B
cls

echo ================================================================
echo              AJSTUDIOZ AI - LOCAL MODELS STARTER
echo ================================================================
echo.
echo ☁️  Cloud models (Kimi, Qwen 3 32B, Llama 4, GPT OSS) are ALWAYS ONLINE
echo     via Vercel at api.ajstudioz.dev - No startup needed!
echo.
echo 🖥️  This script starts LOCAL MODELS only (for privacy):
echo     • Qwen 3 Local (Fast chat & reasoning)
echo     • GLM-4.6 (Advanced local reasoning)
echo.
echo ================================================================
echo.

REM Check if Ollama is installed
echo [1/3] Checking Ollama installation...
where ollama >nul 2>&1
if errorlevel 1 (
    echo ❌ Ollama not found!
    echo.
    echo ⚠️  No problem! Cloud models work without Ollama.
    echo    Get Ollama from: https://ollama.ai
    echo.
    echo 💡 Meanwhile, use these models that are ALWAYS AVAILABLE:
    echo    • Kimi K2 Instruct (24/7 at api.ajstudioz.dev)
    echo    • Qwen 3 32B (24/7 at api.ajstudioz.dev)  
    echo    • Llama 4 Maverick (24/7 at api.ajstudioz.dev)
    echo    • GPT OSS 20B (24/7 at api.ajstudioz.dev)
    echo.
    pause
    exit /b 1
) else (
    echo ✅ Ollama found
)

echo.
echo [2/3] Starting Ollama service...
start /B ollama serve
timeout /t 3 >nul

echo.
echo [3/3] Checking local models...
set "models_needed="

REM Check Qwen 3
ollama list | findstr "qwen3" >nul
if errorlevel 1 (
    echo 📥 Downloading Qwen 3 (this may take a while)...
    ollama pull qwen3:1.7b
) else (
    echo ✅ Qwen 3 ready
)

REM Check GLM-4.6  
ollama list | findstr "glm-4.6" >nul
if errorlevel 1 (
    echo 📥 Downloading GLM-4.6 (this may take a while)...
    ollama pull glm-4.6:latest
) else (
    echo ✅ GLM-4.6 ready
)

echo.
echo ================================================================
echo                    🎉 LOCAL MODELS READY!
echo ================================================================
echo.
echo 🖥️  LOCAL MODELS (Private & Fast):
echo     • Qwen 3 - Available now
echo     • GLM-4.6 - Available now
echo.
echo ☁️  CLOUD MODELS (Always Online via Vercel):
echo     • Kimi K2 Instruct - Always available 24/7
echo     • Qwen 3 32B - Always available 24/7
echo     • Llama 4 Maverick - Always available 24/7
echo     • GPT OSS 20B - Always available 24/7
echo.
echo 🌐 Cloud API: https://api.ajstudioz.dev/api/chat (always online)
echo 🖥️  Local API: https://local-api.ajstudioz.dev/api/chat (via tunnel)
echo.
echo 🎯 USAGE:
echo     • Use CLOUD models for reliability (always work)
echo     • Use LOCAL models for privacy (when Ollama running)
echo     • Both work through the same chatbot interface
echo.
echo ================================================================
echo.
echo Ollama is now running for local models.
echo.
echo 💡 USAGE TIPS:
echo   • Local models: Use when you need privacy
echo   • Cloud models: Always available at api.ajstudioz.dev
echo   • Both work through the same chatbot interface
echo.
echo Close this window when you're done with local models.
echo Cloud models continue working 24/7 independently!
echo.
timeout /t 10
echo Ready! 🚀
pause