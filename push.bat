@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ========================================================
echo               Space 项目 GitHub 同步推送脚本
echo ========================================================
echo.

:: 检查本地仓库状态
git status --porcelain > "%TEMP%\git_status.tmp"
set HAS_CHANGES=0
for /f %%i in ("%TEMP%\git_status.tmp") do set HAS_CHANGES=1
del "%TEMP%\git_status.tmp" 2>nul

if "%HAS_CHANGES%"=="1" (
    echo [1/3] 发现未提交的改动，正在暂存并自动创建提交...
    git add -A
    for /f "tokens=1-4 delims=/:. " %%a in ("%date% %time%") do set TIMESTAMP=%%a-%%b-%%c_%%d
    git commit -m "Auto update: %TIMESTAMP%"
    echo.
) else (
    echo [1/3] 工作区干净，准备推送现有提交...
    echo.
)

:: 网络与代理配置检测
echo [2/3] 正在检查网络连接与代理通道...
set GIT_CMD=git -c http.sslBackend=openssl

:: 检查本机常用代理端口 (7897 / 7890)
netstat -ano | findstr "127.0.0.1:7897" >nul
if %errorlevel% equ 0 (
    echo [*] 检测到本地代理运行于 127.0.0.1:7897，自动挂载代理加速推送...
    set GIT_CMD=git -c http.sslBackend=openssl -c http.proxy="http://127.0.0.1:7897" -c https.proxy="http://127.0.0.1:7897"
    goto DO_PUSH
)
netstat -ano | findstr "127.0.0.1:7890" >nul
if %errorlevel% equ 0 (
    echo [*] 检测到本地代理运行于 127.0.0.1:7890，自动挂载代理加速推送...
    set GIT_CMD=git -c http.sslBackend=openssl -c http.proxy="http://127.0.0.1:7890" -c https.proxy="http://127.0.0.1:7890"
    goto DO_PUSH
)

:DO_PUSH
echo [3/3] 正在推送至 GitHub 远程仓库 (origin main)...
%GIT_CMD% push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo  [OK] 恭喜！代码与资源已成功同步推送到 GitHub！
    echo ========================================================
) else (
    echo.
    echo [!] 尝试直连推送重试一次...
    git push -u origin main
    if %errorlevel% equ 0 (
        echo.
        echo ========================================================
        echo  [OK] 恭喜！代码与资源已成功同步推送到 GitHub！
        echo ========================================================
    ) else (
        echo.
        echo ========================================================
        echo  [ERROR] 推送失败，请检查以下事项：
        echo   1. 若开启了网络代理软件（如 Clash/V2Ray），请确认已启动；
        echo   2. 检查 GitHub 账号认证权限或凭据；
        echo   3. 稍后重新双击运行此脚本。
        echo ========================================================
    )
)

echo.
pause
