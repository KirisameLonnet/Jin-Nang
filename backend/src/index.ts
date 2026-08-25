import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { logger } from 'hono/logger'
import type { Env, Variables } from './types'
import authRoutes from './routes/auth'
import scenesRoutes from './routes/scenes'
import vocabRoutes from './routes/vocab'
import progressRoutes from './routes/progress'
import vocabSeenRoutes from './routes/vocab_seen'
import audioRoutes from './routes/audio'

const app = new Hono<{ Bindings: Env; Variables: Variables }>()

app.use('*', cors({ origin: '*' }))
app.use('*', logger())

app.get('/health', c => c.json({ ok: true }))

app.route('/auth', authRoutes)
app.route('/scenes', scenesRoutes)
app.route('/vocab', vocabRoutes)
app.route('/user/progress', progressRoutes)
app.route('/user/vocab-seen', vocabSeenRoutes)
app.route('/audio', audioRoutes)

export default app
