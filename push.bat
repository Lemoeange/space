@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ================================================
echo   正在同步到 GitHub (Lemoeange/space) ...
echo   若弹出浏览器，请点 "Authorize / 授权" 登录
echo ================================================
echo.
git push -u origin main
echo.
echo ================================================
echo   完成。看上面的英文：
echo   - 出现 "up to date" 或 "[new branch]" = 推送成功
echo   - 提示 "authentication" = 去浏览器里授权后再试
echo   - 其他报错 = 复制发给我
echo ================================================
pause
