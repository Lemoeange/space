@echo off
cd /d "%~dp0"
git push -u origin main
echo.
echo === Done. If you see an error above, check network or auth. ===
pause
