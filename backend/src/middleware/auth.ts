import { createMiddleware } from 'hono/factory'
import { verifyJwt } from '../lib/jwt'
import type { Env, Variables } from '../types'

export const requireAuth = createMiddleware<{ Bindings: Env; Variables: Variables }>(
  async (c, next) => {
    const auth = c.req.header('Authorization')
    if (!auth?.startsWith('Bearer ')) {
      return c.json({ error: 'Unauthorized' }, 401)
    }
    try {
      const payload = await verifyJwt(auth.slice(7), c.env.JWT_SECRET)
      c.set('userId', payload.sub)
      return next()
    } catch {
      return c.json({ error: 'Invalid token' }, 401)
    }
  }
)
