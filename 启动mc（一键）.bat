@echo off
title Minecraft启动器

:: 检查管理员权限
>nul 2>&1 reg query "HKU\S-1-5-19" || (
    echo 请求管理员权限...
    powershell -Command "Start-Process cmd -ArgumentList '/c %0' -Verb RunAs"
    exit /b
)

:: 进程检查和清理
:CheckAndKillProcesses
echo 正在检查并清理冲突的Java进程...

:: 终止所有java.exe进程
taskkill /f /im "java.exe" >nul 2>&1

:: 终止所有包含"java"的进程，使用wmic来确保
for /f "skip=1 tokens=1" %%a in ('wmic process where "name like '%%java%%'" get processid 2^>nul') do (
    taskkill /f /pid %%a >nul 2>&1
)

:: 终止可能冲突的cmd进程，除了当前进程
for /f "skip=1 tokens=1,2" %%a in ('wmic process where "name='cmd.exe'" get processid,commandline 2^>nul') do (
    echo %%b | findstr /c:"%~f0" >nul
    if errorlevel 1 (
        taskkill /f /pid %%a >nul 2>&1
    )
)

:: 检查是否还有Java进程在运行
tasklist /fi "imagename eq java.exe" | find /i "java.exe" >nul
if %errorlevel% equ 0 (
    echo 检测到还有Java进程在运行，等待3秒后重试...
    timeout /t 3 /nobreak >nul
    goto CheckAndKillProcesses
)

echo 进程清理完成。
echo.

:: 强制设置文件路径为D:\1文件夹
set SETTINGS_FILE=D:\1\game_settings.txt
set DEFAULT_USERNAME=wzm
set DEFAULT_MEMORY=3342m
set DEFAULT_RESOLUTION=854x480
set DEFAULT_JAVA_PATH="C:\Program Files\Microsoft\jdk-21.0.7.6-hotspot\bin\java.exe"
set DEFAULT_FULLSCREEN=false

:: 读取设置文件
if exist "%SETTINGS_FILE%" (
    for /f "usebackq tokens=1,* delims==" %%a in ("%SETTINGS_FILE%") do (
        if "%%a"=="USERNAME" set USERNAME=%%b
        if "%%a"=="MEMORY" set MEMORY=%%b
        if "%%a"=="RESOLUTION" set RESOLUTION=%%b
        if "%%a"=="JAVA_PATH" set INST_JAVA=%%b
        if "%%a"=="FULLSCREEN" set FULLSCREEN=%%b
    )
)

:: 如果设置文件中没有用户名则使用默认值
if not defined USERNAME (
    set USERNAME=%DEFAULT_USERNAME%
    echo 未找到设置文件，使用默认用户名: %USERNAME%
    echo 请运行"设置.bat"来设置用户名
    echo.
) else (
    echo 读取设置文件用户名: %USERNAME%
    echo.
)

:: 如果没有设置内存则使用默认值
if not defined MEMORY (
    set MEMORY=%DEFAULT_MEMORY%
)

:: 如果没有设置分辨率则使用默认值
if not defined RESOLUTION (
    set RESOLUTION=%DEFAULT_RESOLUTION%
)

:: 如果没有设置Java路径则使用默认值
if not defined INST_JAVA (
    set INST_JAVA=%DEFAULT_JAVA_PATH%
)

:: 如果没有设置全屏模式则使用默认值
if not defined FULLSCREEN (
    set FULLSCREEN=%DEFAULT_FULLSCREEN%
)

:: 复制启动器到桌面
copy %0 C:\Users\Public\Desktop >nul 2>&1

echo 正在安装jdk，请稍后
"D:\1\install_jdk.exe"
echo jdk安装完成

:: 设置环境变量
set APPDATA=D:\1
set INST_NAME=1.18
set INST_ID=1.18
set INST_DIR=D:\1\.minecraft\versions\1.18
set INST_MC_DIR=D:\1\.minecraft

echo 等待游戏开始运行...
cd /D D:\1\.minecraft
echo 正在启动游戏中，请勿关闭本窗口。

:: 初始化重启尝试次数
set RESTART_ATTEMPT=0

:StartGame
set /a RESTART_ATTEMPT+=1

if %RESTART_ATTEMPT% gtr 3 (
    echo 启动失败次数过多，请检查系统设置
    pause
    exit /b 1
)

:: 解析分辨率设置
for /f "tokens=1,2 delims=x" %%a in ("%RESOLUTION%") do (
    set WIDTH=%%a
    set HEIGHT=%%b
)

:: 设置全屏参数
if "%FULLSCREEN%"=="true" (
    set FULLSCREEN_PARAM=--fullscreen
) else (
    set FULLSCREEN_PARAM=
)

:: 启动游戏
%INST_JAVA% -Xmx%MEMORY% -Dfile.encoding=GB18030 -Dstdout.encoding=GB18030 -Dstderr.encoding=GB18030 -Djava.rmi.server.useCodebaseOnly=true -Dcom.sun.jndi.rmi.object.trustURLcodebase=false -Dcom.sun.jndi.cosnaming.object.trustURLcodebase=false -Dlog4j2.formatMsgNoLookups=true -Dlog4j.configurationFile=D:\1\.minecraft\versions\1.18\log4j2.xml -Dminecraft.client.jar=.minecraft\versions\1.18\1.18.jar -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32m -XX:-UseAdaptiveSizePolicy -XX:-OmitStackTraceInFastThrow -XX:-DontCompileHugeMethods -Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true -XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe.heapdump -Djava.library.path=D:\1\.minecraft\versions\1.18\natives-windows-x86_64 -Dminecraft.launcher.brand=HMCL -Dminecraft.launcher.version=3.6.12 -cp D:\1\.minecraft\libraries\com\mojang\blocklist\1.0.6\blocklist-1.0.6.jar;D:\1\.minecraft\libraries\com\mojang\patchy\2.1.6\patchy-2.1.6.jar;D:\1\.minecraft\libraries\com\github\oshi\oshi-core\5.8.2\oshi-core-5.8.2.jar;D:\1\.minecraft\libraries\net\java\dev\jna\jna\5.9.0\jna-5.9.0.jar;D:\1\.minecraft\libraries\net\java\dev\jna\jna-platform\5.9.0\jna-platform-5.9.0.jar;D:\1\.minecraft\libraries\org\slf4j\slf4j-api\1.8.0-beta4\slf4j-api-1.8.0-beta4.jar;D:\1\.minecraft\libraries\org\apache\logging\log4j\log4j-slf4j18-impl\2.14.1\log4j-slf4j18-impl-2.14.1.jar;D:\1\.minecraft\libraries\com\ibm\icu\icu4j\69.1\icu4j-69.1.jar;D:\1\.minecraft\libraries\com\mojang\javabridge\1.2.24\javabridge-1.2.24.jar;D:\1\.minecraft\libraries\net\sf\jopt-simple\jopt-simple\5.0.4\jopt-simple-5.0.4.jar;D:\1\.minecraft\libraries\io\netty\netty-all\4.1.68.Final\netty-all-4.1.68.Final.jar;D:\1\.minecraft\libraries\com\google\guava\failureaccess\1.0.1\failureaccess-1.0.1.jar;D:\1\.minecraft\libraries\com\google\guava\guava\30.0-jre\guava-30.0-jre.jar;D:\1\.minecraft\libraries\org\apache\commons\commons-lang3\3.12.0\commons-lang3-3.12.0.jar;D:\1\.minecraft\libraries\org\apache\commons\commons-collections4\4.4\commons-collections4-4.4.jar;D:\1\.minecraft\libraries\org\apache\httpcomponents\httpclient\4.5.13\httpclient-4.5.13.jar;D:\1\.minecraft\libraries\org\apache\httpcomponents\httpcore\4.4.14\httpcore-4.4.14.jar;D:\1\.minecraft\libraries\commons-codec\commons-codec\1.15\commons-codec-1.15.jar;D:\1\.minecraft\libraries\org\apache\logging\log4j\log4j-api\2.14.1\log4j-api-2.14.1.jar;D:\1\.minecraft\libraries\org\apache\logging\log4j\log4j-core\2.14.1\log4j-core-2.14.1.jar;D:\1\.minecraft\libraries\com\mojang\authlib\3.2.32\authlib-3.2.32.jar;D:\1\.minecraft\libraries\org\apache\commons\commons-compress\1.21\commons-compress-1.21.jar;D:\1\.minecraft\libraries\org\apache\httpcomponents\httpmime\4.5.13\httpmime-4.5.13.jar;D:\1\.minecraft\libraries\commons-io\commons-io\2.11.0\commons-io-2.11.0.jar;D:\1\.minecraft\libraries\com\mojang\brigadier\1.0.18\brigadier-1.0.18.jar;D:\1\.minecraft\libraries\com\mojang\datafixerupper\4.1.27\datafixerupper-4.1.27.jar;D:\1\.minecraft\libraries\com\google\code\gson\gson\2.8.8\gson-2.8.8.jar;D:\1\.minecraft\libraries\com\mojang\text2speech\1.11.3\text2speech-1.11.3.jar;D:\1\.minecraft\libraries\org\lwjgl\lwjgl\3.3.1\lwjgl-3.3.1.jar;D:\1\.minecraft\libraries\org\lwjgl\lwjgl-jemalloc\3.3.1\lwjgl-jemalloc-3.3.1.jar;D:\1\.minecraft\libraries\org\lwjgl\lwjgl-openal\3.3.1\lwjgl-openal-3.3.1.jar;D:\1\.minecraft\libraries\org\lwjgl\lwjgl-opengl\3.3.1\lwjgl-opengl-3.3.1.jar;D:\1\.minecraft\libraries\org\lwjgl\lwjgl-glfw\3.3.1\lwjgl-glfw-3.3.1.jar;D:\1\.minecraft\libraries\org\lwjgl\lwjgl-stb\3.3.1\lwjgl-stb-3.3.1.jar;D:\1\.minecraft\libraries\org\lwjgl\lwjgl-tinyfd\3.3.1\lwjgl-tinyfd-3.3.1.jar;D:\1\.minecraft\libraries\com\mojang\minecraft\1.18\minecraft-1.18-client.jar net.minecraft.client.main.Main --username %USERNAME% --version 1.18 --gameDir . --assetsDir .\.minecraft\assets --assetIndex 1.18 --uuid 00000000-0000-0000-0000-000000000000 --accessToken 0 --clientId 0 --xuid 0 --userType legacy --versionType release --width %WIDTH% --height %HEIGHT% %FULLSCREEN_PARAM%

:: 检查游戏是否异常退出
if %errorlevel% neq 0 (
    echo.
    echo 游戏异常退出，错误代码: %errorlevel%
    echo 正在清理进程并尝试重启...
    
    :: 清理进程
    call :CleanupProcesses
    
    echo 等待3秒后重新启动游戏...
    timeout /t 3 /nobreak >nul
    goto StartGame
)

echo 游戏已正常退出，请按任意键关闭本窗口。
pause
exit /b

:: 清理进程函数
:CleanupProcesses
echo 正在清理进程...
taskkill /f /im "java.exe" >nul 2>&1
for /f "skip=1 tokens=1" %%a in ('wmic process where "name like '%%java%%'" get processid 2^>nul') do (
    taskkill /f /pid %%a >nul 2>&1
)
goto :eof