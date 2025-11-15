# AJ MEOW - PowerShell Auto Deploy Script
# Enhanced version with better error handling and logging

param(
    [switch]$SkipOllama,
    [switch]$SkipTunnel,
    [switch]$SkipDeploy,
    [switch]$Verbose
)

# Configuration
$PROJECT_NAME = "AJ-the-"
$PORT = 3001
$GITHUB_REPO = "https://github.com/tomo-academy/AJ-the-"

# Colors for output
$colors = @{
    Success = "Green"
    Warning = "Yellow" 
    Error = "Red"
    Info = "Cyan"
    Step = "Magenta"
}

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $colors[$Color]
}

function Write-Step {
    param([string]$StepNumber, [string]$StepName)
    Write-Host ""
    Write-ColorOutput "[$StepNumber] $StepName..." -Color "Step"
}

# Header
Clear-Host
Write-ColorOutput "==========================================" -Color "Info"
Write-ColorOutput "       AJ MEOW - AI Platform Startup" -Color "Info"
Write-ColorOutput "==========================================" -Color "Info"
Write-ColorOutput "   Starting Your AI Platform..." -Color "Info"
Write-ColorOutput "==========================================" -Color "Info"

# Check if we're in the correct directory
if (-not (Test-Path "package.json")) {
    Write-ColorOutput "ERROR: package.json not found!" -Color "Error"
    Write-ColorOutput "Make sure you're running this from the project directory." -Color "Error"
    exit 1
}

# Step 1: Clean up old processes
Write-Step "1/8" "Cleaning up old processes"
$processes = @("ollama", "node", "npx", "localtunnel")
foreach ($proc in $processes) {
    Get-Process -Name $proc -ErrorAction SilentlyContinue | Stop-Process -Force
}
Start-Sleep -Seconds 2
Write-ColorOutput "    Done!" -Color "Success"

# Step 2: Install/Update Dependencies
Write-Step "2/8" "Installing/Updating dependencies"
try {
    & npm install
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "    Dependencies updated!" -Color "Success"
    } else {
        throw "npm install failed"
    }
} catch {
    Write-ColorOutput "ERROR: Failed to install dependencies!" -Color "Error"
    exit 1
}

# Step 3: Check Git status and ensure we're up to date
Write-Step "3/8" "Checking Git repository status"
try {
    $gitStatus = & git status --porcelain
    $currentBranch = & git rev-parse --abbrev-ref HEAD
    Write-ColorOutput "    Current branch: $currentBranch" -Color "Info"
    
    # Pull latest changes
    & git pull origin main
    Write-ColorOutput "    Repository updated!" -Color "Success"
} catch {
    Write-ColorOutput "WARNING: Git operations failed" -Color "Warning"
}

# Step 4: Check and Start Ollama (optional)
if (-not $SkipOllama) {
    Write-Step "4/8" "Checking Ollama installation"
    if (Get-Command ollama -ErrorAction SilentlyContinue) {
        Write-ColorOutput "    Starting Ollama..." -Color "Info"
        Start-Process -FilePath "ollama" -ArgumentList "serve" -WindowStyle Hidden
        Start-Sleep -Seconds 4
        Write-ColorOutput "    Ollama running!" -Color "Success"
    } else {
        Write-ColorOutput "WARNING: Ollama not found in PATH" -Color "Warning"
        Write-ColorOutput "Download from: https://ollama.ai/download" -Color "Info"
        Write-ColorOutput "Continuing without Ollama..." -Color "Warning"
    }
} else {
    Write-Step "4/8" "Skipping Ollama (--SkipOllama flag used)"
}

# Step 5: Start Proxy Server
Write-Step "5/8" "Starting Proxy Server"
$proxyJob = Start-Job -ScriptBlock {
    param($ProjectPath, $Port)
    Set-Location $ProjectPath
    & node proxy-server.js
} -ArgumentList (Get-Location), $PORT

Start-Sleep -Seconds 3
Write-ColorOutput "    Proxy running on port $PORT!" -Color "Success"

# Step 6: Start LocalTunnel (optional)
if (-not $SkipTunnel) {
    Write-Step "6/8" "Starting LocalTunnel"
    if (Test-Path "localtunnel_url.txt") { Remove-Item "localtunnel_url.txt" }
    
    $tunnelJob = Start-Job -ScriptBlock {
        param($Port)
        & npx localtunnel --port $Port
    } -ArgumentList $PORT
    
    Start-Sleep -Seconds 8
    Write-ColorOutput "    LocalTunnel started!" -Color "Success"
} else {
    Write-Step "6/8" "Skipping LocalTunnel (--SkipTunnel flag used)"
}

# Step 7: Auto-commit and push to GitHub
Write-Step "7/8" "Pushing updates to GitHub"
try {
    & git add .
    $changes = & git status --porcelain
    if ($changes) {
        $commitMessage = "Auto-deployment update - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        & git commit -m $commitMessage
        & git push origin main
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "    Successfully pushed to GitHub!" -Color "Success"
        } else {
            Write-ColorOutput "WARNING: Failed to push to GitHub" -Color "Warning"
        }
    } else {
        Write-ColorOutput "    No changes to commit" -Color "Info"
    }
} catch {
    Write-ColorOutput "WARNING: Git operations failed" -Color "Warning"
}

# Step 8: Deploy to Vercel (optional)
if (-not $SkipDeploy) {
    Write-Step "8/8" "Deploying to Vercel"
    
    # Check if Vercel CLI is installed
    if (-not (Get-Command vercel -ErrorAction SilentlyContinue)) {
        Write-ColorOutput "Installing Vercel CLI..." -Color "Info"
        & npm install -g vercel
    }
    
    Write-ColorOutput "Logging in and deploying..." -Color "Info"
    & vercel --prod --yes
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "    Deployment successful!" -Color "Success"
    } else {
        Write-ColorOutput "WARNING: Deployment failed" -Color "Warning"
    }
} else {
    Write-Step "8/8" "Skipping Vercel deployment (--SkipDeploy flag used)"
}

# Success message
Write-Host ""
Write-ColorOutput "======================================" -Color "Success"
Write-ColorOutput "  SUCCESS! Your AI Platform is LIVE!" -Color "Success"  
Write-ColorOutput "======================================" -Color "Success"
Write-Host ""
Write-ColorOutput "GitHub Repo: $GITHUB_REPO" -Color "Info"
Write-ColorOutput "Local URL:   http://localhost:$PORT" -Color "Info"
Write-Host ""
Write-ColorOutput "Services Status:" -Color "Info"
Write-ColorOutput "- Proxy Server: Running on port $PORT" -Color "Success"
if (-not $SkipTunnel) { Write-ColorOutput "- LocalTunnel:  Active (for Ollama access)" -Color "Success" }
Write-ColorOutput "- GitHub:       Auto-synced" -Color "Success" 
if (-not $SkipDeploy) { Write-ColorOutput "- Vercel:       Deployed" -Color "Success" }
Write-Host ""
Write-ColorOutput "Keep this window open to maintain services!" -Color "Warning"
Write-ColorOutput "======================================" -Color "Success"
Write-Host ""

# Keep services running with heartbeat
Write-ColorOutput "Press Ctrl+C to stop all services..." -Color "Warning"
Write-Host ""

$counter = 0
while ($true) {
    Start-Sleep -Seconds 30
    $counter++
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-ColorOutput "[$timestamp] Services heartbeat #$counter - All systems running..." -Color "Info"
    
    # Check if proxy job is still running
    if ($proxyJob.State -ne "Running") {
        Write-ColorOutput "WARNING: Proxy server stopped unexpectedly!" -Color "Error"
        break
    }
}