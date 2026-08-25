import { Hono } from 'hono'
import { requireAuth } from '../middleware/auth'
import type { Env, Variables } from '../types'

const app = new Hono<{ Bindings: Env; Variables: Variables }>()

function parsePositiveId(raw: string): number | null {
  const value = Number(raw)
  return Number.isInteger(value) && value > 0 ? value : null
}

function parseJsonArray(value: string | null): unknown[] {
  if (!value) return []
  try {
    const parsed: unknown = JSON.parse(value)
    return Array.isArray(parsed) ? parsed : []
  } catch {
    return []
  }
}

app.get('/', requireAuth, async (c) => {
  const rows = await c.env.DB
    .prepare('SELECT id, name_en, name_zh, subtitle_en, color_hex, is_unlocked_default FROM scenes ORDER BY sort_order')
    .all()
  return c.json(rows.results)
})

app.get('/:id/vocab', requireAuth, async (c) => {
  const sceneId = parsePositiveId(c.req.param('id'))
  if (sceneId == null) return c.json({ error: 'Invalid scene id' }, 400)

  const rows = await c.env.DB
    .prepare('SELECT id, chinese, pinyin, english, audio_key FROM vocab WHERE scene_id = ? ORDER BY sort_order')
    .bind(sceneId)
    .all<{ id: number; chinese: string; pinyin: string; english: string; audio_key: string }>()

  const base = c.env.WORKER_URL.replace(/\/$/, '')
  return c.json(rows.results.map(v => ({
    id: v.id,
    chinese: v.chinese,
    pinyin: v.pinyin,
    english: v.english,
    audio_url: `${base}/audio/${v.audio_key}`,
  })))
})

app.get('/:id/phrases', requireAuth, async (c) => {
  const sceneId = parsePositiveId(c.req.param('id'))
  if (sceneId == null) return c.json({ error: 'Invalid scene id' }, 400)

  const topic = await c.env.DB.prepare(`
    SELECT
      t.scene_id, t.category, t.title, t.icon_key,
      s.name_en AS scene_name_en, s.name_zh AS scene_name_zh
    FROM scene_phrase_topics t
    JOIN scenes s ON s.id = t.scene_id
    WHERE t.scene_id = ?
  `).bind(sceneId).first<{
    scene_id: number
    category: string
    title: string
    icon_key: string
    scene_name_en: string
    scene_name_zh: string
  }>()

  if (!topic) return c.json({ error: 'Phrase topic not found' }, 404)

  const chapters = await c.env.DB.prepare(`
    SELECT id, chapter_num, title, subtitle
    FROM phrase_chapters
    WHERE scene_id = ?
    ORDER BY sort_order
  `).bind(sceneId).all<{
    id: number
    chapter_num: number
    title: string
    subtitle: string
  }>()

  const base = c.env.WORKER_URL.replace(/\/$/, '')
  const nested = await Promise.all(chapters.results.map(async chapter => {
    const phrases = await c.env.DB.prepare(`
      SELECT id, chinese, pinyin, english, audio_key
      FROM phrases
      WHERE chapter_id = ?
      ORDER BY sort_order
    `).bind(chapter.id).all<{
      id: number
      chinese: string
      pinyin: string
      english: string
      audio_key: string | null
    }>()

    return {
      id: chapter.id,
      index: chapter.chapter_num,
      title: chapter.title,
      subtitle: chapter.subtitle,
      sentence_count: phrases.results.length,
      phrases: phrases.results.map(phrase => ({
        id: phrase.id,
        chinese: phrase.chinese,
        pinyin: phrase.pinyin,
        english: phrase.english,
        audio_url: phrase.audio_key ? `${base}/audio/${phrase.audio_key}` : null,
      })),
    }
  }))

  return c.json({ ...topic, chapters: nested })
})

app.get('/:id/levels', requireAuth, async (c) => {
  const sceneId = parsePositiveId(c.req.param('id'))
  if (sceneId == null) return c.json({ error: 'Invalid scene id' }, 400)
  const userId = c.get('userId')

  const levels = await c.env.DB.prepare(`
    SELECT
      l.id, l.level_num, l.title, l.subtitle, l.pass_threshold,
      l.points_reward, l.description,
      COALESCE(p.stars, 0) AS stars,
      COALESCE(p.best_score, 0) AS best_score,
      COALESCE(p.is_unlocked, CASE WHEN l.level_num = 1 THEN 1 ELSE 0 END) AS is_unlocked
    FROM levels l
    LEFT JOIN user_level_progress p ON p.level_id = l.id AND p.user_id = ?
    WHERE l.scene_id = ?
    ORDER BY l.sort_order
  `).bind(userId, sceneId).all<{
    id: number
    level_num: number
    title: string
    subtitle: string
    pass_threshold: number
    points_reward: number
    description: string
    stars: number
    best_score: number
    is_unlocked: number
  }>()

  const base = c.env.WORKER_URL.replace(/\/$/, '')
  const result = await Promise.all(levels.results.map(async level => {
    const questions = await c.env.DB.prepare(`
      SELECT
        id, question_type, question_text, options, correct_index,
        explanation, main_text, phonetic, instruction, audio_url,
        audio_key, current_question, history
      FROM questions
      WHERE level_id = ?
      ORDER BY sort_order
    `).bind(level.id).all<{
      id: number
      question_type: string
      question_text: string
      options: string
      correct_index: number
      explanation: string
      main_text: string | null
      phonetic: string | null
      instruction: string | null
      audio_url: string | null
      audio_key: string | null
      current_question: string | null
      history: string | null
    }>()

    return {
      ...level,
      is_unlocked: level.is_unlocked === 1,
      questions: questions.results.map(question => ({
        id: question.id,
        question_type: question.question_type,
        question_text: question.question_text,
        options: parseJsonArray(question.options),
        correct_index: question.correct_index,
        explanation: question.explanation,
        main_text: question.main_text,
        phonetic: question.phonetic,
        instruction: question.instruction,
        audio_url: question.audio_key
          ? `${base}/audio/${question.audio_key}`
          : question.audio_url,
        current_question: question.current_question,
        history: parseJsonArray(question.history),
      })),
    }
  }))

  return c.json(result)
})

export default app
