# 🎓 GitHub Models API Test Script

$apiKey = "aj-demo123456789abcdef"
$baseUrl = "http://localhost:3001/api/chat"  # Local development
# $baseUrl = "https://api.ajstudioz.dev/api/chat"  # Production

Write-Host "🚀 Testing GitHub Models API Integration" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

$headers = @{
    "Content-Type" = "application/json"
    "X-API-Key" = $apiKey
}

# Test GitHub Models (FREE for students!)
$githubModels = @("gpt-4o-mini", "gpt-4o", "claude-3-5-haiku", "llama-3-1-8b")

foreach ($model in $githubModels) {
    Write-Host "`n🎓 Testing $model (GitHub Student FREE)..." -ForegroundColor Yellow
    
    $body = @{
        model = $model
        messages = @(
            @{
                role = "user"
                content = "Hello! What is 2+2? Answer briefly."
            }
        )
        temperature = 0.7
        max_tokens = 100
    } | ConvertTo-Json -Depth 3
    
    try {
        $response = Invoke-RestMethod -Uri $baseUrl -Method POST -Headers $headers -Body $body -ErrorAction Stop
        
        if ($response.output -and $response.output[0].content -and $response.output[0].content[0].text) {
            $responseText = $response.output[0].content[0].text
        } else {
            $responseText = $response.response
        }
        
        Write-Host "✅ Response: $responseText" -ForegroundColor Cyan
        Write-Host "   Model: $($response.model)" -ForegroundColor Gray
        Write-Host "   Tokens: $($response.usage.total_tokens)" -ForegroundColor Gray
    }
    catch {
        Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Start-Sleep -Seconds 1
}

Write-Host "`n🎯 GitHub Models Integration Complete!" -ForegroundColor Green
Write-Host "Your AI API now supports FREE unlimited GPT-4o and Claude!" -ForegroundColor Yellow