# AJStudioz AI - Quick Test Script
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "         TESTING AJSTUDIOZ AI API" -ForegroundColor Yellow
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

$headers = @{
    "Content-Type" = "application/json"
    "X-API-Key" = "aj-demo123456789abcdef"
}

$body = @{
    model = "qwen3"
    messages = @(
        @{
            role = "user"
            content = "Hello! Please respond with a short greeting."
        }
    )
    stream = $false
} | ConvertTo-Json

Write-Host "Testing: https://local-api.ajstudioz.dev/api/chat" -ForegroundColor Yellow
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri "https://local-api.ajstudioz.dev/api/chat" -Method POST -Headers $headers -Body $body -TimeoutSec 30
    
    Write-Host "✓ SUCCESS! API is working!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Model: $($response.model)" -ForegroundColor Cyan
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Response:" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    $response.output | Where-Object { $_.type -eq 'message' } | ForEach-Object {
        Write-Host $_.content[0].text -ForegroundColor White
    }
    Write-Host "----------------------------------------" -ForegroundColor Gray
    Write-Host ""
    Write-Host "✓ Your API is accessible globally!" -ForegroundColor Green
    
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "1. Make sure services are running (run START_AJSTUDIOZ_AI.bat)" -ForegroundColor Gray
    Write-Host "2. Wait 1-2 minutes for DNS propagation" -ForegroundColor Gray
    Write-Host "3. Check Cloudflare Dashboard for DNS settings" -ForegroundColor Gray
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""
