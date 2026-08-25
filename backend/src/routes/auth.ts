import { Hono } from 'hono'
import { signJwt } from '../lib/jwt'
import { hashPassword, verifyPassword } from '../lib/crypto'
import { requireAuth } from '../middleware/auth'
import type { Env, Variables } from '../types'

const app = new Hono<{ Bindings: Env; Variables: Variables }>()
const tokenTtl = 60 * 60 * 24 * 30
const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

function makeToken(userId: number, secret: string) {
  return signJwt({ sub: userId, exp: Math.floor(Date.now() / 1000) + tokenTtl }, secret)
}

function rankToLabel(rank: string): string {
  const map: Record<string, string> = {
    Bronze: 'Beginner',
    Silver: 'Elementary Learner',
    Gold: 'Intermediate Learner',
    Platinum: 'Advanced Learner',
  }
  return map[rank] ?? 'Learner'
}

app.post('/register', async (c) => {
  const body = await c.req.json<{
    email?: unknown
    password?: unknown
    display_name?: unknown
  }>().catch(() => null)
  if (!body) return c.json({ error: 'Invalid JSON body' }, 400)

  const email = typeof body.email === 'string' ? body.email.trim().toLowerCase() : ''
  const password = typeof body.password === 'string' ? body.password : ''
  const displayName = typeof body.display_name === 'string' ? body.display_name.trim() : ''
  if (!emailPattern.test(email)) return c.json({ error: 'Invalid email address' }, 400)
  if (password.length < 8 || password.length > 128) {
    return c.json({ error: 'Password must be 8-128 characters' }, 400)
  }
  if (displayName.length < 1 || displayName.length > 50) {
    return c.json({ error: 'Display name must be 1-50 characters' }, 400)
  }

  const existing = await c.env.DB.prepare('SELECT id FROM users WHERE email = ?')
    .bind(email).first()
  if (existing) return c.json({ error: 'Email already registered' }, 409)

  const passwordHash = await hashPassword(password)
  const row = await c.env.DB
    .prepare('INSERT INTO users (email, password_hash, display_name) VALUES (?, ?, ?) RETURNING id')
    .bind(email, passwordHash, displayName)
    .first<{ id: number }>()
  if (!row) return c.json({ error: 'Could not create user' }, 500)

  const token = await makeToken(row.id, c.env.JWT_SECRET)
  return c.json({ token }, 201)
})

app.post('/login', async (c) => {
  const body = await c.req.json<{
    email?: unknown
    password?: unknown
  }>().catch(() => null)
  if (!body) return c.json({ error: 'Invalid JSON body' }, 400)

  const email = typeof body.email === 'string' ? body.email.trim().toLowerCase() : ''
  const password = typeof body.password === 'string' ? body.password : ''
  if (!email || !password) return c.json({ error: 'Email and password are required' }, 400)

  const user = await c.env.DB
    .prepare('SELECT id, password_hash FROM users WHERE email = ?')
    .bind(email)
    .first<{ id: number; password_hash: string }>()

  if (!user || !(await verifyPassword(password, user.password_hash))) {
    return c.json({ error: 'Invalid credentials' }, 401)
  }

  const token = await makeToken(user.id, c.env.JWT_SECRET)
  return c.json({ token })
})

app.get('/me', requireAuth, async (c) => {
  const user = await c.env.DB
    .prepare('SELECT display_name, rank, streak_days, total_words_seen, avg_score FROM users WHERE id = ?')
    .bind(c.get('userId'))
    .first<{
      display_name: string
      rank: string
      streak_days: number
      total_words_seen: number
      avg_score: number
    }>()

  if (!user) return c.json({ error: 'Not found' }, 404)
  return c.json({ ...user, level_label: rankToLabel(user.rank) })
})

export default app
