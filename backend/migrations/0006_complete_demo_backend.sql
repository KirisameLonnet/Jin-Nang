-- Complete the latest Demo data model: typed questions and Toolbox phrases.
ALTER TABLE questions ADD COLUMN audio_key TEXT;

CREATE TABLE IF NOT EXISTS scene_phrase_topics (
  scene_id INTEGER PRIMARY KEY REFERENCES scenes(id),
  category TEXT NOT NULL,
  title TEXT NOT NULL,
  icon_key TEXT NOT NULL DEFAULT 'restaurant'
);

CREATE TABLE IF NOT EXISTS phrase_chapters (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  scene_id INTEGER NOT NULL REFERENCES scenes(id),
  chapter_num INTEGER NOT NULL,
  title TEXT NOT NULL,
  subtitle TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  UNIQUE(scene_id, chapter_num)
);

CREATE TABLE IF NOT EXISTS phrases (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  chapter_id INTEGER NOT NULL REFERENCES phrase_chapters(id),
  chinese TEXT NOT NULL,
  pinyin TEXT NOT NULL,
  english TEXT NOT NULL,
  audio_key TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_vocab_scene ON vocab(scene_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_levels_scene ON levels(scene_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_questions_level ON questions(level_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_phrase_chapters_scene ON phrase_chapters(scene_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_phrases_chapter ON phrases(chapter_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_progress_user ON user_level_progress(user_id);

-- Level 1: vocabulary matching.
UPDATE questions SET
  question_type = 'vocabulary_match',
  instruction = '请翻译中文词组含义',
  main_text = CASE sort_order
    WHEN 1 THEN '吃'
    WHEN 2 THEN '水'
    WHEN 3 THEN '饭店'
    WHEN 4 THEN '米饭'
    WHEN 5 THEN '多少钱'
  END
WHERE level_id = (SELECT id FROM levels WHERE scene_id = 1 AND level_num = 1);

-- Level 2: use audio already present in R2 for a fully working Demo.
UPDATE questions SET
  question_type = 'listening_choice',
  instruction = '听音知意：播放音频，选择正确的汉字',
  question_text = CASE sort_order
    WHEN 1 THEN '听音选择：“chī”'
    WHEN 2 THEN '听音选择：“chá”'
    WHEN 3 THEN '听音选择：“shuǐ”'
    WHEN 4 THEN '听音选择：“mǐ fàn”'
  END,
  phonetic = CASE sort_order
    WHEN 1 THEN 'chī'
    WHEN 2 THEN 'chá'
    WHEN 3 THEN 'shuǐ'
    WHEN 4 THEN 'mǐ fàn'
  END,
  options = CASE sort_order
    WHEN 1 THEN '["喝","吃","水","茶"]'
    WHEN 2 THEN '["茶","菜","吃","查"]'
    WHEN 3 THEN '["茶","水","米饭","面条"]'
    WHEN 4 THEN '["面条","饭店","米饭","水"]'
  END,
  correct_index = CASE sort_order
    WHEN 1 THEN 1
    WHEN 2 THEN 0
    WHEN 3 THEN 1
    WHEN 4 THEN 2
  END,
  explanation = CASE sort_order
    WHEN 1 THEN '吃 (chī) = to eat'
    WHEN 2 THEN '茶 (chá) = tea'
    WHEN 3 THEN '水 (shuǐ) = water'
    WHEN 4 THEN '米饭 (mǐ fàn) = cooked rice'
  END,
  audio_key = CASE sort_order
    WHEN 1 THEN 'restaurant/eat.mp3'
    WHEN 2 THEN 'restaurant/tea.mp3'
    WHEN 3 THEN 'restaurant/water.mp3'
    WHEN 4 THEN 'restaurant/rice.mp3'
  END
WHERE level_id = (SELECT id FROM levels WHERE scene_id = 1 AND level_num = 2);

-- Level 3: blank filling.
UPDATE questions SET
  question_type = 'blank_filling',
  instruction = '填空：请选择最合适的词语补全对话',
  main_text = question_text
WHERE level_id = (SELECT id FROM levels WHERE scene_id = 1 AND level_num = 3);

-- Level 4: four complete role-play turns. Reuse the two existing rows.
UPDATE questions SET
  question_type = 'role_play',
  question_text = '角色扮演',
  options = '["请给我菜单。","我想喝水。","有什么推荐吗？"]',
  correct_index = 0,
  explanation = '先向服务员索要菜单，再开始点餐。',
  instruction = '角色扮演：针对服务员的对话作答',
  current_question = '您好，欢迎光临！请坐。您想吃点什么？',
  history = '[]'
WHERE level_id = (SELECT id FROM levels WHERE scene_id = 1 AND level_num = 4)
  AND sort_order = 1;

INSERT INTO questions (
  level_id, question_type, question_text, options, correct_index,
  explanation, instruction, current_question, history, sort_order
)
SELECT id, 'role_play', '角色扮演',
  '["我想喝茶。","我要咖啡。","来一杯水。"]', 0,
  '用“我想喝……”表达饮品需求。',
  '角色扮演：针对服务员的对话作答',
  '好的，这是菜单。您想喝点什么？',
  '[{"is_waiter":true,"text":"您好，欢迎光临！请坐。您想吃点什么？"},{"is_waiter":false,"text":"请给我菜单。","is_correct":true,"option_label":"A.请给我菜单。"}]',
  2
FROM levels
WHERE scene_id = 1 AND level_num = 4
  AND NOT EXISTS (
    SELECT 1 FROM questions q
    WHERE q.level_id = levels.id AND q.sort_order = 2
  );

UPDATE questions SET
  question_type = 'role_play',
  question_text = '角色扮演',
  options = '["我想喝茶。","我要咖啡。","来一杯水。"]',
  correct_index = 0,
  explanation = '用“我想喝……”表达饮品需求。',
  instruction = '角色扮演：针对服务员的对话作答',
  current_question = '好的，这是菜单。您想喝点什么？',
  history = '[{"is_waiter":true,"text":"您好，欢迎光临！请坐。您想吃点什么？"},{"is_waiter":false,"text":"请给我菜单。","is_correct":true,"option_label":"A.请给我菜单。"}]'
WHERE level_id = (SELECT id FROM levels WHERE scene_id = 1 AND level_num = 4)
  AND sort_order = 2;

INSERT INTO questions (
  level_id, question_type, question_text, options, correct_index,
  explanation, instruction, current_question, history, sort_order
)
SELECT id, 'role_play', '角色扮演',
  '["我要一份炒青菜和一碗米饭。","我不吃了。","有没有甜点？"]', 0,
  '使用“我要……”清楚表达菜品需求。',
  '角色扮演：针对服务员的对话作答',
  '好的，一杯茶。那您想吃什么菜？我们有鱼香肉丝、麻婆豆腐、炒青菜。',
  '[{"is_waiter":true,"text":"您好，欢迎光临！请坐。您想吃点什么？"},{"is_waiter":false,"text":"请给我菜单。","is_correct":true,"option_label":"A.请给我菜单。"},{"is_waiter":true,"text":"好的，这是菜单。您想喝点什么？"},{"is_waiter":false,"text":"我想喝茶。","is_correct":true,"option_label":"A.我想喝茶。"}]',
  3
FROM levels
WHERE scene_id = 1 AND level_num = 4
  AND NOT EXISTS (
    SELECT 1 FROM questions q
    WHERE q.level_id = levels.id AND q.sort_order = 3
  );

INSERT INTO questions (
  level_id, question_type, question_text, options, correct_index,
  explanation, instruction, current_question, history, sort_order
)
SELECT id, 'role_play', '角色扮演',
  '["不用了，谢谢。请结账吧。","再来一份米饭。","打包带走可以吗？"]', 0,
  '用“请结账”礼貌地结束用餐。',
  '角色扮演：针对服务员的对话作答',
  '好的。请慢用。（上菜后）您吃好了吗？还需要加点什么吗？',
  '[{"is_waiter":true,"text":"您好，欢迎光临！请坐。您想吃点什么？"},{"is_waiter":false,"text":"请给我菜单。","is_correct":true,"option_label":"A.请给我菜单。"},{"is_waiter":true,"text":"好的，这是菜单。您想喝点什么？"},{"is_waiter":false,"text":"我想喝茶。","is_correct":true,"option_label":"A.我想喝茶。"},{"is_waiter":true,"text":"好的，一杯茶。那您想吃什么菜？"},{"is_waiter":false,"text":"我要一份炒青菜和一碗米饭。","is_correct":true,"option_label":"A.我要一份炒青菜和一碗米饭。"}]',
  4
FROM levels
WHERE scene_id = 1 AND level_num = 4
  AND NOT EXISTS (
    SELECT 1 FROM questions q
    WHERE q.level_id = levels.id AND q.sort_order = 4
  );

-- Toolbox useful phrases.
INSERT OR IGNORE INTO scene_phrase_topics (scene_id, category, title, icon_key)
SELECT id, 'USEFUL PHRASES', 'Ordering Food', 'restaurant'
FROM scenes
WHERE id = 1;

WITH chapters(chapter_num, title, subtitle, sort_order) AS (VALUES
  (1, '一、进入餐厅 & 找座位', '进入餐厅 & 找座位', 1),
  (2, '二、要菜单 & 开始点餐', '要菜单 & 开始点餐', 2),
  (3, '三、点菜与选择', '点菜与选择', 3),
  (4, '四、忌口与特殊要求', '忌口与特殊要求', 4)
)
INSERT OR IGNORE INTO phrase_chapters (scene_id, chapter_num, title, subtitle, sort_order)
SELECT scenes.id, chapters.chapter_num, chapters.title, chapters.subtitle, chapters.sort_order
FROM scenes
JOIN chapters
WHERE scenes.id = 1;

WITH phrase_data(chapter_num, chinese, pinyin, english, sort_order) AS (VALUES
  (1, '你好，请问有位置吗？', 'Nǐ hǎo, qǐng wèn yǒu wèizhi ma?', 'Hello, do you have a table available?', 1),
  (1, '我有预订。', 'Wǒ yǒu yù dìng.', 'I have a reservation.', 2),
  (1, '我没有预订。', 'Wǒ méiyǒu yùdìng.', 'I don''t have a reservation.', 3),
  (1, '两位。', 'Liǎng wèi.', 'Two people.', 4),
  (1, '我们有三个人。', 'Wǒmen yǒu sān gè rén.', 'There are three of us.', 5),
  (1, '可以坐窗边吗？', 'Kěyǐ zuò chuāng biān ma?', 'Can we sit by the window?', 6),
  (1, '要等多久？', 'Yào děng duō jiǔ?', 'How long is the wait?', 7),
  (1, '我们愿意拼桌。', 'Wǒmen yuànyì pīn zhuō.', 'We''re willing to share a table.', 8),
  (2, '请给我们菜单。', 'Qǐng gěi wǒmen càidān.', 'Please give us the menu.', 1),
  (2, '有什么推荐？', 'Yǒu shénme tuījiàn?', 'What do you recommend?', 2),
  (2, '这个辣吗？', 'Zhège là ma?', 'Is this spicy?', 3),
  (2, '我不吃辣。', 'Wǒ bù chī là.', 'I don''t eat spicy food.', 4),
  (2, '我对坚果过敏。', 'Wǒ duì jiānguǒ guòmǐn.', 'I''m allergic to nuts.', 5),
  (2, '我要一杯水。', 'Wǒ yào yī bēi shuǐ.', 'I would like a glass of water.', 6),
  (2, '可以打包吗？', 'Kěyǐ dǎbāo ma?', 'Can I get this to go?', 7),
  (2, '买单！', 'Mǎidān!', 'Check, please!', 8),
  (3, '我要这个。', 'Wǒ yào zhège.', 'I''ll have this.', 1),
  (3, '再来一份。', 'Zài lái yī fèn.', 'One more portion, please.', 2),
  (4, '请不要放葱。', 'Qǐng bùyào fàng cōng.', 'Please no green onions.', 1)
)
INSERT INTO phrases (chapter_id, chinese, pinyin, english, sort_order)
SELECT c.id, v.chinese, v.pinyin, v.english, v.sort_order
FROM phrase_chapters c
JOIN phrase_data v ON v.chapter_num = c.chapter_num
WHERE c.scene_id = 1
  AND NOT EXISTS (
    SELECT 1 FROM phrases p
    WHERE p.chapter_id = c.id AND p.sort_order = v.sort_order
  );
