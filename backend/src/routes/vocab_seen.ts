import { Hono } from 'hono'
import { requireAuth } from '../middleware/auth'
import { refreshUserStats, touchStudyDay } from '../lib/user_stats'
import type { Env, Variables } from '../types'

const app = new Hono<{ Bindings: Env; Variables: Variables }>()

app.post('/', requireAuth, async (c) => {
  const body = await c.req.json<{ vocab_ids?: unknown }>().catch(() => null)
  if (!body || !Array.isArray(body.vocab_ids)) {
    return c.json({ error: 'vocab_ids must be an array' }, 400)
  }

  const vocabIds = [...new Set(body.vocab_ids.map(Number))]
  if (vocabIds.length === 0 || vocabIds.length > 100 ||
      vocabIds.some(id => !Number.isInteger(id) || id <= 0)) {
    return c.json({ error: 'vocab_ids must contain 1-100 positive integers' }, 400)
  }

  const userId = c.get('userId')
  const before = await c.env.DB.prepare(
    'SELECT COUNT(*) AS count FROM user_vocab_seen WHERE user_id = ?',
  ).bind(userId).first<{ count: number }>()

  const placeholders = vocabIds.map(() => '?').join(', ')
  await c.env.DB.prepare(`
    INSERT OR IGNORE INTO user_vocab_seen (user_id, vocab_id, seen_at)
    SELECT ?, id, datetime('now')
    FROM vocab
    WHERE id IN (${placeholders})
  `).bind(userId, ...vocabIds).run()

  await touchStudyDay(c.env.DB, userId)
  await refreshUserStats(c.env.DB, userId)

  const user = await c.env.DB.prepare(`
    SELECT total_words_seen, streak_days, rank
    FROM users
    WHERE id = ?
  `).bind(userId).first<{
    total_words_seen: number
    streak_days: number
    rank: string
  }>()

  return c.json({
    ok: true,
    newly_seen: Math.max(0, (user?.total_words_seen ?? 0) - (before?.count ?? 0)),
    total_words_seen: user?.total_words_seen ?? 0,
    streak_days: user?.streak_days ?? 0,
    rank: user?.rank ?? 'Bronze',
  })
})

export default app
