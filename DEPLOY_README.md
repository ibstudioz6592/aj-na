# AJ MEOW - Auto Deploy Scripts

## 🚀 Quick Start

### Option 1: Simple Launcher (Recommended)
```bash
# Double-click or run:
LAUNCH_AJ_MEOW.bat
```

### Option 2: Direct Script Execution
```bash
# Batch Version (Windows)
AJ_MEOW.bat

# PowerShell Version (Cross-platform)
powershell -ExecutionPolicy Bypass -File AJ_MEOW.ps1
```

## 📋 What These Scripts Do

### 🔄 Auto-Deployment Process
1. **Clean Environment** - Stops any running services
2. **Install Dependencies** - Runs `npm install` to ensure latest packages
3. **Git Sync** - Pulls latest changes and prepares for auto-commit
4. **Start Ollama** - Launches local AI model server (optional)
5. **Proxy Server** - Starts the main application on port 3001
6. **LocalTunnel** - Creates public URL for Ollama access (optional) 
7. **GitHub Push** - Auto-commits and pushes changes
8. **Vercel Deploy** - Deploys to production automatically

### 🎯 Features
- ✅ **Auto Git Integration** - Commits and pushes changes automatically
- ✅ **Service Management** - Starts/stops all required services
- ✅ **Error Handling** - Graceful failure recovery
- ✅ **Heartbeat Monitoring** - Keeps services alive
- ✅ **Cross-Platform** - Works on Windows, Mac, Linux (PowerShell)
- ✅ **Flexible Options** - Skip components as needed

## 🛠️ Script Options

### AJ_MEOW.bat (Windows Batch)
- Simple, reliable Windows execution
- Automatic service startup and deployment
- Runs in continuous mode with heartbeat

### AJ_MEOW.ps1 (PowerShell Advanced)
```powershell
# Skip Ollama installation/startup
./AJ_MEOW.ps1 -SkipOllama

# Skip LocalTunnel (for local-only development)  
./AJ_MEOW.ps1 -SkipTunnel

# Skip Vercel deployment (development mode)
./AJ_MEOW.ps1 -SkipDeploy

# Combine options
./AJ_MEOW.ps1 -SkipOllama -SkipTunnel

# Verbose output for debugging
./AJ_MEOW.ps1 -Verbose
```

### LAUNCH_AJ_MEOW.bat (Interactive Launcher)
- **Option 1**: Basic batch script
- **Option 2**: Advanced PowerShell script
- **Option 3**: PowerShell with custom options
- **Option 4**: Quick deploy only (no local services)

## 🔧 Prerequisites

### Required
- **Node.js** (v18+) - [Download](https://nodejs.org/)
- **Git** - [Download](https://git-scm.com/)
- **Vercel CLI** - Installed automatically by script

### Optional
- **Ollama** - [Download](https://ollama.ai/download) (for local AI models)
- **PowerShell 7+** - [Download](https://github.com/PowerShell/PowerShell) (for cross-platform)

## 🌐 Service URLs

After running the script, your services will be available at:

- **Local Development**: http://localhost:3001
- **GitHub Repository**: https://github.com/tomo-academy/AJ-the-
- **Vercel Production**: Check deployment output for URL
- **LocalTunnel**: Dynamic URL shown in script output

## 📁 Generated Files

The scripts create/modify these files:
- `localtunnel_url.txt` - Temporary file with tunnel URL
- `vercel.json` - Updated with dynamic Ollama URL
- Git commits with timestamp

## 🐛 Troubleshooting

### Common Issues

**"package.json not found"**
- Make sure you're running the script from the project root directory

**"Git push failed"** 
- Check your SSH key setup: `ssh -T git@github.com`
- Verify repository permissions

**"Vercel deployment failed"**
- Run `vercel login` manually first
- Check if you have deployment permissions

**"Ollama not found"**
- Install from https://ollama.ai/download
- Or use `-SkipOllama` flag to continue without it

**"Port 3001 already in use"**
- The script attempts to kill existing processes
- Manually check: `netstat -ano | findstr :3001`

### Debug Mode

For detailed troubleshooting:
```powershell
./AJ_MEOW.ps1 -Verbose
```

## 🔒 Security Notes

- Scripts handle sensitive operations (Git, Vercel deployment)
- LocalTunnel creates temporary public URLs
- Ensure your `.env` files are in `.gitignore`
- Review auto-commit messages before production use

## 🚀 Production Deployment

For production environments:
1. Use `AJ_MEOW.ps1 -SkipTunnel -SkipOllama` 
2. Configure proper environment variables
3. Set up monitoring for the heartbeat system
4. Use proper CI/CD instead of auto-commit for critical systems

---

**Need Help?** Check the script output for detailed error messages and URLs.