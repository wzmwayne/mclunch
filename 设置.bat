@echo off
chcp 65001 >nul
title mclunch设置

echo ================================
echo      mclunch设置
echo ================================
echo.
echo 官网: wzmwayne.github.io/mclunch
echo.

:: 强制设置文件路径
set SETTINGS_FILE=D:\1\game_settings.txt

:: 检查D:\1目录是否存在，如果不存在则创建
if not exist "D:\1" (
    echo 创建目录 D:\1...
    mkdir "D:\1"
)

:: 读取现有设置
if exist "%SETTINGS_FILE%" (
    for /f "tokens=1,* delims==" %%a in (%SETTINGS_FILE%) do (
        if "%%a"=="USERNAME" set CURRENT_USERNAME=%%b
        if "%%a"=="MEMORY" set CURRENT_MEMORY=%%b
        if "%%a"=="RESOLUTION" set CURRENT_RESOLUTION=%%b
        if "%%a"=="JAVA_PATH" set CURRENT_JAVA_PATH=%%b
        if "%%a"=="FULLSCREEN" set CURRENT_FULLSCREEN=%%b
    )
)

:: 显示当前设置
echo 当前设置:
if defined CURRENT_USERNAME (
    echo [1] 用户名: %CURRENT_USERNAME%
) else (
    echo [1] 用户名: 未设置
)

if defined CURRENT_MEMORY (
    echo [2] 内存分配: %CURRENT_MEMORY%
) else (
    echo [2] 内存分配: 未设置 (默认)
)

if defined CURRENT_RESOLUTION (
    echo [3] 游戏分辨率: %CURRENT_RESOLUTION%
) else (
    echo [3] 游戏分辨率: 未设置 (默认)
)

if defined CURRENT_JAVA_PATH (
    echo [4] Java路径: %CURRENT_JAVA_PATH%
) else (
    echo [4] Java路径: 未设置 (默认)
)

if defined CURRENT_FULLSCREEN (
    echo [5] 全屏模式: %CURRENT_FULLSCREEN%
) else (
    echo [5] 全屏模式: 未设置 (默认窗口模式)
)

echo.
echo [0] 保存并退出
echo.

:: 获取用户选择
:MenuLoop
set /p USER_CHOICE=请选择要修改的选项 (0-5): 

:: 处理用户选择
if "%USER_CHOICE%"=="0" goto SaveAndExit
if "%USER_CHOICE%"=="1" goto SetUsername
if "%USER_CHOICE%"=="2" goto SetMemory
if "%USER_CHOICE%"=="3" goto SetResolution
if "%USER_CHOICE%"=="4" goto SetJavaPath
if "%USER_CHOICE%"=="5" goto SetFullscreen

echo 无效选择，请输入 0-5 之间的数字。
echo.
goto MenuLoop

:SetUsername
echo.
set /p NEW_USERNAME=请输入新的游戏用户名: 
if "%NEW_USERNAME%"=="" (
    echo 错误：用户名不能为空！
    pause
) else (
    set CURRENT_USERNAME=%NEW_USERNAME%
)
echo.
goto ShowMenu

:SetMemory
echo.
set /p NEW_MEMORY=请输入内存分配 (例如 2048m, 4096m): 
set CURRENT_MEMORY=%NEW_MEMORY%
echo.
goto ShowMenu

:SetResolution
echo.
set /p NEW_RESOLUTION=请输入游戏分辨率 (例如 800x600, 1920x1080): 
set CURRENT_RESOLUTION=%NEW_RESOLUTION%
echo.
goto ShowMenu

:SetJavaPath
echo.
set /p NEW_JAVA_PATH=请输入Java路径 (例如 "C:\Program Files\Java\jdk-17\bin\java.exe"): 
set CURRENT_JAVA_PATH=%NEW_JAVA_PATH%
echo.
goto ShowMenu

:SetFullscreen
echo.
echo 请选择全屏模式:
echo [1] 全屏模式
echo [2] 窗口模式
set /p FULLSCREEN_CHOICE=请选择 (1 或 2): 
if "%FULLSCREEN_CHOICE%"=="1" (
    set CURRENT_FULLSCREEN=true
) else if "%FULLSCREEN_CHOICE%"=="2" (
    set CURRENT_FULLSCREEN=false
) else (
    echo 无效选择，保持当前设置
)
echo.
goto ShowMenu

:ShowMenu
:: 显示当前设置
cls
echo ================================
echo      mclunch设置
echo ================================
echo.
echo 官网: wzmwayne.github.io/mclunch
echo.
echo 当前设置:
if defined CURRENT_USERNAME (
    echo [1] 用户名: %CURRENT_USERNAME%
) else (
    echo [1] 用户名: 未设置
)

if defined CURRENT_MEMORY (
    echo [2] 内存分配: %CURRENT_MEMORY%
) else (
    echo [2] 内存分配: 未设置 (默认)
)

if defined CURRENT_RESOLUTION (
    echo [3] 游戏分辨率: %CURRENT_RESOLUTION%
) else (
    echo [3] 游戏分辨率: 未设置 (默认)
)

if defined CURRENT_JAVA_PATH (
    echo [4] Java路径: %CURRENT_JAVA_PATH%
) else (
    echo [4] Java路径: 未设置 (默认)
)

if defined CURRENT_FULLSCREEN (
    echo [5] 全屏模式: %CURRENT_FULLSCREEN%
) else (
    echo [5] 全屏模式: 未设置 (默认窗口模式)
)

echo.
echo [0] 保存并退出
echo.
goto MenuLoop

:SaveAndExit
:: 验证必要设置
if "%CURRENT_USERNAME%"=="" (
    echo 错误：用户名不能为空！
    pause
    exit /b 1
)

:: 保存设置到D:\1文件夹
(
    echo USERNAME=%CURRENT_USERNAME%
    echo MEMORY=%CURRENT_MEMORY%
    echo RESOLUTION=%CURRENT_RESOLUTION%
    echo JAVA_PATH=%CURRENT_JAVA_PATH%
    echo FULLSCREEN=%CURRENT_FULLSCREEN%
) > "%SETTINGS_FILE%"

echo.
echo [成功] 设置已更新:
echo 用户名: %CURRENT_USERNAME%
echo 内存分配: %CURRENT_MEMORY%
echo 游戏分辨率: %CURRENT_RESOLUTION%
echo Java路径: %CURRENT_JAVA_PATH%
if "%CURRENT_FULLSCREEN%"=="true" (
    echo 全屏模式: 是
) else (
    echo 全屏模式: 否
)
echo 设置已保存到 %SETTINGS_FILE%
echo.
echo 下次启动游戏时将使用新设置。
echo.

pause