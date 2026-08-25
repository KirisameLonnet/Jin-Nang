# 锦囊 (Jin-Nang)

Developed by SHUers. 面向中文学习者的跨平台移动应用，基于 Flutter，支持 iOS、Android、Web、macOS、Linux、Windows。

后端部署于 Cloudflare Workers，API 地址：`https://jntest.lonnet.uk`

在线 Web Demo：`https://jn.lonnet.uk`

---

## 环境配置

在支持 Nix 的平台上，推荐使用 **Nix Flakes** 管理开发环境，通过 `direnv` 自动激活。

### 前置要求

| 工具             | 用途              | 安装方式 |
|-----------------|-------------------|----------|
| Nix             | 开发环境管理      | [nix-installer](https://github.com/DeterminateSystems/nix-installer) |
| direnv          | 自动加载 Nix 环境 | `brew install direnv` |
| Xcode           | iOS/macOS 构建    | App Store |
| Homebrew Flutter | iOS 真机构建     | `brew install --cask flutter` |

### 首次设置

```bash
# 允许 direnv 加载 Nix 环境
direnv allow

# 确认 Xcode 命令行工具路径
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# 安装 Flutter 依赖
flutter pub get
```

---

## 运行

```bash
flutter run               # 默认设备
flutter run -d chrome     # Web
flutter run -d macos      # macOS 桌面
```

### Android

```bash
flutter build apk --debug    # 调试包，可直接安装
flutter build apk --release  # 发布包
```

### Web / Cloudflare Pages

线上地址：`https://jn.lonnet.uk`（Pages 默认域名：`https://jin-nang-web.pages.dev`）。

Cloudflare Pages 已连接 GitHub `master` 分支。每次推送后自动执行：

```bash
bash scripts/build_web_cf_pages.sh
```

构建输出目录为 `build/web`，PR 和非生产分支会生成预览部署。脚本固定使用 Flutter
`3.35.6`，可通过 `FLUTTER_VERSION`、`CF_FLUTTER_SDK_DIR` 和 `API_BASE_URL`
覆盖默认值。

需要手动部署时：

```bash
flutter build web --release \
  --dart-define=API_BASE_URL=https://jntest.lonnet.uk

cd backend
npx wrangler pages deploy ../build/web \
  --project-name=jin-nang-web \
  --branch=master
```

Cloudflare Pages Git 项目名为 `jin-nang-web`。`web/_redirects` 提供单页应用子路由回退。
旧的 Direct Upload 项目 `jin-nang` 保留为手动回退部署。

### iOS 真机

Nix 打包的 Flutter SDK 不含完整 iOS 引擎框架，iOS 真机构建须使用 Homebrew Flutter。

```bash
/opt/homebrew/Caskroom/flutter/*/flutter/bin/flutter build ios --debug --no-codesign
open ios/Runner.xcworkspace
```

在 Xcode 中选择 Runner target，配置签名，选择目标设备后运行。

如需重新生成 iOS 项目：

```bash
rm -rf ios build
/opt/homebrew/Caskroom/flutter/*/flutter/bin/flutter create --platforms=ios .
chmod -R u+w ios/
flutter pub get
```

---

## 项目结构

```
Jin-Nang/
├── lib/
│   ├── main.dart              # 入口 + go_router 路由表
│   ├── core/                  # 网络层、模型、鉴权、音频缓存
│   ├── theme/                 # 颜色、字体、间距、ThemeData
│   ├── widgets/               # 跨功能复用组件
│   └── features/              # 按功能模块划分的页面
│       ├── auth/
│       ├── home/
│       ├── toolbox/
│       └── profile/
├── backend/                   # Cloudflare Workers 后端
│   └── README.md              # 后端部署与维护文档
├── assets/
│   ├── audio/                 # 按钮音效（业务音频存 R2）
│   ├── fonts/                 # Inter + 系统默认中文字体
│   └── icon/
├── flutter规范.md
└── figma规范.md
```

---

## Nix 环境说明

`flake.nix` 自动修复 Nix 与 Xcode 的两处环境冲突：

- `DEVELOPER_DIR`：重定向到真实 Xcode.app，避免 Nix 精简 Apple SDK 干扰
- `SDKROOT`：清空此变量，允许 Xcode 正确解析 iOS SDK

---

## 设计规范

- Figma 协作规范：见 [`figma规范.md`](figma规范.md)
- Flutter 编码规范：见 [`flutter规范.md`](flutter规范.md)
- 基准网格：4pt / 8pt 间距系统
- 后端维护流程：见 [`backend/README.md`](backend/README.md)
