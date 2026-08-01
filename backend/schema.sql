CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  display_name TEXT NOT NULL,
  rank TEXT NOT NULL DEFAULT 'Bronze',
  streak_days INTEGER NOT NULL DEFAULT 0,
  last_study_date TEXT,
  total_words_seen INTEGER NOT NULL DEFAULT 0,
  avg_score REAL NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS scenes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name_en TEXT NOT NULL,
  name_zh TEXT NOT NULL,
  subtitle_en TEXT NOT NULL,
  color_hex TEXT NOT NULL,
  is_unlocked_default INTEGER NOT NULL DEFAULT 0,
  sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS vocab (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  scene_id INTEGER NOT NULL REFERENCES scenes(id),
  chinese TEXT NOT NULL,
  pinyin TEXT NOT NULL,
  english TEXT NOT NULL,
  part_of_speech TEXT,
  english_meaning TEXT,
  chinese_meaning TEXT,
  chinese_meaning_pinyin TEXT,
  audio_key TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS vocab_examples (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  vocab_id INTEGER NOT NULL REFERENCES vocab(id),
  chinese TEXT NOT NULL,
  pinyin TEXT NOT NULL,
  english TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS vocab_related (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  vocab_id INTEGER NOT NULL REFERENCES vocab(id),
  type TEXT NOT NULL,
  chinese TEXT NOT NULL,
  pinyin TEXT NOT NULL,
  english TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS vocab_phrases (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  vocab_id INTEGER NOT NULL REFERENCES vocab(id),
  chinese TEXT NOT NULL,
  english TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS levels (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  scene_id INTEGER NOT NULL REFERENCES scenes(id),
  level_num INTEGER NOT NULL,
  title TEXT NOT NULL,
  subtitle TEXT NOT NULL,
  pass_threshold INTEGER NOT NULL DEFAULT 80,
  points_reward INTEGER NOT NULL DEFAULT 0,
  description TEXT NOT NULL DEFAULT '',
  sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  level_id INTEGER NOT NULL REFERENCES levels(id),
  question_type TEXT NOT NULL DEFAULT 'vocabulary_match',
  question_text TEXT NOT NULL,
  options TEXT NOT NULL,
  correct_index INTEGER NOT NULL,
  explanation TEXT NOT NULL,
  main_text TEXT,
  phonetic TEXT,
  instruction TEXT,
  audio_url TEXT,
  current_question TEXT,
  history TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS user_level_progress (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES users(id),
  level_id INTEGER NOT NULL REFERENCES levels(id),
  stars INTEGER NOT NULL DEFAULT 0,
  best_score INTEGER NOT NULL DEFAULT 0,
  is_unlocked INTEGER NOT NULL DEFAULT 0,
  completed_at TEXT,
  UNIQUE(user_id, level_id)
);

CREATE TABLE IF NOT EXISTS user_vocab_seen (
  user_id INTEGER NOT NULL REFERENCES users(id),
  vocab_id INTEGER NOT NULL REFERENCES vocab(id),
  seen_at TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (user_id, vocab_id)
);
