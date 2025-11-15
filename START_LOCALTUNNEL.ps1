# Quick LocalTunnel Test & URL Update
Write-Host "🌐 Testing LocalTunnel Connection..." -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

# Check if LocalTunnel is installed
try {
    $ltVersion = npx localtunnel --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ LocalTunnel is available" -ForegroundColor Green
    }
} catch {
    Write-Host "📦 Installing LocalTunnel..." -ForegroundColor Yellow
    npm install -g localtunnel
}

# Start LocalTunnel for port 3001
Write-Host ""
Write-Host "🚀 Starting LocalTunnel for port 3001..." -ForegroundColor Yellow
Write-Host "This will create a public URL for your local server" -ForegroundColor Gray

# Start LocalTunnel in background and capture URL
if (Test-Path "localtunnel_url.txt") { Remove-Item "localtunnel_url.txt" }

$ltProcess = Start-Process -FilePath "npx" -ArgumentList "localtunnel", "--port", "3001" -RedirectStandardOutput "localtunnel_url.txt" -PassThru -WindowStyle Hidden

Write-Host "Waiting for LocalTunnel to generate URL..." -ForegroundColor Gray

# Wait and extract URL
$url = ""
for($i=0; $i -lt 30; $i++) {
    Start-Sleep -Seconds 2
    if(Test-Path 'localtunnel_url.txt') {
        $content = Get-Content 'localtunnel_url.txt' -Raw -ErrorAction SilentlyContinue
        if($content -and $content -match 'https://[a-z0-9-]+\.loca\.lt') {
            $url = $matches[0]
            break
        }
    }
    Write-Host "." -NoNewline -ForegroundColor Gray
}

Write-Host ""

if($url) {
    Write-Host "✅ LocalTunnel URL Generated!" -ForegroundColor Green
    Write-Host "   URL: $url" -ForegroundColor White
    
    # Update vercel.json
    if(Test-Path 'vercel.json') {
        Write-Host ""
        Write-Host "📝 Updating vercel.json..." -ForegroundColor Yellow
        
        $json = Get-Content 'vercel.json' -Raw | ConvertFrom-Json
        $json.env.OLLAMA_URL = $url
        $json | ConvertTo-Json -Depth 10 | Set-Content 'vercel.json'
        
        Write-Host "✅ Updated vercel.json with: $url" -ForegroundColor Green
        
        # Commit and push the update
        Write-Host ""
        Write-Host "📤 Pushing URL update to GitHub..." -ForegroundColor Yellow
        
        git add vercel.json
        git commit -m "Update LocalTunnel URL to $url for global API access"
        git push origin main
        
        Write-Host "✅ Changes pushed to GitHub!" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "🌍 YOUR API IS NOW GLOBALLY ACCESSIBLE!" -ForegroundColor Green
        Write-Host "=======================================" -ForegroundColor Green
        Write-Host "Test with curl:" -ForegroundColor Cyan
        Write-Host 'curl -X POST "https://api.ajstudioz.dev/api/chat" \' -ForegroundColor Gray
        Write-Host '  -H "Content-Type: application/json" \' -ForegroundColor Gray  
        Write-Host '  -H "X-API-Key: aj-demo123456789abcdef" \' -ForegroundColor Gray
        Write-Host '  -d ''{"model": "qwen3", "messages": [{"role": "user", "content": "hello"}], "stream": false}''' -ForegroundColor Gray
        Write-Host ""
        Write-Host "💡 Keep this terminal open to maintain the tunnel!" -ForegroundColor Yellow
        
    } else {
        Write-Host "❌ vercel.json not found!" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Failed to get LocalTunnel URL" -ForegroundColor Red
    Write-Host "Make sure port 3001 is not in use and try again" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Press Ctrl+C to stop LocalTunnel..." -ForegroundColor Yellow

# Keep the tunnel alive
try {
    Wait-Process -Id $ltProcess.Id
} catch {
    Write-Host "LocalTunnel stopped" -ForegroundColor Yellow
}