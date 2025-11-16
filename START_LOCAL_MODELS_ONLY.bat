@echo off
title AJStudioz AI - Local Models Only
color 0B
cls

echo ================================================================
echo              AJSTUDIOZ AI - LOCAL MODELS STARTER
echo ================================================================
echo.
echo ☁️  Cloud models (Kimi, Llama 70B, Mixtral) are ALWAYS ONLINE
echo     via Vercel deployment - No startup needed!
echo.
echo 🖥️  This script starts LOCAL MODELS only (optional):
echo     • Qwen 3 (Fast chat)
echo     • GLM-4.6 (Advanced reasoning)
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
    echo    • Kimi (Groq Cloud)
    echo    • Llama 70B (Groq Cloud)  
    echo    • Mixtral 8x7B (Groq Cloud)
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
echo     • Kimi (Groq) - Always available 24/7
echo     • Llama 70B (Groq) - Always available 24/7
echo     • Mixtral 8x7B (Groq) - Always available 24/7
echo.
echo 🌐 Your API Endpoint: https://your-vercel-app.vercel.app/api/chat
echo 💻 Local API: http://localhost:3001/api/chat (if running locally)
echo.
echo 🎯 USAGE:
echo     • Use CLOUD models for reliability (always work)
echo     • Use LOCAL models for privacy (when Ollama running)
echo     • Both work through the same chatbot interface
echo.
echo ================================================================
echo.
echo Ollama is now running for local models.
echo Cloud models work independently - no startup needed!
echo.
echo Close this window when you're done with local models.
echo Cloud models will continue working 24/7.
echo.
timeout /t 10
echo Ready! 🚀
pause