# 锦囊开发进度

## 2026-08-25 — 最新 Demo 与 Cloudflare 后端收口

- 本地 `master` fast-forward 到上游 `7a73e20`。
- 补齐上游 Dialogue 新题型字段，移除 Flutter mock/fallback 题目。
- Restaurant 四关内容迁入 D1：5 / 4 / 3 / 4 题。
- 新增 Toolbox 短语数据表和 `GET /scenes/:id/phrases`。
- Restaurant Useful Phrases 4 章、19 句迁入 D1。
- 新增 `POST /user/vocab-seen`，词汇按用户去重记录。
- streak、total_words_seen、Rank、avg_score 改为服务端计算。
- `POST /user/progress` 由服务端校验得分、计算星级并解锁下一关。
- Flutter Toolbox、学习统计和关卡页接入新 API。
- API Base URL 支持 `--dart-define=API_BASE_URL=...`。
- 加固注册输入、密码校验、音频路径和密码哈希比较。
- Hono / Wrangler / Workers Types 更新，npm 生产依赖审计 0 漏洞。
- 修复脚手架 Counter 测试，新增 API 模型契约测试。
- 本地 D1 新建路径与 0001→0006 迁移路径验证通过。
- 本地 Worker 端到端链路验证通过。
- 生产 D1 已应用 0001→0006，迁移前 Time Travel 恢复书签已记录。
- Worker 已部署到 `jntest.lonnet.uk`（版本 `113a6e0f-2ec1-449b-be5d-fcaa73bb2db2`）。
- 线上冒烟验证通过：健康检查、CORS、鉴权、3 个场景、4 章/19 条短语及 5/4/3/4 题；临时测试账号已清理。
- Flutter Web Release 已部署到 Git 原生 Cloudflare Pages 项目 `jin-nang-web`。
- GitHub `master` 推送后由 Cloudflare Pages 自动执行 `scripts/build_web_cf_pages.sh` 并发布，首次自动构建验证成功。
- Web 生产域名 `https://jn.lonnet.uk` 已生效；DNS、HTTPS、首页、PWA 静态资源、SPA 子路由回退和真实 Chrome 渲染验证通过。
- Web 品牌信息和 Chrome 业务音频播放兼容已完成。
- Flutter ARB i18n 已覆盖 English / 简体中文，界面语言与中文学习内容的语言边界已统一。
- 应用默认跟随系统语言；登录/注册页与 Profile 均可切换语言，并使用 Secure Storage 记忆选择。
- 登录、导航、首页、场景、关卡、答题反馈、Toolbox、Profile 及鉴权错误文案已移除英中硬编码混排。
- Android / iOS 应用名称按系统语言显示 `Jin Nang` / `锦囊`，macOS 名称从脚手架 `test1` 修正为 `Jin Nang`。
- i18n Widget 测试、Flutter Analyze、全部测试、Release Web 构建及真实 Chrome 双语切换/刷新持久化验证通过。

## 当前阶段剩余外部事项

- Toolbox 19 条短语尚无 R2 音频；当前按钮为 Disabled。
- Supermarket、Airport 和设置/排行榜等属于下一阶段内容。
