import 'package:flutter/material.dart';

/// 常用语句子的数据模型（Toolbox 常用语手册使用）。
class Phrase {
  final String chinese;
  final String pinyin;
  final String english;

  const Phrase({
    required this.chinese,
    required this.pinyin,
    required this.english,
  });
}

class Chapter {
  final int index;
  final String title;
  final String subtitle;
  final int sentenceCount;
  final List<Phrase> phrases;

  const Chapter({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.sentenceCount,
    required this.phrases,
  });
}

class Topic {
  final String category;
  final String title;
  final IconData icon;
  final List<Chapter> chapters;

  const Topic({
    required this.category,
    required this.title,
    required this.icon,
    required this.chapters,
  });
}

/// 模拟数据 — Ordering Food 场景
const demoTopic = Topic(
  category: 'USEFUL PHRASES',
  title: 'Ordering Food',
  icon: Icons.local_cafe,
  chapters: [
    Chapter(
      index: 1,
      title: '一、进入餐厅 & 找座位',
      subtitle: '进入餐厅 & 找座位',
      sentenceCount: 8,
      phrases: [
        Phrase(chinese: '你好，请问有位置吗？', pinyin: 'Nǐ hǎo, qǐng wèn yǒu wèizhi ma?', english: 'Hello, do you have a table available?'),
        Phrase(chinese: '我有预订。', pinyin: 'Wǒ yǒu yù dìng.', english: 'I have a reservation.'),
        Phrase(chinese: '我没有预订。', pinyin: 'Wǒ méiyǒu yùdìng.', english: "I don't have a reservation."),
        Phrase(chinese: '两位。', pinyin: 'Liǎng wèi.', english: 'Two people.'),
        Phrase(chinese: '我们有三个人。', pinyin: 'Wǒmen yǒu sān gè rén.', english: 'There are three of us.'),
        Phrase(chinese: '可以坐窗边吗？', pinyin: 'Kěyǐ zuò chuāng biān ma?', english: 'Can we sit by the window?'),
        Phrase(chinese: '要等多久？', pinyin: 'Yào děng duō jiǔ?', english: 'How long is the wait?'),
        Phrase(chinese: '我们愿意拼桌。', pinyin: 'Wǒmen yuànyì pīn zhuō.', english: "We're willing to share a table."),
      ],
    ),
    Chapter(
      index: 2,
      title: '二、要菜单 & 开始点餐',
      subtitle: '要菜单 & 开始点餐',
      sentenceCount: 8,
      phrases: [
        Phrase(chinese: '请给我们菜单。', pinyin: 'Qǐng gěi wǒmen càidān.', english: 'Please give us the menu.'),
        Phrase(chinese: '有什么推荐？', pinyin: 'Yǒu shénme tuījiàn?', english: 'What do you recommend?'),
        Phrase(chinese: '这个辣吗？', pinyin: 'Zhège là ma?', english: 'Is this spicy?'),
        Phrase(chinese: '我不吃辣。', pinyin: 'Wǒ bù chī là.', english: "I don't eat spicy food."),
        Phrase(chinese: '我对坚果过敏。', pinyin: 'Wǒ duì jiānguǒ guòmǐn.', english: "I'm allergic to nuts."),
        Phrase(chinese: '我要一杯水。', pinyin: 'Wǒ yào yī bēi shuǐ.', english: 'I would like a glass of water.'),
        Phrase(chinese: '可以打包吗？', pinyin: 'Kěyǐ dǎbāo ma?', english: 'Can I get this to go?'),
        Phrase(chinese: '买单！', pinyin: 'Mǎidān!', english: 'Check, please!'),
      ],
    ),
    Chapter(
      index: 3,
      title: '三、点菜与选择',
      subtitle: '点菜与选择',
      sentenceCount: 2,
      phrases: [
        Phrase(chinese: '我要这个。', pinyin: 'Wǒ yào zhège.', english: "I'll have this."),
        Phrase(chinese: '再来一份。', pinyin: 'Zài lái yī fèn.', english: 'One more portion, please.'),
      ],
    ),
    Chapter(
      index: 4,
      title: '四、忌口与特殊要求',
      subtitle: '忌口与特殊要求',
      sentenceCount: 1,
      phrases: [
        Phrase(chinese: '请不要放葱。', pinyin: 'Qǐng bùyào fàng cōng.', english: 'Please no green onions.'),
      ],
    ),
  ],
);
