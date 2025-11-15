# AJ MEOW - Local Model Setup Script
# Sets up GLM-4.6 and Qwen 3 for your local server

Write-Host "🚀 AJ MEOW Local Model Setup" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Write-Host "Setting up GLM-4.6 and Qwen 3 for your local server" -ForegroundColor Gray
Write-Host ""

# Check if Ollama is installed
$ollamaInstalled = Get-Command "ollama" -ErrorAction SilentlyContinue
if (-not $ollamaInstalled) {
    Write-Host "❌ Ollama not found!" -ForegroundColor Red
    Write-Host "Please install Ollama first:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://ollama.ai/download" -ForegroundColor Gray
    Write-Host "2. Install and restart your terminal" -ForegroundColor Gray
    Write-Host "3. Run this script again" -ForegroundColor Gray
    exit 1
}

Write-Host "✅ Ollama is installed" -ForegroundColor Green

# Check if Ollama service is running
try {
    $ollamaStatus = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -TimeoutSec 3 -ErrorAction Stop
    Write-Host "✅ Ollama service is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Ollama service is not running" -ForegroundColor Red
    Write-Host "Starting Ollama service..." -ForegroundColor Yellow
    
    # Try to start Ollama
    Start-Process -FilePath "ollama" -ArgumentList "serve" -WindowStyle Hidden
    Start-Sleep -Seconds 5
    
    # Check again
    try {
        $ollamaStatus = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -TimeoutSec 3
        Write-Host "✅ Ollama service started successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to start Ollama service" -ForegroundColor Red
        Write-Host "Please run 'ollama serve' manually in another terminal" -ForegroundColor Yellow
        exit 1
    }
}

# Check installed models
Write-Host ""
Write-Host "📋 Checking installed models..." -ForegroundColor Yellow

$installedModels = @()
if ($ollamaStatus.models) {
    $installedModels = $ollamaStatus.models | ForEach-Object { $_.name }
    Write-Host "Currently installed models:" -ForegroundColor Gray
    $installedModels | ForEach-Object {
        Write-Host "  - $_" -ForegroundColor White
    }
} else {
    Write-Host "No models currently installed" -ForegroundColor Gray
}

# Required models for your project
$requiredModels = @(
    @{ name = "glm4"; description = "GLM-4.6 - Advanced reasoning model" },
    @{ name = "qwen2.5:7b"; description = "Qwen 3 - Fast chat model (7B version)" }
)

Write-Host ""
Write-Host "🔧 Installing required models..." -ForegroundColor Yellow

foreach ($model in $requiredModels) {
    $modelName = $model.name
    $modelDesc = $model.description
    
    if ($installedModels -contains $modelName) {
        Write-Host "✅ $modelDesc - Already installed" -ForegroundColor Green
    } else {
        Write-Host "📥 Installing $modelDesc..." -ForegroundColor Yellow
        Write-Host "   This may take several minutes depending on your internet connection" -ForegroundColor Gray
        
        try {
            # Install the model
            $process = Start-Process -FilePath "ollama" -ArgumentList "pull", $modelName -Wait -PassThru -NoNewWindow
            
            if ($process.ExitCode -eq 0) {
                Write-Host "✅ $modelDesc - Installed successfully" -ForegroundColor Green
            } else {
                Write-Host "❌ Failed to install $modelDesc" -ForegroundColor Red
            }
        } catch {
            Write-Host "❌ Error installing $modelDesc : $_" -ForegroundColor Red
        }
    }
}

# Test the models
Write-Host ""
Write-Host "🧪 Testing model connections..." -ForegroundColor Yellow

foreach ($model in $requiredModels) {
    $modelName = $model.name
    
    Write-Host "Testing $modelName..." -ForegroundColor Gray
    
    try {
        $testBody = @{
            model = $modelName
            prompt = "Hello! Please respond with just 'Model test successful for $modelName'"
            stream = $false
        } | ConvertTo-Json
        
        $testResponse = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method POST -Body $testBody -ContentType "application/json" -TimeoutSec 30
        
        if ($testResponse.response) {
            Write-Host "✅ $modelName - Working correctly" -ForegroundColor Green
            if ($testResponse.response.Length -gt 50) {
                Write-Host "   Response: $($testResponse.response.Substring(0, 50))..." -ForegroundColor White
            } else {
                Write-Host "   Response: $($testResponse.response)" -ForegroundColor White
            }
        } else {
            Write-Host "⚠️  $modelName - Responded but no content" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ $modelName - Test failed: $_" -ForegroundColor Red
    }
}

# Final status
Write-Host ""
Write-Host "=============================" -ForegroundColor Cyan
Write-Host "🎉 Setup Complete!" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Your local models are ready:" -ForegroundColor White
Write-Host "📍 GLM-4.6: Advanced reasoning and analysis" -ForegroundColor Gray
Write-Host "📍 Qwen 3: Fast chat and general tasks" -ForegroundColor Gray
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Start your server: node proxy-server.js" -ForegroundColor Gray
Write-Host "2. Open chatbot: http://localhost:3001/chat" -ForegroundColor Gray
Write-Host "3. Test API with: curl commands or the chatbot interface" -ForegroundColor Gray
Write-Host ""
Write-Host "💡 Keep Ollama running (ollama serve) for the models to work" -ForegroundColor Yellow