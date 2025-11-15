@echo off
title AJStudioz AI Server
cls
echo.
echo ==========================================
echo    🚀 AJStudioz AI Server
echo ==========================================
echo.

cd /d "%~dp0"

echo ⏳ Cleaning up old processes...
taskkill /f /im node.exe >nul 2>&1
taskkill /f /im ollama.exe >nul 2>&1
timeout /t 1 >nul

echo 🤖 Starting Ollama...
start /MIN ollama serve
timeout /t 4 >nul

echo 🌐 Starting Node.js server...
start /MIN node proxy-server.js
timeout /t 3 >nul

echo 🔗 Creating global tunnel...
echo    Please wait, getting your global URL...
echo.

REM Create tunnel and capture output
npx localtunnel --port 3001 > tunnel.txt 2>&1 &

REM Wait a bit for tunnel to establish
timeout /t 8 >nul

REM Extract URL from tunnel output
for /f "tokens=*" %%i in (tunnel.txt) do (
    echo %%i | findstr "your url is" >nul
    if not errorlevel 1 (
        for %%j in (%%i) do (
            if "%%j" neq "your" if "%%j" neq "url" if "%%j" neq "is:" (
                set "TUNNEL_URL=%%j"
            )
        )
    )
)

if defined TUNNEL_URL (
    echo ✅ SUCCESS! Your AI server is now running globally!
    echo.
    echo 📍 URLs:
    echo    🏠 Local:  http://localhost:3001
    echo    🌍 Global: %TUNNEL_URL%
    echo    💬 Chat:   %TUNNEL_URL%/chat
    echo.
    echo 🧪 API Endpoint: %TUNNEL_URL%/api/chat
    echo    (Also available at: https://api.ajstudioz.dev/api/chat)
    echo.
    echo 📝 Test command:
    echo curl -X POST "%TUNNEL_URL%/api/chat" \
    echo   -H "Content-Type: application/json" \
    echo   -H "X-API-Key: aj-demo123456789abcdef" \
    echo   -d '{"model": "qwen3", "messages": [{"role": "user", "content": "hello"}], "stream": false}'
    echo.
    echo 🎯 Ready to use! Keep this window open.
    echo    Press CTRL+C to stop the server.
    echo.
    
    REM Test the API quickly
    echo 🧪 Quick API test...
    curl -X POST "%TUNNEL_URL%/api/chat" -H "Content-Type: application/json" -H "X-API-Key: aj-demo123456789abcdef" -d "{\"model\": \"qwen3\", \"messages\": [{\"role\": \"user\", \"content\": \"hello\"}], \"stream\": false}" 2>nul
    if errorlevel 1 (
        echo ⚠️  API test failed, but server is running. Try the URL above.
    ) else (
        echo ✅ API test successful!
    )
    
) else (
    echo ❌ Could not get tunnel URL. Starting tunnel manually...
    npx localtunnel --port 3001
)

echo.
pause