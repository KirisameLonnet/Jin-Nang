-- Scenes
INSERT INTO scenes (name_en, name_zh, subtitle_en, color_hex, is_unlocked_default, sort_order) VALUES
  ('Restaurant', '餐厅', 'Master ordering food and drinks.', '#7CA1B3', 1, 1),
  ('Supermarket', '超市', 'Shopping lists and checkout.',    '#9985B1', 0, 2),
  ('Airport',     '机场', 'Check-in, boarding and more.',    '#D3BE86', 0, 3);

-- Vocab: Restaurant (scene_id = 1)
INSERT INTO vocab (scene_id, chinese, pinyin, english, part_of_speech, english_meaning, chinese_meaning, chinese_meaning_pinyin, audio_key, sort_order) VALUES
  (1, '米饭', 'mǐ fàn',   'cooked rice', 'n.', 'rice',
   '多指用大米煮或蒸成的饭。',
   'duō zhǐ yòng dà mǐ zhǔ huò zhēng chéng de fàn.',
   'restaurant/rice.mp3', 1),

  (1, '面条', 'miàn tiáo', 'noodles', 'n.', 'noodles',
   '用面粉制成的细长食品，可煮食。',
   'yòng miàn fěn zhì chéng de xì cháng shí pǐn, kě zhǔ shí.',
   'restaurant/noodle.mp3', 2),

  (1, '水',   'shuǐ',      'water', 'n.', 'water',
   '无色无味的液体，是生命的基础。',
   'wú sè wú wèi de yè tǐ, shì shēng mìng de jī chǔ.',
   'restaurant/water.mp3', 3),

  (1, '茶',   'chá',       'tea', 'n.', 'tea',
   '用茶叶泡制的饮料，是中国最常见的饮品。',
   'yòng chá yè pào zhì de yǐn liào, shì zhōng guó zuì cháng jiàn de yǐn pǐn.',
   'restaurant/tea.mp3', 4),

  (1, '饭店', 'fàn diàn',  'restaurant', 'n.', 'restaurant',
   '指为顾客提供饭菜和服务的场所。',
   'zhǐ wèi gù kè tí gōng fàn cài hé fú wù de chǎng suǒ.',
   'restaurant/restaurant.mp3', 5),

  (1, '吃',   'chī',       'to eat', 'v.', 'to eat',
   '把食物放入口中咀嚼并咽下。',
   'bǎ shí wù fàng rù kǒu zhōng jǔ jué bìng yàn xià.',
   'restaurant/eat.mp3', 6);

-- Examples: 米饭 (vocab_id = 1)
INSERT INTO vocab_examples (vocab_id, chinese, pinyin, english, sort_order) VALUES
  (1, '我喜欢吃米饭。', 'wǒ xǐ huān chī mǐ fàn.', 'I like eating rice.', 1),
  (1, '我要吃米饭。',   'wǒ yào chī mǐ fàn.',     'I want to eat rice.', 2);

-- Related: 米饭
INSERT INTO vocab_related (vocab_id, type, chinese, pinyin, english) VALUES
  (1, 'synonym', '炒饭', 'chǎo fàn', 'fried rice'),
  (1, 'synonym', '稀饭', 'xī fàn',   'gruel / rice porridge'),
  (1, 'synonym', '饭',   'fàn',      'meal / cooked grain');

-- Phrases: 米饭
INSERT INTO vocab_phrases (vocab_id, chinese, english, sort_order) VALUES
  (1, '一碗米饭', 'a bowl of rice',                            1),
  (1, '白米饭',   '(plain) cooked rice',                       2),
  (1, '蛋炒饭',   'fried rice with egg',                       3),
  (1, '盖浇饭',   'rice with meat and vegetables on top',      4);

-- Examples: 面条 (vocab_id = 2)
INSERT INTO vocab_examples (vocab_id, chinese, pinyin, english, sort_order) VALUES
  (2, '我想吃一碗面条。', 'wǒ xiǎng chī yī wǎn miàn tiáo.', 'I want to eat a bowl of noodles.', 1),
  (2, '这碗面条很好吃。', 'zhè wǎn miàn tiáo hěn hǎo chī.', 'This bowl of noodles is delicious.', 2);

-- Related: 面条
INSERT INTO vocab_related (vocab_id, type, chinese, pinyin, english) VALUES
  (2, 'synonym', '粉丝', 'fěn sī',  'vermicelli / glass noodles'),
  (2, 'expand',  '面汤', 'miàn tāng', 'noodle soup'),
  (2, 'expand',  '拉面', 'lā miàn',  'hand-pulled noodles');

-- Phrases: 面条
INSERT INTO vocab_phrases (vocab_id, chinese, english, sort_order) VALUES
  (2, '一碗面条', 'a bowl of noodles', 1),
  (2, '炒面',     'stir-fried noodles', 2);

-- Examples: 水 (vocab_id = 3)
INSERT INTO vocab_examples (vocab_id, chinese, pinyin, english, sort_order) VALUES
  (3, '请给我一杯水。', 'qǐng gěi wǒ yī bēi shuǐ.', 'Please give me a glass of water.', 1),
  (3, '我要喝水。',     'wǒ yào hē shuǐ.',           'I want to drink water.', 2);

-- Related: 水
INSERT INTO vocab_related (vocab_id, type, chinese, pinyin, english) VALUES
  (3, 'expand', '饮料', 'yǐn liào', 'beverage / drink'),
  (3, 'expand', '果汁', 'guǒ zhī',  'fruit juice'),
  (3, 'expand', '矿泉水', 'kuàng quán shuǐ', 'mineral water');

-- Phrases: 水
INSERT INTO vocab_phrases (vocab_id, chinese, english, sort_order) VALUES
  (3, '一杯水',   'a glass of water', 1),
  (3, '热水',     'hot water',         2),
  (3, '冷水',     'cold water',        3);

-- Examples: 茶 (vocab_id = 4)
INSERT INTO vocab_examples (vocab_id, chinese, pinyin, english, sort_order) VALUES
  (4, '我喜欢喝茶。',   'wǒ xǐ huān hē chá.',         'I like drinking tea.', 1),
  (4, '请来一壶茶。',   'qǐng lái yī hú chá.',         'Please bring a pot of tea.', 2);

-- Related: 茶
INSERT INTO vocab_related (vocab_id, type, chinese, pinyin, english) VALUES
  (4, 'synonym', '茶水', 'chá shuǐ', 'tea (water)'),
  (4, 'expand',  '绿茶', 'lǜ chá',   'green tea'),
  (4, 'expand',  '红茶', 'hóng chá', 'black tea');

-- Phrases: 茶
INSERT INTO vocab_phrases (vocab_id, chinese, english, sort_order) VALUES
  (4, '一杯茶', 'a cup of tea',  1),
  (4, '泡茶',   'to brew tea',   2),
  (4, '茶叶',   'tea leaves',    3);

-- Examples: 饭店 (vocab_id = 5)
INSERT INTO vocab_examples (vocab_id, chinese, pinyin, english, sort_order) VALUES
  (5, '我家附近有一家饭店。', 'wǒ jiā fù jìn yǒu yī jiā fàn diàn.', 'There is a restaurant near my home.', 1),
  (5, '我们去饭店吃饭吧。',   'wǒ men qù fàn diàn chī fàn ba.',     'Let''s go to a restaurant to eat.', 2);

-- Related: 饭店
INSERT INTO vocab_related (vocab_id, type, chinese, pinyin, english) VALUES
  (5, 'synonym', '餐馆',  'cān guǎn',  'restaurant'),
  (5, 'synonym', '酒楼',  'jiǔ lóu',   'restaurant / tavern'),
  (5, 'synonym', '饭馆',  'fàn guǎn',  'diner'),
  (5, 'expand',  '菜单',  'cài dān',   'menu'),
  (5, 'expand',  '厨师',  'chú shī',   'chef / cook'),
  (5, 'expand',  '订座',  'dìng zuò',  'to make a reservation');

-- Phrases: 饭店
INSERT INTO vocab_phrases (vocab_id, chinese, english, sort_order) VALUES
  (5, '中餐厅',     'Chinese restaurant',        1),
  (5, '快餐店',     'fast food restaurant',       2),
  (5, '饭店服务员', 'restaurant waiter/waitress', 3);

-- Examples: 吃 (vocab_id = 6)
INSERT INTO vocab_examples (vocab_id, chinese, pinyin, english, sort_order) VALUES
  (6, '你吃饭了吗？',   'nǐ chī fàn le ma?',       'Have you eaten?', 1),
  (6, '我想吃点东西。', 'wǒ xiǎng chī diǎn dōng xi.', 'I want to eat something.', 2);

-- Related: 吃
INSERT INTO vocab_related (vocab_id, type, chinese, pinyin, english) VALUES
  (6, 'synonym', '进食', 'jìn shí',  'to consume food'),
  (6, 'antonym', '喝',   'hē',       'to drink'),
  (6, 'expand',  '好吃', 'hǎo chī',  'delicious');

-- Phrases: 吃
INSERT INTO vocab_phrases (vocab_id, chinese, english, sort_order) VALUES
  (6, '吃饭',   'to eat (a meal)',  1),
  (6, '好吃',   'delicious / tasty', 2),
  (6, '吃什么', 'what to eat',      3);

-- Levels: Restaurant (scene_id = 1)
INSERT INTO levels (scene_id, level_num, title, subtitle, pass_threshold, points_reward, description, sort_order) VALUES
  (1, 1, '词汇匹配', '(Vocabulary Match)',  80, 10, '识形、知意：选择正确的英文释义或匹配中文词。', 1),
  (1, 2, '听力选择', '(Listening Choice)',  80, 15, '听音知意：播放音频，从备选中文汉字里选择正确的对应。', 2),
  (1, 3, '句子填空', '(Blank Filling)',     80, 15, '选择最合适的词语补全餐厅对话。', 3),
  (1, 4, '点餐角色扮演', '(Role Play)',    100, 20, '模拟真实餐厅场景，与服务员进行中文对话练习。', 4);

-- Questions: Level 1 (level_id = 1)
INSERT INTO questions (level_id, question_text, options, correct_index, explanation, sort_order) VALUES
  (1, '"吃" 是什么意思？',  '["to drink","to eat","to cook","to buy"]',        1, '吃 (chī) = to eat',             1),
  (1, '"水" 是什么意思？',  '["tea","water","rice","fruit"]',                  1, '水 (shuǐ) = water',             2),
  (1, '"饭店" 是什么意思？','["hotel","restaurant","supermarket","kitchen"]',   1, '饭店 (fàndiàn) = restaurant',   3),
  (1, '"米饭" 是什么意思？','["noodles","bread","cooked rice","soup"]',         2, '米饭 (mǐfàn) = cooked rice',   4),
  (1, '"多少钱" 是什么意思？','["how many","how much","what time","where"]',    1, '多少钱 (duōshao qián) = how much (money)', 5);

-- Questions: Level 2 (level_id = 2)
INSERT INTO questions (
  level_id, question_type, question_text, options, correct_index,
  explanation, phonetic, instruction, audio_key, sort_order
) VALUES
  (2, 'listening_choice', '听音选择：“chī”', '["喝","吃","水","茶"]', 1,
   '吃 (chī) = to eat', 'chī', '听音知意：播放音频，选择正确的汉字', 'restaurant/eat.mp3', 1),
  (2, 'listening_choice', '听音选择：“chá”', '["茶","菜","吃","查"]', 0,
   '茶 (chá) = tea', 'chá', '听音知意：播放音频，选择正确的汉字', 'restaurant/tea.mp3', 2),
  (2, 'listening_choice', '听音选择：“shuǐ”', '["茶","水","米饭","面条"]', 1,
   '水 (shuǐ) = water', 'shuǐ', '听音知意：播放音频，选择正确的汉字', 'restaurant/water.mp3', 3),
  (2, 'listening_choice', '听音选择：“mǐ fàn”', '["面条","饭店","米饭","水"]', 2,
   '米饭 (mǐ fàn) = cooked rice', 'mǐ fàn', '听音知意：播放音频，选择正确的汉字', 'restaurant/rice.mp3', 4);

-- Questions: Level 3 (level_id = 3)
INSERT INTO questions (
  level_id, question_type, question_text, options, correct_index,
  explanation, main_text, instruction, sort_order
) VALUES
  (3, 'blank_filling', '服务员：您好，您想____什么？\n顾客：我____一碗米饭。',
   '["吃/要","喝/买","看/请","说/想"]', 0, '正确答案是 "吃/要"',
   '服务员：您好，您想____什么？\n顾客：我____一碗米饭。', '填空：请选择最合适的词语补全对话', 1),
  (3, 'blank_filling', '请给我一____水。',
   '["个","杯","张","本"]', 1, '一杯水 (yì bēi shuǐ) = a glass of water',
   '请给我一____水。', '填空：请选择最合适的词语补全对话', 2),
  (3, 'blank_filling', '这个菜很____，但是很好吃。',
   '["便宜","贵","大","小"]', 1, '贵 (guì) = expensive',
   '这个菜很____，但是很好吃。', '填空：请选择最合适的词语补全对话', 3);

-- Questions: Level 4 / 点餐角色扮演 (level_id = 4)
INSERT INTO questions (level_id, question_type, question_text, options, correct_index, explanation, instruction, current_question, history, sort_order) VALUES
  (4, 'role_play',
   '角色扮演', '["请给我菜单。","我想喝水。","有什么推荐吗？"]', 0,
   '先向服务员索要菜单，再开始点餐。',
   '角色扮演：针对服务员的对话作答',
   '您好，欢迎光临！请坐。您想吃点什么？',
   '[]',
   1),
  (4, 'role_play',
   '角色扮演', '["我想喝茶。","我要咖啡。","来一杯水。"]', 0,
   '用“我想喝……”表达饮品需求。',
   '角色扮演：针对服务员的对话作答',
   '好的，这是菜单。您想喝点什么？',
   '[{"is_waiter":true,"text":"您好，欢迎光临！请坐。您想吃点什么？"},{"is_waiter":false,"text":"请给我菜单。","is_correct":true,"option_label":"A.请给我菜单。"}]',
   2),
  (4, 'role_play',
   '角色扮演', '["我要一份炒青菜和一碗米饭。","我不吃了。","有没有甜点？"]', 0,
   '使用“我要……”清楚表达菜品需求。',
   '角色扮演：针对服务员的对话作答',
   '好的，一杯茶。那您想吃什么菜？我们有鱼香肉丝、麻婆豆腐、炒青菜。',
   '[{"is_waiter":true,"text":"您好，欢迎光临！请坐。您想吃点什么？"},{"is_waiter":false,"text":"请给我菜单。","is_correct":true,"option_label":"A.请给我菜单。"},{"is_waiter":true,"text":"好的，这是菜单。您想喝点什么？"},{"is_waiter":false,"text":"我想喝茶。","is_correct":true,"option_label":"A.我想喝茶。"}]',
   3),
  (4, 'role_play',
   '角色扮演', '["不用了，谢谢。请结账吧。","再来一份米饭。","打包带走可以吗？"]', 0,
   '用“请结账”礼貌地结束用餐。',
   '角色扮演：针对服务员的对话作答',
   '好的。请慢用。（上菜后）您吃好了吗？还需要加点什么吗？',
   '[{"is_waiter":true,"text":"您好，欢迎光临！请坐。您想吃点什么？"},{"is_waiter":false,"text":"请给我菜单。","is_correct":true,"option_label":"A.请给我菜单。"},{"is_waiter":true,"text":"好的，这是菜单。您想喝点什么？"},{"is_waiter":false,"text":"我想喝茶。","is_correct":true,"option_label":"A.我想喝茶。"},{"is_waiter":true,"text":"好的，一杯茶。那您想吃什么菜？"},{"is_waiter":false,"text":"我要一份炒青菜和一碗米饭。","is_correct":true,"option_label":"A.我要一份炒青菜和一碗米饭。"}]',
   4);

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
WHERE level_id = 1;

-- Toolbox useful phrases: Restaurant.
INSERT INTO scene_phrase_topics (scene_id, category, title, icon_key)
VALUES (1, 'USEFUL PHRASES', 'Ordering Food', 'restaurant');

INSERT INTO phrase_chapters (scene_id, chapter_num, title, subtitle, sort_order) VALUES
  (1, 1, '一、进入餐厅 & 找座位', '进入餐厅 & 找座位', 1),
  (1, 2, '二、要菜单 & 开始点餐', '要菜单 & 开始点餐', 2),
  (1, 3, '三、点菜与选择', '点菜与选择', 3),
  (1, 4, '四、忌口与特殊要求', '忌口与特殊要求', 4);

INSERT INTO phrases (chapter_id, chinese, pinyin, english, sort_order) VALUES
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
  (4, '请不要放葱。', 'Qǐng bùyào fàng cōng.', 'Please no green onions.', 1);
