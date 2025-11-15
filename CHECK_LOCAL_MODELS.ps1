# Ollama Local Connection Test & Model Detection
Write-Host "🔍 Checking Local Ollama Connection..." -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Check if Ollama is running
try {
    $ollamaHealth = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -TimeoutSec 5
    Write-Host "✅ Ollama is running!" -ForegroundColor Green
    
    if ($ollamaHealth.models -and $ollamaHealth.models.Count -gt 0) {
        Write-Host ""
        Write-Host "📋 Available Local Models:" -ForegroundColor Yellow
        $ollamaHealth.models | ForEach-Object {
            $size = if ($_.size) { " ($([math]::Round($_.size / 1GB, 1)) GB)" } else { "" }
            Write-Host "  ✓ $($_.name)$size" -ForegroundColor Green
        }
        
        # Test with the first available model
        $testModel = $ollamaHealth.models[0].name
        Write-Host ""
        Write-Host "🧪 Testing API with model: $testModel" -ForegroundColor Yellow
        
        $testBody = @{
            model = $testModel
            prompt = "Hello! Respond with just 'Local model connected successfully'"
            stream = $false
        } | ConvertTo-Json
        
        try {
            $testResponse = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method POST -Body $testBody -ContentType "application/json" -TimeoutSec 30
            
            Write-Host "✅ Model Response:" -ForegroundColor Green
            Write-Host "   $($testResponse.response)" -ForegroundColor White
            Write-Host ""
            Write-Host "🎉 Your local models are ready!" -ForegroundColor Green
            
        } catch {
            Write-Host "❌ Model test failed: $_" -ForegroundColor Red
        }
        
    } else {
        Write-Host "⚠️  No models found. Install models with:" -ForegroundColor Yellow
        Write-Host "   ollama pull llama3.1" -ForegroundColor Gray
        Write-Host "   ollama pull qwen2.5:7b" -ForegroundColor Gray
        Write-Host "   ollama pull codellama" -ForegroundColor Gray
    }
    
} catch {
    Write-Host "❌ Ollama not running or not accessible" -ForegroundColor Red
    Write-Host "To start Ollama:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://ollama.ai/download" -ForegroundColor Gray
    Write-Host "2. Run: ollama serve" -ForegroundColor Gray
    Write-Host "3. Install models: ollama pull llama3.1" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Current error: $_" -ForegroundColor Red
}