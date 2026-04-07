# 锦囊 (Jin-Nang)

> Developed by SHUers — 一款中文学习 App。

基于 Flutter 的跨平台应用，支持 iOS、Android、Web、macOS、Linux 和 Windows。

## 环境配置

在支持nix的平台上，推荐使用 **Nix Flakes** 管理开发环境，通过 `direnv` 自动激活。

### 前置要求

| 工具             | 用途              | 安装方式                                                          |
| ---------------- | ----------------- | ----------------------------------------------------------------- |
| Nix              | 开发环境管理      | [nix-installer](https://github.com/DeterminateSystems/nix-installer) |
| direnv           | 自动加载 Nix 环境 | `brew install direnv`                                           |
| Xcode            | iOS/macOS 构建    | App Store                                                         |
| Homebrew Flutter | iOS 真机构建      | `brew install --cask flutter`                                   |

### 首次设置

```bash
# 1. 克隆项目后，允许 direnv 加载环境
direnv allow

# 2. 确认 Xcode 命令行工具指向正确
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# 3. 获取依赖
flutter pub get
```

## 运行项目

### Web / Android / macOS / Linux（使用 Nix Flutter）

在项目目录下直接运行：

```bash
flutter run -d chrome    # Web
flutter run -d macos     # macOS 桌面
flutter run               # 默认连接的设备
```

### iOS 真机（使用 Homebrew Flutter）

> ⚠️ **重要**：Nix 打包的 Flutter SDK 不包含完整的 iOS 引擎框架，iOS 真机构建必须使用 Homebrew 安装的系统 Flutter。

```bash
# 1. 用 Homebrew Flutter 构建
/opt/homebrew/Caskroom/flutter/*/flutter/bin/flutter build ios --debug --no-codesign

# 2. 打开 Xcode 配置签名并运行
open ios/Runner.xcworkspace
```

在 Xcode 中：

1. 选择 **Runner** target → **Signing & Capabilities**
2. 勾选 **Automatically manage signing**
3. **Team** 选择你的 Apple ID
4. 选择你的 iPhone 作为目标设备 → `Cmd + R` 运行

如果需要重新生成 iOS 项目：

```bash
rm -rf ios build
/opt/homebrew/Caskroom/flutter/*/flutter/bin/flutter create --platforms=ios .
chmod -R u+w ios/         # 修复 Nix 创建的只读权限
flutter pub get
```

## Nix 环境说明

`flake.nix` 提供了完整的跨平台开发工具链，并自动修复以下 Nix 与 Xcode 的环境冲突：

- **`DEVELOPER_DIR`**：重定向到真实的 Xcode.app（Nix 默认指向精简版 Apple SDK）
- **`SDKROOT`**：清空此变量（Nix 默认锁定为自带的 macOS SDK，阻止 iOS SDK 解析）

## 设计规范

- **Figma 协作规范**：见 [`figma规范.md`](figma规范.md)
- **Flutter 编码规范**：见 [`flutter规范.md`](flutter规范.md)
- **基准网格**：4pt / 8pt 间距系统
- **色彩系统**：语义化命名，支持 Light/Dark 模式
