import { Hono } from 'hono'
import { requireAuth } from '../middleware/auth'
import { refreshUserStats, touchStudyDay } from '../lib/user_stats'
import type { Env, Variables } from '../types'

const app = new Hono<{ Bindings: Env; Variables: Variables }>()

app.get('/', requireAuth, async (c) => {
  const rows = await c.env.DB
    .prepare('SELECT level_id, stars, best_score, is_unlocked, completed_at FROM user_level_progress WHERE user_id = ?')
    .bind(c.get('userId'))
    .all<{
      level_id: number
      stars: number
      best_score: number
      is_unlocked: number
      completed_at: string | null
    }>()
  return c.json(rows.results.map(row => ({
    ...row,
    is_unlocked: row.is_unlocked === 1,
  })))
})

app.post('/', requireAuth, async (c) => {
  const body = await c.req.json<{
    level_id?: unknown
    score?: unknown
  }>().catch(() => null)
  if (!body) return c.json({ error: 'Invalid JSON body' }, 400)

  const levelId = Number(body.level_id)
  const score = Number(body.score)
  if (!Number.isInteger(levelId) || levelId <= 0) {
    return c.json({ error: 'Invalid level_id' }, 400)
  }
  if (!Number.isFinite(score) || score < 0 || score > 100) {
    return c.json({ error: 'Score must be between 0 and 100' }, 400)
  }

  const userId = c.get('userId')
  const level = await c.env.DB.prepare(`
    SELECT
      l.scene_id, l.level_num, l.pass_threshold,
      COALESCE(p.is_unlocked, CASE WHEN l.level_num = 1 THEN 1 ELSE 0 END) AS is_unlocked
    FROM levels l
    LEFT JOIN user_level_progress p ON p.level_id = l.id AND p.user_id = ?
    WHERE l.id = ?
  `).bind(userId, levelId).first<{
    scene_id: number
    level_num: number
    pass_threshold: number
    is_unlocked: number
  }>()
  if (!level) return c.json({ error: 'Level not found' }, 404)
  if (level.is_unlocked !== 1) return c.json({ error: 'Level is locked' }, 403)

  const normalizedScore = Math.round(score)
  const passed = normalizedScore >= level.pass_threshold
  const stars = !passed ? 0 : normalizedScore >= 100 ? 3 : normalizedScore >= 90 ? 2 : 1

  await c.env.DB.prepare(`
    INSERT INTO user_level_progress (user_id, level_id, stars, best_score, is_unlocked, completed_at)
    VALUES (?, ?, ?, ?, 1, datetime('now'))
    ON CONFLICT(user_id, level_id) DO UPDATE SET
      stars = MAX(stars, excluded.stars),
      best_score = MAX(best_score, excluded.best_score),
      is_unlocked = 1,
      completed_at = excluded.completed_at
  `).bind(userId, levelId, stars, normalizedScore).run()

  if (passed) {
    await c.env.DB.prepare(`
      INSERT INTO user_level_progress (user_id, level_id, stars, best_score, is_unlocked)
      SELECT ?, id, 0, 0, 1
      FROM levels
      WHERE scene_id = ? AND level_num = ?
      ON CONFLICT(user_id, level_id) DO UPDATE SET is_unlocked = 1
    `).bind(userId, level.scene_id, level.level_num + 1).run()
  }

  await touchStudyDay(c.env.DB, userId)
  await refreshUserStats(c.env.DB, userId)

  return c.json({ ok: true, passed, stars, score: normalizedScore })
})

export default app
