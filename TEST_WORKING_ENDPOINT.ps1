# Test the WORKING Cloudflare Tunnel endpoint
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Testing WORKING Cloudflare Tunnel" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
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
            content = "Hello! Can you confirm you're running on my local machine through Cloudflare tunnel?"
        }
    )
    stream = $false
} | ConvertTo-Json

Write-Host "Testing: https://local-api.ajstudioz.dev/api/chat" -ForegroundColor Yellow
Write-Host "This is YOUR local Qwen 3 model via Cloudflare Tunnel!" -ForegroundColor Green
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri "https://local-api.ajstudioz.dev/api/chat" -Method POST -Headers $headers -Body $body -TimeoutSec 60
    
    Write-Host "? SUCCESS! Your local API is accessible globally!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Response ID: $($response.id)" -ForegroundColor Cyan
    Write-Host "Model: $($response.model)" -ForegroundColor Cyan
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Model Response:" -ForegroundColor Yellow
    Write-Host "-----------------------------------" -ForegroundColor Gray
    $response.output | Where-Object { $_.type -eq 'message' } | ForEach-Object {
        Write-Host $_.content[0].text -ForegroundColor White
    }
    Write-Host "-----------------------------------" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Token Usage:" -ForegroundColor Cyan
    Write-Host "  Input: $($response.usage.input_tokens)" -ForegroundColor Gray
    Write-Host "  Output: $($response.usage.output_tokens)" -ForegroundColor Gray
    Write-Host "  Total: $($response.usage.total_tokens)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "? Your local models are now accessible from ANYWHERE in the world!" -ForegroundColor Green
    Write-Host "? Share this endpoint with your team or apps: https://local-api.ajstudioz.dev" -ForegroundColor Yellow
    
} catch {
    Write-Host "? Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Make sure:" -ForegroundColor Yellow
    Write-Host "1. Cloudflare tunnel is running (run: .\START_CLOUDFLARE_API.ps1)" -ForegroundColor Gray
    Write-Host "2. Local API is working (test: http://localhost:3001/health)" -ForegroundColor Gray
    Write-Host "3. DNS has propagated (wait 1-2 minutes after starting)" -ForegroundColor Gray
}

Write-Host ""
