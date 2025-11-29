@echo off
REM Production Deployment Script for AJ-NA AI Backend (Windows)
echo 🚀 Starting AJ-NA AI Backend Production Deployment...

REM Set production environment
set NODE_ENV=production

REM Install dependencies
echo 📦 Installing dependencies...
call npm ci

REM Build the application
echo 🏗️  Building application...
call npm run build

REM Deploy to Vercel
echo 🌐 Deploying to Vercel...
call vercel --prod

echo ✅ AI Backend deployment complete!
echo 🔗 URL: https://ajstudioz-ai-api.vercel.app
pause