# AJStudioz AI - Cloudflare Tunnel Startup Script
# Makes your local models available at https://api.ajstudioz.dev/api/chat

$Host.UI.RawUI.WindowTitle = "AJStudioz AI - api.ajstudioz.dev"
Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "   AJStudioz AI - CLOUDFLARE TUNNEL FOR GLOBAL ACCESS" -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Your local models will be available at:" -ForegroundColor White
Write-Host "https://api.ajstudioz.dev/api/chat" -ForegroundColor Green -BackgroundColor Black
Write-Host ""
Write-Host "Test with curl:" -ForegroundColor Yellow
Write-Host 'curl -X POST "https://api.ajstudioz.dev/api/chat" \' -ForegroundColor Gray
Write-Host '  -H "Content-Type: application/json" \' -ForegroundColor Gray
Write-Host '  -H "X-API-Key: aj-demo123456789abcdef" \' -ForegroundColor Gray
Write-Host '  -d ''{"model": "qwen3", "messages": [{"role": "user", "content": "hello"}], "stream": false}''' -ForegroundColor Gray
Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# Change to script directory
Set-Location $PSScriptRoot

# Step 1: Stop existing services
Write-Host "[1/4] Stopping existing services..." -ForegroundColor Yellow
Get-Process -Name "ollama","node","cloudflared" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep 2

# Step 2: Start Ollama
Write-Host "[2/4] Starting Ollama (local AI models)..." -ForegroundColor Yellow
Start-Process -FilePath "ollama" -ArgumentList "serve" -WindowStyle Hidden
Start-Sleep 5

# Step 3: Start Node.js API server
Write-Host "[3/4] Starting API server on http://localhost:3001..." -ForegroundColor Yellow
Start-Process -FilePath "node" -ArgumentList "proxy-server.js" -WindowStyle Hidden
Start-Sleep 3

# Step 4: Start Cloudflare Tunnel
Write-Host "[4/4] Starting Cloudflare Tunnel to api.ajstudioz.dev..." -ForegroundColor Yellow
Write-Host ""
Write-Host "? Your API is now LIVE at: https://api.ajstudioz.dev/api/chat" -ForegroundColor Green
Write-Host ""
Write-Host "Press Ctrl+C to stop all services" -ForegroundColor Gray
Write-Host ""

# Start cloudflared with config file
try {
    & .\cloudflared.exe tunnel --config config.yml run
} finally {
    # Cleanup on exit
    Write-Host ""
    Write-Host "Stopping all services..." -ForegroundColor Yellow
    Get-Process -Name "ollama","node","cloudflared" -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "? All services stopped." -ForegroundColor Green
}
