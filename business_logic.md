# 锦囊 (Jin Nang) — 业务逻辑文档

---

## 1. 产品概述

**锦囊** 是一款面向中文学习者的移动端应用，采用粗黑边框 + 硬阴影 + 莫兰迪色系的复古卡片视觉风格。核心玩法围绕「场景化学习」展开：用户选择生活场景（如餐厅点餐），先学习相关词汇，再通过闯关式对话练习巩固记忆。

### 1.1 核心循环

**Study 分支（学习流）：**
```
启动页 → 登录/注册 → 首页（Study Tab）
                    ↓
            点击 Vocab Learning → 场景选择页
                    ↓
            选择场景（Restaurant / Supermarket...）
                    ↓
            词汇学习（6张卡片，点击高亮 + 音频）
                    ↓
            对话练习（4关闯关模式）
                    ↓
            关卡结果（得分 + 星级 + 解锁下一关）
```

**Toolbox 分支（工具流）：**
```
首页（Toolbox Tab）
    ↓
选择场景卡片 → Vocab Battle（词汇详情页）
    ↓
Prev / Next 翻页，末页 Finish 返回 Toolbox
```

---

## 2. 页面结构与路由

### 2.1 路由表

| 路径 | 页面 | 底部导航 | Tab | 说明 |
|------|------|----------|-----|------|
| `/splash` | SplashScreen | ❌ | — | 启动页，3秒自动跳转 |
| `/login` | LoginScreen | ❌ | — | 登录 |
| `/register` | RegisterScreen | ❌ | — | 注册 |
| `/study` | HomeScreen | ✅ | Study | 学习首页 |
| `/study/vocab-scene` | VocabSceneScreen | ✅ | Study | 场景选择页 |
| `/study/vocab-learning` | VocabLearningScreen | ✅ | Study | 词汇学习（6词卡片） |
| `/study/dialogue-practice` | DialoguePracticeScreen | ✅ | Study | 关卡列表（4关） |
| `/study/level/:levelId` | LevelScreen | ✅ | Study | 具体关卡答题 |
| `/toolbox` | ToolboxScreen | ✅ | Toolbox | 工具箱 |
| `/toolbox/vocab-card` | ToolboxCard | ✅ | Toolbox | Vocab Battle（词汇详情） |
| `/me` | ProfileScreen | ✅ | My | 个人资料 |

### 2.2 导航规则

- **底部 Tab 切换**：使用 `StatefulShellRoute.indexedStack`，各 Tab 保持独立导航栈
  - Study Tab：学习首页 + 场景选择 + 词汇学习 + 对话练习 + 关卡
  - Toolbox Tab：工具箱 + Vocab Battle
  - My Tab：个人资料
- **子页面跳转**：使用 `context.go()`，支持返回
- **登录态**：Demo 版无真实鉴权，登录/注册后直接跳转 `/study`
- **返回规则**：各子页面通过 AppHeader 的返回按钮回到上一级

---

## 3. 各页面业务逻辑

### 3.1 启动页 (SplashScreen)

- **触发**：App 启动时自动显示
- **行为**：
  1. 显示 App Logo + 名称 + Slogan
  2. 3 秒后自动跳转到 `/login`
- **边界**：用户不可跳过，无交互按钮

### 3.2 登录页 (LoginScreen)

- **输入**：Email、Password
- **行为**：
  1. 点击 Sign In → 直接跳转 `/study`（Demo 无校验）
  2. 点击 "Sign Up" → 跳转 `/register`
  3. 密码支持显示/隐藏切换
- **边界**：
  - 空输入不拦截（Demo 版）
  - 无"忘记密码"功能

### 3.3 注册页 (RegisterScreen)

- **输入**：Name、Email、Password
- **行为**：
  1. 点击 Create Account → 直接跳转 `/study`
  2. 点击 "Sign In" → 跳转 `/login`
  3. 左上角返回按钮 → 跳转 `/login`
- **边界**：同登录页

### 3.4 首页 (HomeScreen)

- **内容**：
  - 欢迎区："Yo! Alex 👋" + "Ready to Level Up?"（蓝绿色小卡片）
  - 统计卡片：Streak（12 天）+ Rank（Gold）
  - 任务列表：Vocab Learning、Dialogue Practice（可点击跳转）
- **交互**：
  - 点击 Vocab Learning → `/study/vocab-scene`
  - 点击 Dialogue Practice → `/study/dialogue-practice`
- **边界**：统计数据为写死值，无真实用户数据

### 3.5 场景选择页 (VocabSceneScreen)

- **内容**：场景卡片列表
  - Restaurant（解锁，蓝色）
  - Supermarket（锁定，紫色）
- **交互**：
  - 点击 Restaurant → `/study/vocab-learning`
  - 锁定卡片：原色保留 + Opacity 0.35 罩灰 + 锁标，不可点击
- **边界**：锁定/解锁状态为写死值

### 3.6 词汇学习页 (VocabLearningScreen)

- **内容**：6 张词汇卡片（2×3 网格）
  - 米饭、面条、水、茶、饭店、吃
- **交互**：
  1. 点击卡片 → 背景高亮 0.2 秒 + 播放音频
  2. 已点击卡片显示绿色边框 + ✓ 图标
  3. 所有卡片点击后，底部按钮从禁用变为启用
  4. 点击 "学完了，去练习" → `/study/dialogue-practice`
  5. 返回按钮 → `/study/vocab-scene`
- **边界**：
  - 音频已接入 audioplayers
  - 快速连续点击同一卡片：只响应第一次
  - 离开页面后学习进度重置

### 3.7 Vocab Battle (ToolboxCard)

- **内容**：
  - 单词卡片：汉字（大字）+ 拼音 + 音量按钮（播放音频）
  - 词性标签 + 英文释义 + 中文释义（含拼音）
  - 例句区：2 条中英对照例句卡片
  - Toggle 按钮：关联词 / 短语 切换
  - 关联词列表：按近义/反义/拓展分类，带颜色标签
  - 短语列表：中英对照
  - 翻页导航：Previous / Next
- **交互**：
  1. 点击音量按钮 → 播放当前词音频
  2. Toggle 切换关联词 / 短语显示
  3. Previous / Next 翻页（2 个示例词）
  4. 末页显示 "Finish"，点击返回 Toolbox
  5. 返回按钮 → `/toolbox`
- **边界**：词汇数据为硬编码

### 3.8 对话练习页 (DialoguePracticeScreen)

- **内容**：4 个关卡卡片
  - Level 1: Vocab Match（已解锁，3星）
  - Level 2: Listen & Choose（已解锁，2星）
  - Level 3: Fill in Blanks（锁定）
  - Level 4: Challenge（锁定）
- **交互**：
  - 点击已解锁关卡 → `/study/level/:levelId`
  - 锁定关卡不可点击
  - 返回按钮 → `/study/vocab-learning`
- **边界**：星级和解锁状态为写死值

### 3.9 工具箱 (ToolboxScreen)

- **内容**：场景卡片列表
  - Restaurant（解锁，可点击 → Vocab Battle）
  - Supermarket（锁定）
  - Airport（锁定）
- **交互**：
  - 点击 Restaurant → `/toolbox/vocab-card`
  - 锁定卡片：原色保留 + Opacity 0.35 罩灰 + 锁标，不可点击
- **边界**：锁定/解锁状态为写死值

### 3.10 关卡页 (LevelScreen)

- **内容**：答题界面
  - 顶部栏：返回 + 关卡名称 + 进度
  - 进度条
  - 题目卡片
  - 选项按钮（A/B/C/D）
  - 反馈区（正确/错误 + 解释）
  - Next 按钮
- **交互**：
  1. 点击选项 → 显示对错 + 解释
  2. 正确选项绿色高亮，错误选项红色高亮
  3. 点击 Next → 下一题或结果页
  4. 结果页：显示得分、星级、通过/未通过
  5. 通过：显示 Continue + Retry
  6. 未通过：显示 Retry
- **计分规则**：
  - 正确率 ≥ 80%（第4关 100%）→ 通过
  - 星级：1-3 星根据正确率分配
- **边界**：
  - 题目数据为硬编码
  - 无生命值/限错机制
  - 无提示功能

### 3.11 个人资料页 (ProfileScreen)

- **内容**：
  - 资料卡片：头像 + 用户名 + 等级徽章
  - 统计行：连续天数 / 词汇量 / 平均分
  - 设置列表：Notifications、Language、Help
- **交互**：纯展示，无实际功能
- **边界**：所有数据为写死值

---

## 4. 数据模型

### 4.1 词汇数据（VocabLearningScreen）

```dart
class VocabItem {
  final String chinese;    // 汉字
  final String pinyin;     // 拼音
  final String english;    // 英文释义
  final String audioAsset; // 音频资源路径
}
```

### 4.2 Vocab Battle 数据模型（ToolboxCard）

```dart
class VocabWord {
  final String chinese;           // 汉字
  final String pinyin;            // 拼音
  final String partOfSpeech;      // 词性（如 n.）
  final String englishMeaning;    // 英文释义
  final String chineseMeaning;    // 中文释义
  final String chineseMeaningPinyin; // 中文释义拼音
  final List<Example> examples;   // 例句列表
  final List<RelatedWord> relatedWords; // 关联词列表
  final List<Phrase> phrases;     // 短语列表
  final String audioAsset;        // 音频资源路径
}

class Example {
  final String chinese;  // 中文例句
  final String pinyin;   // 例句拼音
  final String english;  // 英文翻译
}

class RelatedWord {
  final String type;     // synonym | antonym | expand
  final String chinese;  // 汉字
  final String pinyin;   // 拼音
  final String english;  // 英文释义
}

class Phrase {
  final String chinese;  // 中文短语
  final String english;  // 英文翻译
}
```

### 4.3 题目数据 (Question)

```dart
class Question {
  final String question;      // 题目文本
  final List<String> options; // 选项列表
  final int correctIndex;     // 正确答案索引
  final String explanation;   // 解释文本
}
```

### 4.4 关卡数据 (LevelData)

```dart
class LevelData {
  final int levelId;          // 关卡ID
  final String title;         // 标题
  final String subtitle;      // 副标题
  final List<Question> questions; // 题目列表
  final int passThreshold;    // 通过阈值（默认80%）
}
```

---

## 5. 状态管理

### 5.1 当前状态

- **页面级状态**：使用 `StatefulWidget` + `setState`
  - VocabCardScreen：当前词索引、toggle 状态
  - VocabLearningScreen：已点击卡片集合、高亮索引
  - LevelScreen：当前题索引、选中选项、正确数

### 5.2 待实现

- [ ] 用户登录态（Token/Session）
- [ ] 学习进度持久化（SharedPreferences/本地数据库）
- [ ] 关卡解锁状态
- [ ] 用户统计数据（streak、rank、词汇量）
- [ ] 设置项持久化

---

## 6. 音频系统

### 6.1 当前实现

- 已接入 `audioplayers: ^6.0.0`
- 词汇学习页：点击卡片播放对应音频（防重复点击）
- Vocab Battle：点击音量按钮播放当前词音频
- 错误静默处理，不影响用户体验

### 6.2 使用方式

```dart
final player = AudioPlayer();
await player.play(AssetSource('audio/rice.mp3'));
```

注意：`AssetSource` 路径不需要 `assets/` 前缀。

### 6.3 音频资源

```
assets/audio/
├── rice.mp3        // 米饭
├── noodle.mp3      // 面条
├── water.mp3       // 水
├── tea.mp3         // 茶
├── restaurant.mp3  // 饭店
├── eat.mp3         // 吃
└── ...
```

---

## 7. 未实现功能清单

| 功能 | 优先级 | 状态 | 说明 |
|------|--------|------|------|
| 用户认证 | P0 | ❌ | 登录/注册 API 对接 |
| 数据持久化 | P0 | ❌ | 学习进度、用户数据本地存储（SharedPreferences） |
| 音频播放 | P0 | ✅ | 已接入 audioplayers |
| 真实词汇数据库 | P1 | ❌ | 从硬编码迁移到 JSON/数据库 |
| 关卡解锁逻辑 | P1 | ❌ | 根据通关状态动态解锁 |
| 设置功能 | P2 | ❌ | 通知、语言切换等 |
| 排行榜 | P2 | ❌ | 用户排名 |
| 成就系统 | P2 | ❌ | 徽章、积分 |
| 深色模式 | P3 | ❌ | 主题切换 |
| 多语言支持 | P3 | ❌ | i18n |

## 8. 公共组件

| 组件 | 路径 | 说明 |
|------|------|------|
| AppCard | `widgets/app_card.dart` | 粗边框 + 硬阴影卡片容器 |
| AppHeader | `widgets/app_header.dart` | 返回按钮 + 标题标签 + 可选进度计数 |
| IconContainer | `widgets/icon_container.dart` | 带边框图标方块（多尺寸变体） |
| SelectableCard | `widgets/selectable_card.dart` | 场景/工具卡片，支持锁定态（onTap == null） |

---

## 9. 技术栈

### 前端（Flutter）

- **框架**：Flutter 3.x
- **状态管理**：StatefulWidget + setState（初期，待迁移到 Riverpod/BLoC）
- **路由**：go_router（StatefulShellRoute.indexedStack）
- **UI 风格**：粗黑边框 + 硬阴影 + 莫兰迪色系 + 大圆角
- **字体**：Inter（英文）+ 系统默认（中文）
- **图标**：本地 PNG（assets/icon/）
- **音频播放**：audioplayers
- **音频缓存**：flutter_cache_manager（词汇音频按需下载后缓存）
- **网络**：待接入（Dio 或 http）
- **本地存储**：不做本地持久化，数据全部走后端

### 后端（Cloudflare）

- **运行时**：Cloudflare Workers（HTTP/HTTPS/WebSocket，Hono 框架）
- **数据库**：Cloudflare D1（SQLite，Workers 原生 binding）
- **对象存储**：Cloudflare R2（词汇音频文件）
- **缓存层**：Cloudflare KV（可选，热点词库缓存）
- **认证**：JWT，由 Workers 签发和校验

---

## 10. 前后端数据划分

### 打包在 App 包体内（静态资源）

```
assets/
├── audio/
│   ├── btn_pressed.mp3     # 按钮按下音效（App 行为，非业务内容）
│   └── btn_released.mp3    # 按钮释放音效
├── fonts/                  # Inter + 系统默认
└── icon/                   # UI 图标
```

### 存储在后端（业务内容）

| 数据类型 | 来源 | 说明 |
|----------|------|------|
| 用户信息 | `GET /auth/me` | display_name, streak, rank, 统计 |
| 场景列表 | `GET /scenes` | id, 名称, 颜色, 默认解锁状态 |
| 词汇列表 | `GET /scenes/:id/vocab` | 学习卡所需字段（精简） |
| 词汇详情 | `GET /vocab/:id` | Vocab Battle 所需（含例句/关联词/短语） |
| 关卡定义 | `GET /scenes/:id/levels` | 关卡元信息 + 题目数据 |
| 用户进度 | `GET /user/progress` | 各关卡星级 + 解锁状态 |
| 词汇音频 | CF R2，路径存于 `audio_key` 字段 | 首次播放时下载，缓存到本地 |

---

## 11. 后端 API 路由

```
POST /auth/register           注册
POST /auth/login              登录，返回 JWT
GET  /auth/me                 当前用户信息 + 统计

GET  /scenes                  场景列表
GET  /scenes/:id/vocab        场景词汇（学习卡，精简版）
GET  /vocab/:id               词汇详情（Vocab Battle，含扩展数据）

GET  /scenes/:id/levels       关卡列表 + 题目
GET  /user/progress           当前用户全部关卡进度
POST /user/progress           提交关卡结果（stars, score）
```

所有需要鉴权的接口均携带 `Authorization: Bearer <jwt>`。

---

## 12. 音频系统

### 分类

| 类别 | 存储位置 | 播放方式 |
|------|----------|----------|
| 按钮音效（btn_pressed / btn_released） | App 包体 | `AssetSource`，直接播放 |
| 词汇音频（全部业务音频） | CF R2 | 下载后缓存，`DeviceFileSource` 播放 |

### 词汇音频缓存流程

```
App 收到词汇数据（含 audio_key: "restaurant/rice.mp3"）
    │
    ▼
进入 VocabSceneScreen 后后台预加载该场景全部词汇音频
    │
    ├── 检查本地缓存（flutter_cache_manager）
    │       命中 → 直接使用缓存文件
    │       未命中 → GET /audio/restaurant/rice.mp3 下载并缓存
    │
    ▼
用户点击词卡 → DeviceFileSource(cachedFilePath) → 立即播放
```

### R2 路径规范

```
audio/
├── {scene_name}/
│   ├── {word}.mp3
│   └── ...
└── ...
```

DB 中 `audio_key` 只存相对路径（如 `restaurant/rice.mp3`），完整 URL 由 Workers 在响应时拼接。

---

## 13. 目录结构（目标架构）

当前前端缺少数据层和逻辑层，待接入后端时补全：

```
lib/
├── main.dart
├── theme/
├── widgets/
├── core/                         # 待建
│   ├── network/                  # HTTP Client（Dio）+ 拦截器（JWT 注入）
│   ├── audio/                    # 音频缓存管理（flutter_cache_manager 封装）
│   └── auth/                     # JWT 存储 + 刷新逻辑
└── features/
    ├── auth/
    │   ├── data/                  # 待建：AuthRepository + API 调用
    │   └── *_screen.dart
    ├── shell/
    ├── home/
    │   ├── data/                  # 待建：SceneRepository
    │   ├── vocab_learning/
    │   │   ├── data/              # 待建：VocabRepository
    │   │   └── *_screen.dart
    │   └── dialogue/
    │       ├── data/              # 待建：LevelRepository + ProgressRepository
    │       └── *_screen.dart
    ├── toolbox/
    │   ├── data/                  # 待建：同 VocabRepository（详情版）
    │   └── *_screen.dart
    └── profile/
        ├── data/                  # 待建：UserRepository
        └── *_screen.dart
```

---

## 7. 未实现功能清单（更新）

| 功能 | 优先级 | 状态 | 说明 |
|------|--------|------|------|
| 后端服务搭建（CF Workers + D1） | P0 | ❌ | 路由、DB、R2 |
| 用户认证（注册/登录/JWT） | P0 | ❌ | Workers 签发，Flutter 存储 |
| 场景/词汇/关卡数据 API | P0 | ❌ | 替换当前全部硬编码数据 |
| 词汇音频上传至 R2 | P0 | ❌ | 迁移现有 assets/audio/ |
| 前端网络层（Dio + JWT 拦截器） | P0 | ❌ | core/network/ |
| 前端数据层（Repository 各模块） | P0 | ❌ | core/audio/ + features/*/data/ |
| 用户进度提交与读取 | P1 | ❌ | 关卡星级、解锁状态 |
| 词汇音频缓存（flutter_cache_manager） | P1 | ❌ | 替换当前 AssetSource |
| 音频播放 | P0 | ✅ | audioplayers 已接入（按钮音效） |
| 关卡解锁逻辑 | P1 | ❌ | 由后端进度数据驱动 |
| 设置功能 | P2 | ❌ | 通知、语言切换 |
| 排行榜 | P2 | ❌ | |
| 成就系统 | P2 | ❌ | |
| 深色模式 | P3 | ❌ | |
| 多语言支持 | P3 | ❌ | |

---

*文档由 AI 生成，随项目迭代持续更新。*

**更新记录：**
- v1.1 (2026-05-14)：更新路由结构（Study/Toolbox Tab 分离）、新增 VocabSceneScreen、Vocab Battle 数据模型、音频系统接入、公共组件、目录结构
- v1.2 (2026-05-15)：确立前后端分离架构（CF Workers + D1 + R2）、明确前后端数据划分、定义 API 路由、音频缓存策略、目标目录结构、更新未实现功能清单
