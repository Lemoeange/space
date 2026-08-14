@echo off
chcp 65001 >nul
cd /d "%~dp0"
title Minecraft Web 复刻 - 本地服务器

where node >nul 2>nul
if errorlevel 1 (
  echo.
  echo  [错误] 未检测到 Node.js。
  echo  请安装 Node.js（https://nodejs.org/），或改用命令行：
  echo      python -m http.server 8080
  echo  然后浏览器访问 http://localhost:8080
  echo.
  pause
  exit /b
)

node server.js
pause
