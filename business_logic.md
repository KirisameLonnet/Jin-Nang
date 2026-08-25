# 锦囊（Jin Nang）业务逻辑与阶段状态

> 当前基线：上游 Demo `7a73e20` + Cloudflare 后端收口（2026-08-25）。

## 1. 当前阶段目标

本阶段交付一条可以真实演示的完整链路：

```text
注册/登录 → 选择餐厅场景 → 学习词汇并记录 → 对话闯关
         → 服务端保存成绩/解锁下一关 → Profile 展示实时统计
         → Toolbox 从 D1 加载常用语章节
```

Flutter 只保留 UI 图标、字体和按钮音效；用户、场景、词汇、题目、进度及
Toolbox 短语全部由 Cloudflare Workers API 提供。业务音频由 R2 提供：原生端下载到设备缓存后播放，Web 端通过 HTTPS URL 直接播放。

## 2. Flutter 路由

| 路径 | 页面 | 说明 |
|---|---|---|
| `/splash` | SplashScreen | 根据本地 JWT 决定登录或首页 |
| `/login` | LoginScreen | 真实登录 |
| `/register` | RegisterScreen | 真实注册 |
| `/study` | HomeScreen | 用户统计和学习入口 |
| `/study/vocab-scene` | VocabSceneScreen | 词汇场景 |
| `/study/vocab-learning/:sceneId` | VocabLearningScreen | 词汇学习、音频、学习记录 |
| `/study/vocab-battle/:sceneId` | ToolboxCard | 词汇详情 |
| `/study/dialogue-scene` | DialogueSceneScreen | 对话场景 |
| `/study/dialogue-practice/:sceneId` | DialoguePracticeScreen | 关卡列表和解锁状态 |
| `/study/level/:levelId` | LevelScreen | 四种题型答题 |
| `/study/level/:levelId/review` | ReviewScreen | 角色扮演复习 |
| `/toolbox` | ToolboxSceneScreen | Toolbox 场景 |
| `/toolbox/:sceneId` | ToolboxScreen | D1 短语章节 |
| `/toolbox/:sceneId/chapter/:index` | ToolboxChapterScreen | 章节短语 |
| `/me` | ProfileScreen | 用户资料、统计、退出 |

根页面使用 `StatefulShellRoute.indexedStack`；子页面为全屏滑入页面，不显示底部 Tab。

## 3. 后端架构

- Workers + Hono：HTTP API、鉴权、输入校验。
- D1：用户、场景、词汇、关卡、题目、进度、Toolbox 章节和短语。
- R2：`{scene}/{file}.mp3` 业务音频。
- JWT：HS256，30 天有效期，Flutter 使用 Secure Storage 保存。
- Flutter：Dio 自动注入 JWT；401 清理 token 并返回登录页。

API Base URL 默认 `https://jntest.lonnet.uk`，可通过 Flutter
`--dart-define=API_BASE_URL=...` 覆盖。

## 4. API

```text
GET  /health

POST /auth/register
POST /auth/login
GET  /auth/me

GET  /scenes
GET  /scenes/:id/vocab
GET  /scenes/:id/phrases
GET  /scenes/:id/levels
GET  /vocab/:id

GET  /user/progress
POST /user/progress
POST /user/vocab-seen

GET  /audio/:scene/:filename
```

除注册、登录、健康检查和音频外，业务接口均要求
`Authorization: Bearer <jwt>`。

### 学习记录

`POST /user/vocab-seen` 接受去重后的 `vocab_ids`。D1 使用复合主键保证同一用户、
同一词只计一次。服务端重新计算 `total_words_seen`，并刷新连续学习天数和 Rank。

当前 Rank 规则：

- Bronze：0–5 词
- Silver：6–49 词
- Gold：50–199 词
- Platinum：200 词及以上

### 关卡进度

`POST /user/progress` 只接受 `level_id` 和 0–100 的 `score`。是否通过、星级和下一关
解锁由服务端根据 `pass_threshold` 计算，不信任客户端提交的星级。通过后 80–89 分为
1 星、90–99 分为 2 星、100 分为 3 星。最佳成绩只升不降，
Profile 平均分由已完成关卡的最佳成绩重新计算。

## 5. 关卡内容

Restaurant 当前包含：

1. 词汇匹配：5 题。
2. 听力选择：4 题，复用 R2 中现有 `eat/tea/water/rice.mp3`。
3. 句子填空：3 题。
4. 点餐角色扮演：4 个连续对话回合。

API 会返回完整的 `question_type`、展示字段、音频 URL、历史对话、积分和关卡说明；
Flutter 不再使用 mock/fallback 题目。

## 6. Toolbox 内容

Restaurant 的 Useful Phrases 已迁入 D1：4 章、19 句。Flutter 根据
`GET /scenes/:id/phrases` 渲染，支持深链直接加载章节。

短语表预留 `audio_key`。当前 19 条短语尚未提供对应 R2 文件，因此音频按钮按设计以
Disabled 状态显示；上传音频并写入 `audio_key` 后，无需再改 Flutter。

## 7. 当前完成度

| 项目 | 状态 |
|---|---|
| 注册、登录、JWT、401 | ✅ |
| 场景、词汇、详情 API | ✅ |
| 四种关卡题型 API | ✅ |
| 服务端计分、进度和解锁 | ✅ |
| 词汇学习记录、streak、Rank、平均分 | ✅ |
| R2 词汇/听力音频 + 设备缓存 | ✅ |
| Toolbox 章节/短语 D1 化 | ✅ |
| Toolbox 短语音频内容 | ⏳ 等待 19 个音频文件 |
| Supermarket / Airport 内容 | ⏳ 后续阶段 |
| English / 简体中文 i18n、跟随系统、语言选择持久化 | ✅ |
| Profile 编辑、通知、FAQ | ⏳ 后续阶段 |
| 排行榜、成就、深色模式 | ⏳ 后续阶段 |

## 8. 验收门禁

- `flutter analyze`
- `flutter test`
- `cd backend && npm run typecheck`
- `cd backend && npm audit --omit=dev`
- 临时本地 D1 执行 `schema.sql + seed.sql`
- 临时本地 D1 执行 `0001 → 0006` 迁移链
- 本地 Worker 端到端验证注册、鉴权、内容读取、学习记录、进度、解锁与 Profile

## 9. 部署边界

代码完成不等于线上已更新。正式上线前必须先备份/确认 D1，再按顺序应用迁移，最后部署
Worker。生产写入和部署必须由仓库维护者明确授权后执行。
