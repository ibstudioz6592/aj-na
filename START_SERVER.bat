@echo off
title AJStudioz AI Server - Starting...
cls
echo.
echo ==========================================
echo    AJStudioz AI Server Starter
echo ==========================================
echo.

cd /d "%~dp0"

echo [1/4] Starting Ollama service...
start /B ollama serve >nul 2>&1
timeout /t 3 >nul

echo [2/4] Starting Node.js server on port 3001...
start /B node proxy-server.js >nul 2>&1
timeout /t 2 >nul

echo [3/4] Creating global tunnel...
start /B npx localtunnel --port 3001 --subdomain ajstudioz-ai >tunnel_output.txt 2>&1
timeout /t 5 >nul

echo [4/4] Extracting tunnel URL...
for /f "tokens=*" %%i in ('findstr "your url is" tunnel_output.txt 2^>nul') do (
    for %%j in (%%i) do (
        if "%%j" NEQ "your" if "%%j" NEQ "url" if "%%j" NEQ "is:" (
            set TUNNEL_URL=%%j
        )
    )
)

if defined TUNNEL_URL (
    echo.
    echo ✅ SUCCESS! Server is running globally:
    echo    Local:  http://localhost:3001
    echo    Global: %TUNNEL_URL%
    echo    API:    https://api.ajstudioz.dev/api/chat
    echo.
    echo 🚀 Testing API endpoint...
    echo.
    
    REM Update vercel.json with new tunnel URL
    powershell -Command "(Get-Content vercel.json) -replace 'https://[^\"]*loca\.lt', '%TUNNEL_URL%' | Set-Content vercel.json"
    
    REM Deploy to Vercel
    echo [Deploying to production...]
    vercel --prod --yes >deployment.log 2>&1
    
    echo ✅ API endpoint ready: https://api.ajstudioz.dev/api/chat
    echo.
    echo Press any key to test the API or close to keep running...
    pause >nul
    
    REM Test the API
    echo Testing API...
    curl -X POST "https://api.ajstudioz.dev/api/chat" -H "Content-Type: application/json" -H "X-API-Key: aj-demo123456789abcdef" -d "{\"model\": \"qwen3\", \"messages\": [{\"role\": \"user\", \"content\": \"hello\"}], \"stream\": false}"
    
) else (
    echo ❌ Failed to get tunnel URL. Trying direct approach...
    npx localtunnel --port 3001
)

echo.
echo Server is running! Keep this window open.
echo Close this window to stop the server.
pause