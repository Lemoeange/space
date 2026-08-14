@echo off
chcp 65001 >nul
cd /d "%~dp0"
where git >nul 2>nul || (echo [错误] 未检测到 Git，请安装 Git 或用 GitHub Desktop。 & pause & exit /b)

git add -A
git commit -m "update" 2>nul
git push -u origin main
echo.
echo 完成。若推送失败，请检查网络或先合并远程改动。
pause
