@echo off
title AJStudioz AI API - Global Starter
color 0A

echo.
echo ================================
echo    AJStudioz AI API Starter
echo ================================
echo.

cd /d "c:\New folder\AJ-the-"

echo [1/4] 🧹 Cleaning up old processes...
taskkill /F /IM node.exe 2>nul
taskkill /F /IM npx.exe 2>nul
timeout /t 2 /nobreak >nul

echo [2/4] 🤖 Starting Ollama service...
start /B ollama serve
timeout /t 5 /nobreak >nul

echo [3/4] 🌐 Starting LocalTunnel with PERMANENT subdomain...
echo Starting server on port 3001...
start /B node proxy-server.js

timeout /t 3 /nobreak >nul

echo Creating permanent tunnel: https://ajstudioz-api.loca.lt
start /B npx localtunnel --port 3001 --subdomain ajstudioz-api

timeout /t 8 /nobreak >nul

echo [4/4] 🚀 Deploying to production...
echo Updating vercel.json with permanent URL...
powershell -Command "(Get-Content vercel.json) -replace 'https://[^\"]*\.loca\.lt', 'https://ajstudioz-api.loca.lt' | Set-Content vercel.json"

echo Committing changes...
git add vercel.json
git commit -m "Update to permanent LocalTunnel URL: https://ajstudioz-api.loca.lt"
git push origin main

echo Deploying to Vercel...
vercel --prod --yes

echo.
echo ✅ SUCCESS! Your AI API is now live globally:
echo.
echo 🌐 Global API URL: https://api.ajstudioz.dev/api/chat
echo 🔗 LocalTunnel URL: https://ajstudioz-api.loca.lt/api/chat
echo 🏠 Local URL: http://localhost:3001/api/chat
echo.
echo 📝 Test with this command:
echo curl -X POST "https://api.ajstudioz.dev/api/chat" ^
echo      -H "Content-Type: application/json" ^
echo      -H "X-API-Key: aj-demo123456789abcdef" ^
echo      -d "{\"model\": \"qwen3\", \"messages\": [{\"role\": \"user\", \"content\": \"hello\"}], \"stream\": false}"
echo.
echo 💡 Your API is running! Keep this window open.
echo Press any key to open the chatbot interface...
pause >nul
start https://ajstudioz-api.loca.lt/chat
echo.
echo 🎯 API Status: ACTIVE - Accessible worldwide!
echo 📊 Logs will appear below...
echo.

:loop
timeout /t 10 /nobreak >nul
echo [%time%] ✅ API Running - Global Access Active
goto loop