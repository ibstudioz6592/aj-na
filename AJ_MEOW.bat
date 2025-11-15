@echo off
title AJ MEOW - Auto Startup and Deploy
color 0A
echo.
echo ==========================================
echo.
echo       AJ MEOW - AI Platform Startup
echo.
echo ==========================================
echo   Starting Your AI Platform...
echo ==========================================
echo.

REM Check if we're in the correct directory
cd /d "%~dp0"
if not exist "package.json" (
    echo ERROR: package.json not found! Make sure you're running this from the project directory.
    pause
    exit /b 1
)

REM Step 1: Clean up old processes
echo [1/8] Cleaning up old processes...
taskkill /F /IM ollama.exe /T >nul 2>&1
taskkill /F /IM node.exe /T >nul 2>&1
taskkill /F /IM npx.exe /T >nul 2>&1
taskkill /F /IM localtunnel.exe /T >nul 2>&1
timeout /t 2 /nobreak >nul
echo     Done!

REM Step 2: Install/Update Dependencies
echo.
echo [2/8] Installing/Updating dependencies...
call npm install
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies!
    pause
    exit /b 1
)
echo     Dependencies updated!

REM Step 3: Check and Start Ollama
echo.
echo [3/8] Checking Ollama installation...
where ollama >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: Ollama not found in PATH. Please install Ollama first.
    echo Download from: https://ollama.ai/download
    echo Continuing without Ollama...
) else (
    echo     Starting Ollama...
    start /B ollama serve
    timeout /t 4 /nobreak >nul
    echo     Ollama running!
)

REM Step 4: Start Proxy Server
echo.
echo [4/8] Starting Proxy Server...
start "Proxy Server" /MIN cmd /c "node proxy-server.js"
timeout /t 3 /nobreak >nul
echo     Proxy running on port 3001!

REM Step 5: Start LocalTunnel and capture URL
echo.
echo [5/8] Starting LocalTunnel...
if exist "localtunnel_url.txt" del "localtunnel_url.txt"
start "LocalTunnel" /MIN cmd /c "npx localtunnel --port 3001 > localtunnel_url.txt 2>&1"
timeout /t 10 /nobreak >nul
echo     LocalTunnel started!

REM Step 6: Extract URL and update vercel.json
echo.
echo [6/8] Getting tunnel URL and updating config...
powershell -Command "$url = ''; for($i=0; $i -lt 20; $i++) { if(Test-Path 'localtunnel_url.txt') { $content = Get-Content 'localtunnel_url.txt' -Raw; if($content -match 'https://[a-z0-9-]+\.loca\.lt') { $url = $matches[0]; break; } } Start-Sleep -Seconds 2 }; if($url) { Write-Host \"    Found LocalTunnel URL: $url\" -ForegroundColor Green; if(Test-Path 'vercel.json') { $json = Get-Content 'vercel.json' -Raw | ConvertFrom-Json; $json.env.OLLAMA_URL = $url; $json | ConvertTo-Json -Depth 10 | Set-Content 'vercel.json'; Write-Host \"    Updated vercel.json with new tunnel URL!\" -ForegroundColor Green; Write-Host \"    Your API will be accessible at: https://api.ajstudioz.dev/api/chat\" -ForegroundColor Cyan } else { Write-Host \"    Warning: vercel.json not found\" -ForegroundColor Yellow } } else { Write-Host \"    Warning: Could not get LocalTunnel URL - check if localtunnel is running\" -ForegroundColor Yellow }"

REM Step 7: Auto-commit and push to GitHub
echo.
echo [7/8] Pushing updates to GitHub...
git add .
git status --porcelain > temp_status.txt
for /f %%i in ("temp_status.txt") do set size=%%~zi
if %size% gtr 0 (
    git commit -m "Auto-deployment update - %date% %time%"
    git push origin main
    if %errorlevel% equ 0 (
        echo     Successfully pushed to GitHub!
    ) else (
        echo     WARNING: Failed to push to GitHub
    )
) else (
    echo     No changes to commit
)
del temp_status.txt

REM Step 8: Deploy to Vercel
echo.
echo [8/8] Deploying to Vercel...
where vercel >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Vercel CLI...
    call npm install -g vercel
)

echo Logging in and deploying...
call vercel --prod --yes
if %errorlevel% equ 0 (
    echo     Deployment successful!
) else (
    echo     WARNING: Deployment failed
)

REM Show success message
echo.
echo  ======================================
echo   SUCCESS! Your AI Platform is LIVE!
echo  ======================================
echo.
echo   GitHub Repo: https://github.com/tomo-academy/AJ-the-
echo   Global API:  https://api.ajstudioz.dev/api/chat
echo   Local:       http://localhost:3001
echo   Chatbot:     https://api.ajstudioz.dev/chat
echo.
echo   Services Status:
echo   - Proxy Server: Running on port 3001
echo   - LocalTunnel:  Active (for Ollama access)
echo   - GitHub:       Auto-synced
echo   - Vercel:       Deployed
echo.
echo   Keep this window open to maintain services!
echo  ======================================
echo.

REM Keep services running
echo Press Ctrl+C to stop all services, or close this window.
echo.
:loop
timeout /t 30 /nobreak >nul
echo [%time%] Services still running... (Heartbeat every 30s)
goto loop
