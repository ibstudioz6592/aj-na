@echo off
title FIX DNS - Simple Instructions
color 0E
cls

echo.
echo ================================================================
echo          HOW TO FIX api.ajstudioz.dev DNS
echo ================================================================
echo.
echo You deleted the Vercel deployment (Good!)
echo Now you need to remove the old DNS record:
echo.
echo ================================================================
echo                    STEP-BY-STEP
echo ================================================================
echo.
echo 1. Open your browser and go to:
echo    https://dash.cloudflare.com
echo.
echo 2. Login and click on: ajstudioz.dev
echo.
echo 3. Click on: DNS (in left sidebar)
echo.
echo 4. Find the record for "api" or "api.ajstudioz.dev"
echo.
echo 5. Click the DELETE button (trash icon) for that record
echo.
echo 6. Wait 1-2 minutes for DNS to update
echo.
echo 7. Test with: TEST_API.ps1
echo.
echo ================================================================
echo.
echo After deleting the old record, the tunnel will work automatically!
echo Your tunnel is already configured for api.ajstudioz.dev
echo.
echo ================================================================
echo.
echo Press any key to open Cloudflare Dashboard...
pause > nul

start "" "https://dash.cloudflare.com"

echo.
echo Opening Cloudflare Dashboard...
echo Follow the steps above!
echo.
timeout /t 3
