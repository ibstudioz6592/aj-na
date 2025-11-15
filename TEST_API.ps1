# AJ MEOW - Complete API and Chatbot Test Script
# This script tests all components to ensure everything works perfectly

param(
    [string]$BaseURL = "http://localhost:3001",
    [string]$ApiKey = "aj-demo123456789abcdef",
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

# Test configuration
$testCases = @(
    @{
        Name = "Test Models Endpoint"
        Method = "GET"
        Endpoint = "/api/models"
        Headers = @{"X-API-Key" = $ApiKey}
        Body = $null
    },
    @{
        Name = "Test Chat API with qwen3:1.7b"
        Method = "POST"
        Endpoint = "/api/chat"
        Headers = @{
            "Content-Type" = "application/json"
            "X-API-Key" = $ApiKey
        }
        Body = @{
            model = "qwen3:1.7b"
            messages = @(@{role = "user"; content = "Hello, respond with just 'API Test Successful'"})
            stream = $false
        }
    },
    @{
        Name = "Test Chat API with GLM-4.6"
        Method = "POST"
        Endpoint = "/api/chat"
        Headers = @{
            "Content-Type" = "application/json"
            "X-API-Key" = $ApiKey
        }
        Body = @{
            model = "glm-4.6"
            messages = @(@{role = "user"; content = "Say 'GLM Test Successful' in exactly those words"})
            stream = $false
        }
    },
    @{
        Name = "Test Invalid Model"
        Method = "POST"
        Endpoint = "/api/chat"
        Headers = @{
            "Content-Type" = "application/json"
            "X-API-Key" = $ApiKey
        }
        Body = @{
            model = "invalid-model"
            messages = @(@{role = "user"; content = "test"})
            stream = $false
        }
        ExpectError = $true
    },
    @{
        Name = "Test Invalid API Key"
        Method = "POST"
        Endpoint = "/api/chat"
        Headers = @{
            "Content-Type" = "application/json"
            "X-API-Key" = "invalid-key"
        }
        Body = @{
            model = "qwen3:1.7b"
            messages = @(@{role = "user"; content = "test"})
            stream = $false
        }
        ExpectError = $true
    }
)

function Write-TestResult {
    param([string]$TestName, [bool]$Success, [string]$Details = "")
    $status = if ($Success) { "✅ PASS" } else { "❌ FAIL" }
    $color = if ($Success) { "Green" } else { "Red" }
    
    Write-Host "[$status] $TestName" -ForegroundColor $color
    if ($Details -and ($Verbose -or -not $Success)) {
        Write-Host "    $Details" -ForegroundColor Gray
    }
}

function Test-ServerRunning {
    try {
        $response = Invoke-WebRequest -Uri "$BaseURL/api/models" -Method HEAD -TimeoutSec 5 -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Header
Clear-Host
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "    AJ MEOW - API & Chatbot Test Suite" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check if server is running
Write-Host "[1/3] Checking if server is running..." -ForegroundColor Yellow
if (-not (Test-ServerRunning)) {
    Write-Host "❌ Server not running at $BaseURL" -ForegroundColor Red
    Write-Host "Starting local server..." -ForegroundColor Yellow
    
    # Start server
    $serverJob = Start-Job -ScriptBlock {
        param($ProjectPath)
        Set-Location $ProjectPath
        node proxy-server.js
    } -ArgumentList (Split-Path $PSScriptRoot -Parent)
    
    # Wait for server to start
    $retries = 0
    while ($retries -lt 10 -and -not (Test-ServerRunning)) {
        Start-Sleep -Seconds 2
        $retries++
    }
    
    if (Test-ServerRunning) {
        Write-TestResult "Server startup" $true "Server running at $BaseURL"
    } else {
        Write-TestResult "Server startup" $false "Failed to start server"
        exit 1
    }
} else {
    Write-TestResult "Server status" $true "Server already running at $BaseURL"
}

# Step 2: Run API tests
Write-Host ""
Write-Host "[2/3] Running API endpoint tests..." -ForegroundColor Yellow

$passedTests = 0
$totalTests = $testCases.Length

foreach ($test in $testCases) {
    try {
        $uri = "$BaseURL$($test.Endpoint)"
        $params = @{
            Uri = $uri
            Method = $test.Method
            Headers = $test.Headers
            TimeoutSec = 30
        }
        
        if ($test.Body) {
            $params.Body = $test.Body | ConvertTo-Json -Depth 10
        }
        
        $response = Invoke-RestMethod @params
        
        if ($test.ExpectError) {
            Write-TestResult $test.Name $false "Expected error but got success"
        } else {
            # Check response structure
            $success = $true
            $details = ""
            
            if ($test.Endpoint -eq "/api/models") {
                $success = $response.data -and $response.data.Count -gt 0
                $details = "Found $($response.data.Count) models"
            } elseif ($test.Endpoint -eq "/api/chat") {
                $success = $response.choices -and $response.choices[0].message.content
                $content = $response.choices[0].message.content
                $details = "Response: $($content.Substring(0, [Math]::Min(50, $content.Length)))..."
            }
            
            Write-TestResult $test.Name $success $details
            if ($success) { $passedTests++ }
        }
        
    } catch {
        if ($test.ExpectError) {
            Write-TestResult $test.Name $true "Got expected error: $($_.Exception.Message)"
            $passedTests++
        } else {
            Write-TestResult $test.Name $false $_.Exception.Message
        }
    }
}

# Step 3: Test chatbot interface
Write-Host ""
Write-Host "[3/3] Testing chatbot interface..." -ForegroundColor Yellow

try {
    $chatbotResponse = Invoke-WebRequest -Uri "$BaseURL/chatbot.html" -TimeoutSec 10
    $chatbotWorks = $chatbotResponse.StatusCode -eq 200 -and $chatbotResponse.Content.Contains("AI Assistant")
    Write-TestResult "Chatbot HTML" $chatbotWorks "Status: $($chatbotResponse.StatusCode)"
} catch {
    Write-TestResult "Chatbot HTML" $false $_.Exception.Message
}

# Summary
Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "              Test Results" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Passed: $passedTests / $totalTests API tests" -ForegroundColor $(if ($passedTests -eq $totalTests) { "Green" } else { "Yellow" })

if ($passedTests -eq $totalTests) {
    Write-Host ""
    Write-Host "🎉 ALL TESTS PASSED!" -ForegroundColor Green
    Write-Host "Your API and chatbot are working perfectly!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Test your API with curl:" -ForegroundColor Cyan
    Write-Host 'curl -X POST "http://localhost:3001/api/chat" \' -ForegroundColor Gray
    Write-Host '  -H "Content-Type: application/json" \' -ForegroundColor Gray
    Write-Host '  -H "X-API-Key: aj-demo123456789abcdef" \' -ForegroundColor Gray
    Write-Host '  -d ''{"model": "qwen3:1.7b", "messages": [{"role": "user", "content": "hello"}], "stream": false}''' -ForegroundColor Gray
    Write-Host ""
    Write-Host "Access chatbot: $BaseURL/chatbot.html" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "⚠️  Some tests failed. Check the details above." -ForegroundColor Yellow
}

Write-Host "===========================================" -ForegroundColor Cyan

# Keep server running if we started it
if ($serverJob) {
    Write-Host ""
    Write-Host "Press Ctrl+C to stop the test server..." -ForegroundColor Yellow
    try {
        Wait-Job $serverJob
    } catch {
        # User pressed Ctrl+C
    } finally {
        Stop-Job $serverJob -ErrorAction SilentlyContinue
        Remove-Job $serverJob -ErrorAction SilentlyContinue
    }
}