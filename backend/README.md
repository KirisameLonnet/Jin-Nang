# 锦囊 Backend

Cloudflare Workers + D1 + R2。所有命令**在 `backend/` 目录下执行**。

## 技术栈

| 层 | 技术 | 说明 |
|----|------|------|
| 运行时 | Cloudflare Workers | 边缘计算，HTTP/WS |
| 框架 | Hono | 轻量路由 |
| 数据库 | Cloudflare D1 (SQLite) | 业务数据 |
| 对象存储 | Cloudflare R2 | 词汇音频 |
| 认证 | JWT (HS256, Web Crypto) | 30天有效期 |

## 目录结构

```
backend/
├── src/
│   ├── index.ts              # 入口 + 路由挂载
│   ├── types.ts              # Env / Variables 类型
│   ├── lib/
│   │   ├── crypto.ts         # PBKDF2 密码哈希
│   │   └── jwt.ts            # HS256 签发 / 校验
│   ├── middleware/
│   │   └── auth.ts           # JWT 鉴权中间件
│   └── routes/
│       ├── auth.ts           # POST /auth/register|login  GET /auth/me
│       ├── scenes.ts         # GET /scenes  /scenes/:id/vocab|levels
│       ├── vocab.ts          # GET /vocab/:id（Vocab Battle 详情）
│       ├── progress.ts       # GET|POST /user/progress
│       ├── vocab_seen.ts     # POST /user/vocab-seen
│       └── audio.ts          # GET /audio/:scene/:file（R2 代理）
├── migrations/
│   ├── 0001_initial.sql      # 初始表结构
│   └── 0006_complete_demo_backend.sql # 最新 Demo 数据模型
├── schema.sql                # 当前完整表结构（新环境一键建表用）
├── seed.sql                  # 初始词库数据
├── wrangler.toml             # Worker 配置
├── package.json
└── tsconfig.json
```

## API 路由

```
POST /auth/register           { email, password, display_name } → { token }
POST /auth/login              { email, password } → { token }
GET  /auth/me                 → 用户信息 + 统计

GET  /scenes                  → 场景列表
GET  /scenes/:id/vocab        → 场景词汇（学习卡，精简）
GET  /scenes/:id/phrases      → Toolbox 章节 + 常用语
GET  /scenes/:id/levels       → 关卡列表 + 题目 + 用户进度
GET  /vocab/:id               → 词汇详情（Vocab Battle）

GET  /user/progress           → 全部关卡进度
POST /user/progress           { level_id, score }（服务端计算 stars / 解锁）
POST /user/vocab-seen         { vocab_ids: number[] }

GET  /audio/:scene/:file      → 从 R2 流式返回音频
```

除 `/health`、`/auth/register`、`/auth/login` 和 `/audio/*` 外，接口均需要
`Authorization: Bearer <token>`。

---

## 日常开发工作流

### 修改 Worker 代码后部署

```bash
wrangler deploy
```

这是最常见的操作。修改任何 `src/` 下的 TypeScript 文件后运行。

### 数据库 Schema 变更

**永远不要直接修改已部署的表结构。** 流程：

1. 在 `migrations/` 下新建文件，命名为 `XXXX_描述.sql`：
   ```bash
   # 示例：新增用户头像字段
   touch migrations/0002_add_user_avatar.sql
   ```

2. 写入变更 SQL（只写增量，不要 DROP）：
   ```sql
   ALTER TABLE users ADD COLUMN avatar_url TEXT;
   ```

3. 同步更新 `schema.sql`（保持完整表结构为最新）

4. 先在本地应用并验证：
   ```bash
   npm run db:migrate:local
   ```

5. 获得明确上线授权并确认生产备份后，应用生产迁移：
   ```bash
   npm run db:migrate:prod
   ```

6. 重新部署 Worker（如果代码有变化）：
   ```bash
   wrangler deploy
   ```

### 添加新词库数据

```bash
# 写好 SQL INSERT 语句后
wrangler d1 execute jin-nang-db --remote --command "INSERT INTO scenes ..."

# 或放进文件批量执行
wrangler d1 execute jin-nang-db --remote --file=migrations/0003_add_supermarket_vocab.sql
```

### 上传音频文件到 R2

路径规则：`{bucket}/{scene}/{word}.mp3`，对应 DB 的 `audio_key` 字段。

```bash
wrangler r2 object put jin-nang-audio/{scene}/{word}.mp3 \
  -f ../assets/audio/{word}.mp3 --remote
```

新增场景时，把该场景所有词汇的 mp3 文件按此规则逐一上传。

### 管理 Secrets

```bash
# 查看已有 secret 列表
wrangler secret list

# 新增或更新
wrangler secret put SECRET_NAME

# 删除
wrangler secret delete SECRET_NAME
```

当前 Worker secrets：`JWT_SECRET`

**Secrets 不进 git，不写 wrangler.toml。**

### 本地开发

```bash
npm run dev          # 启动本地 Worker（使用本地 D1）
npm run typecheck    # TypeScript 严格检查

# 本地数据库初始化（仅首次）
npm run db:init:local
npm run db:seed:local
```

本地开发时音频接口会返回 404（R2 无本地模拟），不影响其他接口测试。

---

## 首次搭建新环境

```bash
# 1. 安装依赖
npm install
npm install -g wrangler
wrangler login

# 2. 创建 Cloudflare 资源
wrangler d1 create jin-nang-db          # 将输出的 database_id 填入 wrangler.toml
wrangler r2 bucket create jin-nang-audio

# 3. 设置 JWT 密钥
wrangler secret put JWT_SECRET          # 输入一个强随机字符串

# 4. 建表 + 写入初始数据（新环境）
wrangler d1 execute jin-nang-db --remote --file=schema.sql
wrangler d1 execute jin-nang-db --remote --file=seed.sql

# 5. 首次部署（获取 Worker URL）
wrangler deploy

# 6. 将 Worker URL 填入 wrangler.toml 的 WORKER_URL，再次部署
wrangler deploy

# 7. 上传音频（按场景逐一上传，见"上传音频文件到 R2"章节）

# 8. 将 Worker URL 更新到前端
# lib/core/network/api_client.dart → _baseUrl
```

## 验证部署

```bash
curl https://jin-nang-api.szfsy06.workers.dev/health
# → {"ok":true}
```

当前最新版上线顺序：确认生产 D1 状态和备份 → `npm run db:migrate:prod` →
`npm run typecheck` → `npm run deploy` → 执行注册、场景、短语、关卡、进度接口冒烟测试。
