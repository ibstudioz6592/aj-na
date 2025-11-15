# Test Script - Shows Working vs Not Working Endpoints

Write-Host ""
Write-Host "===============================================================================" -ForegroundColor Cyan
Write-Host "           AJSTUDIOZ AI - ENDPOINT TESTING" -ForegroundColor Yellow
Write-Host "===============================================================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Local API (Always Works)
Write-Host "TEST 1: Local API (http://localhost:3001/api/chat)" -ForegroundColor Yellow
Write-Host "Status: " -NoNewline
try {
    $headers = @{
        "Content-Type" = "application/json"
        "X-API-Key" = "aj-demo123456789abcdef"
    }
    $body = '{"model": "qwen3", "messages": [{"role": "user", "content": "hello"}], "stream": false}'
    $response = Invoke-RestMethod -Uri "http://localhost:3001/api/chat" -Method POST -Headers $headers -Body $body -TimeoutSec 10
    Write-Host "? WORKING!" -ForegroundColor Green
    Write-Host "  Model: $($response.model)" -ForegroundColor Gray
} catch {
    Write-Host "? FAILED: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 2: Cloudflare Tunnel - local-api
Write-Host "TEST 2: Cloudflare Tunnel (https://local-api.ajstudioz.dev/api/chat)" -ForegroundColor Yellow
Write-Host "Status: " -NoNewline
try {
    $headers = @{
        "Content-Type" = "application/json"
        "X-API-Key" = "aj-demo123456789abcdef"
    }
    $body = '{"model": "qwen3", "messages": [{"role": "user", "content": "hello"}], "stream": false}'
    $response = Invoke-RestMethod -Uri "https://local-api.ajstudioz.dev/api/chat" -Method POST -Headers $headers -Body $body -TimeoutSec 30
    Write-Host "? WORKING!" -ForegroundColor Green
    Write-Host "  Model: $($response.model)" -ForegroundColor Gray
    Write-Host "  ? Your local models are accessible globally!" -ForegroundColor Green
} catch {
    Write-Host "? FAILED: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  ? Wait 1-2 minutes for DNS propagation after starting tunnel" -ForegroundColor Yellow
}
Write-Host ""

# Test 3: Original Domain - api.ajstudioz.dev
Write-Host "TEST 3: Original Request (https://api.ajstudioz.dev/api/chat)" -ForegroundColor Yellow
Write-Host "Status: " -NoNewline
try {
    $headers = @{
        "Content-Type" = "application/json"
        "X-API-Key" = "aj-demo123456789abcdef"
    }
    $body = '{"model": "qwen3", "messages": [{"role": "user", "content": "hello"}], "stream": false}'
    $response = Invoke-RestMethod -Uri "https://api.ajstudioz.dev/api/chat" -Method POST -Headers $headers -Body $body -TimeoutSec 30
    Write-Host "? WORKING!" -ForegroundColor Green
    Write-Host "  Model: $($response.model)" -ForegroundColor Gray
    Write-Host "  ? Perfect! Your original request now works!" -ForegroundColor Green
} catch {
    Write-Host "? NOT WORKING (Expected)" -ForegroundColor Red
    Write-Host "  Reason: DNS points to Vercel, not your Cloudflare tunnel" -ForegroundColor Yellow
    Write-Host "  Fix: See FINAL_SOLUTION.md for DNS update instructions" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "===============================================================================" -ForegroundColor Cyan
Write-Host "                            SUMMARY" -ForegroundColor Yellow
Write-Host "===============================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "? WORKING ENDPOINTS (use these now):" -ForegroundColor Green
Write-Host ""
Write-Host "1. Local API:" -ForegroundColor White
Write-Host '   curl -X POST "http://localhost:3001/api/chat" \' -ForegroundColor Gray
Write-Host '     -H "Content-Type: application/json" \' -ForegroundColor Gray
Write-Host '     -H "X-API-Key: aj-demo123456789abcdef" \' -ForegroundColor Gray
Write-Host '     -d ''{"model": "qwen3", "messages": [{"role": "user", "content": "hello"}], "stream": false}''' -ForegroundColor Gray
Write-Host ""
Write-Host "2. Cloudflare Tunnel (Global Access):" -ForegroundColor White
Write-Host '   curl -X POST "https://local-api.ajstudioz.dev/api/chat" \' -ForegroundColor Gray
Write-Host '     -H "Content-Type: application/json" \' -ForegroundColor Gray
Write-Host '     -H "X-API-Key: aj-demo123456789abcdef" \' -ForegroundColor Gray
Write-Host '     -d ''{"model": "qwen3", "messages": [{"role": "user", "content": "hello"}], "stream": false}''' -ForegroundColor Gray
Write-Host ""
Write-Host "? TO FIX api.ajstudioz.dev:" -ForegroundColor Yellow
Write-Host "  Read: FINAL_SOLUTION.md" -ForegroundColor Cyan
Write-Host "  Summary: Delete Vercel DNS record in Cloudflare Dashboard" -ForegroundColor Gray
Write-Host ""
Write-Host "===============================================================================" -ForegroundColor Cyan
Write-Host ""
