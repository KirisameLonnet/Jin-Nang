import { Hono } from 'hono'
import type { Env } from '../types'

const app = new Hono<{ Bindings: Env }>()
const scenePattern = /^[a-z0-9_-]+$/i
const filenamePattern = /^[a-z0-9_-]+\.mp3$/i

app.get('/:scene/:filename', async (c) => {
  const scene = c.req.param('scene')
  const filename = c.req.param('filename')
  if (!scenePattern.test(scene) || !filenamePattern.test(filename)) {
    return c.json({ error: 'Invalid audio path' }, 400)
  }

  const object = await c.env.AUDIO.get(`${scene}/${filename}`)
  if (!object) return c.json({ error: 'Audio not found' }, 404)
  return new Response(object.body, {
    headers: {
      'Content-Type': object.httpMetadata?.contentType ?? 'audio/mpeg',
      'Cache-Control': 'public, max-age=31536000, immutable',
      'ETag': object.httpEtag,
    },
  })
})

export default app
