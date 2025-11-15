@echo off
title AJ MEOW Launcher
color 0B

echo.
echo ==========================================
echo        AJ MEOW - Choose Launch Method
echo ==========================================
echo.
echo [1] Run Batch Script (Basic)
echo [2] Run PowerShell Script (Advanced) 
echo [3] Run PowerShell with Options
echo [4] Quick Deploy Only
echo [5] Exit
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo.
    echo Launching batch script...
    call "%~dp0AJ_MEOW.bat"
) else if "%choice%"=="2" (
    echo.
    echo Launching PowerShell script...
    powershell -ExecutionPolicy Bypass -File "%~dp0AJ_MEOW.ps1"
) else if "%choice%"=="3" (
    echo.
    echo PowerShell Options:
    echo [a] Skip Ollama
    echo [b] Skip Tunnel  
    echo [c] Skip Deployment
    echo [d] Skip Ollama and Tunnel
    echo [e] Deploy only (skip local services)
    echo.
    set /p psoption="Enter option (a-e): "
    
    if "%psoption%"=="a" (
        powershell -ExecutionPolicy Bypass -File "%~dp0AJ_MEOW.ps1" -SkipOllama
    ) else if "%psoption%"=="b" (
        powershell -ExecutionPolicy Bypass -File "%~dp0AJ_MEOW.ps1" -SkipTunnel
    ) else if "%psoption%"=="c" (
        powershell -ExecutionPolicy Bypass -File "%~dp0AJ_MEOW.ps1" -SkipDeploy
    ) else if "%psoption%"=="d" (
        powershell -ExecutionPolicy Bypass -File "%~dp0AJ_MEOW.ps1" -SkipOllama -SkipTunnel
    ) else if "%psoption%"=="e" (
        powershell -ExecutionPolicy Bypass -File "%~dp0AJ_MEOW.ps1" -SkipOllama -SkipTunnel
    ) else (
        echo Invalid option, running with default settings...
        powershell -ExecutionPolicy Bypass -File "%~dp0AJ_MEOW.ps1"
    )
) else if "%choice%"=="4" (
    echo.
    echo Quick deploying to GitHub and Vercel...
    cd /d "%~dp0"
    git add .
    git commit -m "Quick deploy - %date% %time%"
    git push origin main
    vercel --prod --yes
    echo.
    echo Quick deploy completed!
    pause
) else if "%choice%"=="5" (
    exit
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 /nobreak >nul
    goto :eof
)

pause