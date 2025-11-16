# 彗星 Minecraft 启动器

这是一个定制化的 Minecraft 启动器项目，提供了便捷的一键启动、配置设置等功能。

## 项目简介

彗星启动器是一个 Windows 平台的 Minecraft 启动工具，支持多个 Minecraft 版本（包括 1.18 和 1.21.5-Fabric），提供了用户友好的配置界面和一键启动功能。

## 主要特性

- **一键启动**：通过 `启动mc（一键）.bat` 脚本，实现 Minecraft 的一键启动
- **配置管理**：通过 `设置.bat` 脚本管理游戏设置
- **多版本支持**：支持多个 Minecraft 版本（1.18, 1.21.5-Fabric）
- **全屏/窗口模式**：支持切换全屏和窗口模式
- **内存分配**：可自定义 JVM 内存分配
- **分辨率设置**：可自定义游戏分辨率
- **Java 版本管理**：内置 JDK 安装功能

## 文件结构

```
d:\1\
├── .minecraft/                # Minecraft 核心文件夹
│   ├── launcher_profiles.json # 启动器配置
│   ├── options.txt           # 游戏选项
│   ├── saves/               # 存档文件
│   ├── mods/                # Mod 文件
│   ├── resourcepacks/       # 资源包
│   └── versions/            # 游戏版本
├── 启动mc（一键）.bat        # 一键启动脚本
├── 设置.bat                 # 配置设置脚本
├── 彗星.ps1                 # PowerShell 启动脚本
├── game_settings.txt        # 游戏设置文件
├── install_jdk.exe          # JDK 安装程序
└── README.md               # 项目说明
```

## 使用方法

### 一键启动游戏

1. 双击运行 `启动mc（一键）.bat`
2. 脚本会自动清理冲突进程、安装 JDK 并启动 Minecraft

### 配置游戏设置

1. 双击运行 `设置.bat`
2. 按提示修改以下设置：
   - 用户名：游戏显示名称
   - 内存分配：例如 2048m, 4096m
   - 游戏分辨率：例如 800x600, 1920x1080
   - Java 路径：Java 运行时路径
   - 全屏模式：全屏或窗口模式

### PowerShell 启动

- `彗星.ps1`：用于启动 1.21.5-Fabric 版本的 PowerShell 脚本

## 默认配置

- **用户名**：wzm
- **内存分配**：4096m
- **分辨率**：1920x1080
- **全屏模式**：开启
- **Java 路径**：C:\Program Files\Microsoft\jdk-21.0.7.6-hotspot\bin\java.exe

## 技术细节

- 支持 Fabric 模组加载器
- 包含安全参数以防止 Log4Shell 漏洞
- 使用 G1GC 垃圾收集器优化性能

## 注意事项

- 确保以管理员权限运行批处理文件以获得最佳体验(在新版本中，这是自动的。)
- 启动器会自动清理冲突的 Java 进程
- 所有配置都保存在 `game_settings.txt` 文件中

## 故障排除

- 如果游戏无法启动，请检查 Java 路径是否正确
- 如果出现内存不足，请调整内存分配设置
- 如果遇到图形问题，请尝试调整分辨率设置

## 版本信息

- 启动器版本：3.6.15 (HMCL)
- 支持的 Minecraft 版本：1.18, 1.21.5-Fabric
- JDK 版本：21.0.7.6-hotspot
