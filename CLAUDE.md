# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**锦囊 (Jin-Nang)** — a Flutter Chinese-learning app targeting iOS, Android, Web, macOS, Linux, Windows. The pubspec name is still the scaffold default `test1`; do not assume it's renamed.

## Commands

```bash
# Daily dev (Nix devShell + direnv auto-loads when entering the directory)
flutter pub get
flutter run                  # default device
flutter run -d chrome        # Web
flutter run -d macos         # macOS desktop

# Quality gates
flutter analyze              # static analysis (flutter_lints)
flutter test                 # widget tests (only test/widget_test.dart today)
flutter test test/widget_test.dart -p "MyApp ..."   # single test by name

# Native splash regeneration (config in flutter_native_splash.yaml)
dart run flutter_native_splash:create
```

### iOS builds — non-standard

The Nix-packaged Flutter SDK does **not** include the full iOS engine framework. iOS device builds must use the Homebrew Flutter:

```bash
/opt/homebrew/Caskroom/flutter/*/flutter/bin/flutter build ios --debug --no-codesign
open ios/Runner.xcworkspace   # configure signing in Xcode, then Cmd+R
```

If regenerating the `ios/` directory: also `chmod -R u+w ios/` afterwards — Nix-created files are read-only and break pod installs.

`flake.nix` exports `DEVELOPER_DIR=/Applications/Xcode.app/...` and clears `SDKROOT` so Xcode resolves the real iOS SDK rather than Nix's minimal Apple SDK. Don't override these.

## Architecture

### Routing — go_router with StatefulShellRoute

`lib/main.dart` is the single source of truth for the route table. Three top-level full-screen routes (`/splash`, `/login`, `/register`) sit outside the shell. Everything else lives inside a `StatefulShellRoute.indexedStack` with three branches:

- **Study** (`/study/...`) — home, vocab scene selection, vocab learning, dialogue practice, individual levels
- **Toolbox** (`/toolbox/...`) — toolbox grid, Vocab Battle card
- **My** (`/me`) — profile

Each branch has its own `GlobalKey<NavigatorState>` so tabs preserve their navigation stack independently. Sub-page transitions use the `_slidePage` helper (right-slide) defined in `main.dart` — reuse it for new sub-routes instead of inventing per-screen transitions.

Current routes with path parameters:

| Path | Screen | Shell? |
|------|--------|--------|
| `/splash` | SplashScreen | ❌ |
| `/login` | LoginScreen | ❌ |
| `/register` | RegisterScreen | ❌ |
| `/study` | HomeScreen | Study tab |
| `/study/vocab-scene` | VocabSceneScreen | Study tab |
| `/study/vocab-learning/:sceneId` | VocabLearningScreen | Study tab |
| `/study/dialogue-practice/:sceneId` | DialoguePracticeScreen | Study tab |
| `/study/level/:levelId?sceneId=…` | LevelScreen | Study tab |
| `/toolbox` | ToolboxScreen | Toolbox tab |
| `/toolbox/vocab-card/:sceneId` | ToolboxCard | Toolbox tab |
| `/me` | ProfileScreen | My tab |

### Dependency injection

`lib/core/di.dart` provides a simple service-locator singleton `Di`:

- `Di.tokenStore` — `TokenStore` (flutter_secure_storage wrapper for JWT)
- `Di.api` — `ApiClient` (Dio + JWT inject/401-clear interceptor)
- `Di.audioCache` — `AudioCacheManager` (flutter_cache_manager for vocab audio)
- `Di.router` — set by `main.dart` after router creation, used by the 401 interceptor to redirect to `/login`

### Network layer (`lib/core/network/api_client.dart`)

Dio-based HTTP client pointing at `https://jntest.lonnet.uk`. On every request it injects `Authorization: Bearer <jwt>` from `TokenStore`. On 401 responses it clears the token and redirects to `/login` via `Di.router`.

API methods: `login()`, `register()`, `getMe()`, `getScenes()`, `getSceneVocab()`, `getVocabDetail()`, `getSceneLevels()`, `submitProgress()`.

### Feature-first layout under `lib/`

```
lib/
├── main.dart              # entry + router
├── theme/                 # design tokens (colors, fonts, spacing, ThemeData)
├── widgets/               # cross-feature reusable widgets
├── core/
│   ├── network/           # Dio client with JWT injection interceptor
│   ├── auth/              # TokenStore (flutter_secure_storage)
│   ├── audio/             # AudioCacheManager (flutter_cache_manager wrapper)
│   ├── models/            # UserProfile, Scene, VocabItem, VocabDetail, Level
│   └── di.dart            # service locator singleton
└── features/<feature>/    # screens grouped by product area
```

Feature folders are flat by default (`features/auth/login_screen.dart`); nested sub-features (e.g. `features/home/vocab_learning/`, `features/home/dialogue/`) appear when a feature has multiple screens.

### Theming

- `AppTheme.lightTheme` in `lib/theme/app_theme.dart` is wired into `MaterialApp.router`. There is no dark theme yet.
- `AppFonts` declares **two font families** with fallback: `Inter` for Latin glyphs, system default font for Chinese. Always set `fontFamily: AppFonts.english` with `fontFamilyFallback: [AppFonts.chinese]` (already done globally in the theme) — don't hardcode font families on individual `TextStyle`s.
- `AppColors` is the only place HEX values live. Two namespaces coexist: standard semantic (`brandPurple`, `semanticRed`, `neutralGray0X`) and the Figma-named Morandi palette (`morandiText`, `baliHai30`, `straw14`, `oldRose15`, …). Tabs in `MainShell` and feature screens use the Figma names.

### Visual language — thick-border + hard-shadow card system

Every card-like surface follows the same primitive: black ~2.5–4px border, offset solid-color drop shadow (no blur), large rounded corners, pastel Morandi fills. The reusable building blocks are:

- `widgets/app_card.dart` — base card container
- `widgets/app_header.dart` — back button + title tab + optional progress counter
- `widgets/icon_container.dart` — bordered icon tile, multiple sizes
- `widgets/selectable_card.dart` — scene/tool card; **disabled state = `onTap == null`** (no separate `enabled` flag), per the project's design-system rule. `onLockedTap` handles locked-card taps separately (shows "coming soon").
- `widgets/pressable.dart` — universal tap wrapper providing the press feedback (offset + opacity dip), haptic, and SFX. Prefer `Pressable` over raw `GestureDetector`/`InkWell` for any interactive surface so press feedback stays consistent.

Press SFX comes from `ButtonSounds` (singleton in `pressable.dart`) playing `assets/audio/btn_pressed.mp3` / `btn_released.mp3`.

### Audio

Two categories with different storage and playback:

| 类别 | 存储 | 播放方式 |
|------|------|----------|
| 按钮音效（btn_pressed / btn_released） | App 包体 `assets/audio/` | `AssetSource` |
| 词汇音频（全部业务音频） | CF R2，按需下载 | `DeviceFileSource`（本地缓存后） |

`AssetSource` 路径相对于 `assets/` — 传 `'audio/btn_pressed.mp3'`，不含 `assets/` 前缀。词汇音频不再打包进 App，由 `AudioCacheManager`（`flutter_cache_manager` 封装）管理下载和缓存。注意：`DeviceFileSource` 在 Web 平台不可用。

### State management

- **Service locator**: `Di` singleton provides shared instances (`Di.api`, `Di.tokenStore`, `Di.audioCache`).
- **Screen state**: `StatefulWidget` + `setState` — no Riverpod/BLoC yet.
- **Auth token**: `flutter_secure_storage` via `TokenStore`, not SharedPreferences.
- **Data source**: screens fetch data from the backend API on `initState`; no local persistence layer.

## Conventions

- File names: `snake_case.dart`. Classes: `PascalCase`. Variables/methods/constants: `lowerCamelCase` (even for constants — `appSpacingMd`, not `APP_SPACING_MD`).
- Spacing values must come from `lib/theme/app_spacing.dart`, on the 4pt/8pt grid. No raw magic numbers for padding/margin.
- Strict Figma 1:1 alignment — colors, spacing, and component states come from Figma tokens, not designer-eye approximation in code.
- All interactive widgets carry their states from Figma Variants: `Default / Pressed / Disabled` (no `Hover` since mobile-only). Disabled = null callback.
- Commit messages follow Conventional Commits (`feat:`, `fix:`, `refactor:`, `perf:`, `chore:`, `docs:`).
- The project's design and Flutter coding rules are written up in `flutter规范.md` and `figma规范.md` at the repo root — read these for style decisions not covered here.

## Backend architecture

**Cloudflare Workers + D1 + R2** — all backend is deployed on Cloudflare:

- **Workers** (Hono): HTTP/HTTPS/WebSocket API, JWT auth
- **D1** (SQLite): all business data — users, scenes, vocab, levels, progress
- **R2**: vocab audio files (`audio/{scene}/{word}.mp3`)

DB stores `audio_key` as a relative path (e.g. `restaurant/rice.mp3`); the full URL is assembled by Workers at response time. The production API is at `https://jntest.lonnet.uk`.

### API surface

```
POST /auth/register   POST /auth/login    GET /auth/me
GET  /scenes          GET /scenes/:id/vocab
GET  /vocab/:id       GET /scenes/:id/levels
GET  /user/progress   POST /user/progress
GET  /audio/:scene/:file
```

All authenticated endpoints require `Authorization: Bearer <jwt>`. All backend code lives in `backend/` with its own README.md covering deployment, migrations, and local dev workflows.

### Backend commands (run from `backend/`)

```bash
wrangler deploy                    # deploy Worker
npm run dev                        # local dev server
wrangler d1 execute jin-nang-db --remote --file=migrations/000X_xxx.sql  # run migration
wrangler r2 object put jin-nang-audio/{scene}/{word}.mp3 -f <local.mp3> --remote  # upload audio
```

Never modify deployed DB tables directly — always create a new migration file under `backend/migrations/`, run it, update `schema.sql`, then redeploy.

## Project context docs

`业务逻辑文档和进度记录/business_logic.md` is the live spec — every screen's flow, route table, data models, API routes, audio architecture, and the full "未实现功能清单" (P0–P3). Check it before adding screens or changing flow. `progress.md` in the same folder tracks ongoing work.
