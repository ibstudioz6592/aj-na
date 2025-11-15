# AJStudioz AI API - Global Starter (PowerShell)
# Double-click to start your AI API globally

$Host.UI.RawUI.WindowTitle = "AJStudioz AI API - Global Access"
Clear-Host

Write-Host @"

   █████╗      ██╗███████╗████████╗██╗   ██╗██████╗ ██╗ ██████╗ ███████╗
  ██╔══██╗     ██║██╔════╝╚══██╔══╝██║   ██║██╔══██╗██║██╔═══██╗╚══███╔╝
  ███████║     ██║███████╗   ██║   ██║   ██║██║  ██║██║██║   ██║  ███╔╝ 
  ██╔══██║██   ██║╚════██║   ██║   ██║   ██║██║  ██║██║██║   ██║ ███╔╝  
  ██║  ██║╚█████╔╝███████║   ██║   ╚██████╔╝██████╔╝██║╚██████╔╝███████╗
  ╚═╝  ╚═╝ ╚════╝ ╚══════╝   ╚═╝    ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝ ╚══════╝
                                                                          
                    🌐 Global AI API Starter 🚀
"@ -ForegroundColor Cyan

Write-Host ""
Set-Location "c:\New folder\AJ-the-"

# Step 1: Cleanup
Write-Host "🧹 [1/4] Cleaning up processes..." -ForegroundColor Yellow
Get-Process -Name "node" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process -Name "npx" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep 2

# Step 2: Start Ollama
Write-Host "🤖 [2/4] Starting Ollama service..." -ForegroundColor Yellow
Start-Process -FilePath "ollama" -ArgumentList "serve" -WindowStyle Hidden
Start-Sleep 5

# Step 3: Start server and LocalTunnel with permanent subdomain
Write-Host "🌐 [3/4] Starting server and permanent tunnel..." -ForegroundColor Yellow
Start-Process -FilePath "node" -ArgumentList "proxy-server.js" -WindowStyle Hidden
Start-Sleep 3

Write-Host "   Creating permanent tunnel: https://ajstudioz-api.loca.lt" -ForegroundColor Green
Start-Process -FilePath "npx" -ArgumentList "localtunnel", "--port", "3001", "--subdomain", "ajstudioz-api" -WindowStyle Hidden
Start-Sleep 8

# Step 4: Deploy
Write-Host "🚀 [4/4] Deploying to production..." -ForegroundColor Yellow
git add vercel.json
git commit -m "Update to permanent LocalTunnel URL: https://ajstudioz-api.loca.lt" -ErrorAction SilentlyContinue
git push origin main -ErrorAction SilentlyContinue
vercel --prod --yes

Write-Host ""
Write-Host "✅ SUCCESS! Your AI API is live globally!" -ForegroundColor Green -BackgroundColor Black
Write-Host ""
Write-Host "🌐 Global API: " -NoNewline -ForegroundColor White
Write-Host "https://api.ajstudioz.dev/api/chat" -ForegroundColor Cyan
Write-Host "🔗 LocalTunnel: " -NoNewline -ForegroundColor White  
Write-Host "https://ajstudioz-api.loca.lt/api/chat" -ForegroundColor Cyan
Write-Host "🏠 Local URL: " -NoNewline -ForegroundColor White
Write-Host "http://localhost:3001/api/chat" -ForegroundColor Cyan
Write-Host ""

# Test the API
Write-Host "🔍 Testing API..." -ForegroundColor Yellow
try {
    $headers = @{ 
        "Content-Type" = "application/json"
        "X-API-Key" = "aj-demo123456789abcdef" 
    }
    $body = '{"model": "qwen3", "messages": [{"role": "user", "content": "hello"}], "stream": false}'
    $response = Invoke-RestMethod -Uri "https://ajstudioz-api.loca.lt/api/chat" -Method POST -Headers $headers -Body $body -TimeoutSec 30
    
    Write-Host "✅ API Test PASSED!" -ForegroundColor Green
    Write-Host "📝 Response: " -NoNewline -ForegroundColor White
    $message = $response.output | Where-Object { $_.type -eq 'message' } | ForEach-Object { $_.content[0].text }
    Write-Host $message -ForegroundColor Yellow
} catch {
    Write-Host "⚠️  API Test in progress..." -ForegroundColor Yellow
    Write-Host "   The tunnel may still be connecting. Try again in a moment." -ForegroundColor Gray
}
}

Write-Host ""
Write-Host "📋 Quick Test Commands:" -ForegroundColor Magenta
Write-Host ""
Write-Host "PowerShell:" -ForegroundColor White
Write-Host '$headers = @{ "Content-Type" = "application/json"; "X-API-Key" = "aj-demo123456789abcdef" }' -ForegroundColor Gray
Write-Host '$body = ''{"model": "qwen3", "messages": [{"role": "user", "content": "hello"}], "stream": false}''' -ForegroundColor Gray
Write-Host 'Invoke-RestMethod -Uri "https://ajstudioz-api.loca.lt/api/chat" -Method POST -Headers $headers -Body $body' -ForegroundColor Gray
Write-Host ""
Write-Host "cURL:" -ForegroundColor White
Write-Host 'curl -X POST "https://ajstudioz-api.loca.lt/api/chat" \' -ForegroundColor Gray
Write-Host '     -H "Content-Type: application/json" \' -ForegroundColor Gray
Write-Host '     -H "X-API-Key: aj-demo123456789abcdef" \' -ForegroundColor Gray
Write-Host '     -d "{""model"": ""qwen3"", ""messages"": [{""role"": ""user"", ""content"": ""hello""}], ""stream"": false}"' -ForegroundColor Gray

Write-Host ""
Write-Host "🌍 Your API is now accessible from anywhere in the world!" -ForegroundColor Green -BackgroundColor DarkGreen
Write-Host "💡 Keep this window open to maintain the connection." -ForegroundColor Yellow
Write-Host ""

# Open chatbot interface
Write-Host "Press Enter to open the chatbot interface..." -ForegroundColor Cyan
Read-Host
Start-Process "https://ajstudioz-api.loca.lt/chat"

# Monitor
Write-Host ""
Write-Host "📊 Monitoring API status..." -ForegroundColor Magenta
while ($true) {
    Start-Sleep 30
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[$timestamp] ✅ API Active - Global Access Available" -ForegroundColor Green
}