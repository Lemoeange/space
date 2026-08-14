@echo off
chcp 65001 >nul
cd /d "%~dp0"
where git >nul 2>nul || (echo [错误] 未检测到 Git，请安装 Git 或用 GitHub Desktop。 & pause & exit /b)

git add -A
git commit -m "update" 2>nul
git push
echo.
echo 完成。若提示“远程仓库不存在”，请先执行一次：
echo    git remote add origin https://github.com/你的用户名/仓库名.git
echo 然后再双击本脚本。
pause
