import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ==================== 颜色 & 常量 ====================
class AppColors {
  static const bg = Color(0xFFFDFCF8);
  static const primary = Color(0xFFD4C08B); // 米黄
  static const darkCard = Color(0xFF3D3D3D); // 深灰横幅
  static const accentBlue = Color(0xFF7A9DB8); // 蓝灰数字/按钮
  static const pinyin = Color(0xFF9B8CB5); // 淡紫拼音
  static const english = Color(0xFF9E9E9E); // 英文灰
  static const shadow = Color(0xFF3D3D3D); // 硬阴影色
  static const divider = Color(0xFFE0E0E0); // 虚线分隔
}

// ==================== 数据模型 ====================
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

// ==================== 模拟数据 ====================
final demoTopic = Topic(
  category: 'USEFUL PHRASES',
  title: 'Ordering Food',
  icon: Icons.local_cafe_outlined,
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
        Phrase(chinese: '可以坐窗边吗？', pinyin: 'Kěyǐ zuò chuāng biān ma?.', english: 'Can we sit by the window?.'),
        Phrase(chinese: '要等多久？', pinyin: 'Yào děng duō jiǔ?', english: 'How long is the wait?.'),
        Phrase(chinese: '我们愿意拼桌。', pinyin: 'Wǒmen yuànyì pīn zhuō.', english: "We're willing to share a table."),
      ],
    ),
    Chapter(
      index: 2,
      title: '二、要菜单 & 开始点餐',
      subtitle: '要菜单 & 开始点餐',
      sentenceCount: 10,
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
      sentenceCount: 9,
      phrases: [
        Phrase(chinese: '我要这个。', pinyin: 'Wǒ yào zhège.', english: "I'll have this."),
        Phrase(chinese: '再来一份。', pinyin: 'Zài lái yī fèn.', english: 'One more portion, please.'),
      ],
    ),
    Chapter(
      index: 4,
      title: '四、忌口与特殊要求',
      subtitle: '忌口与特殊要求',
      sentenceCount: 5,
      phrases: [
        Phrase(chinese: '请不要放葱。', pinyin: 'Qǐng bùyào fàng cōng.', english: 'Please no green onions.'),
      ],
    ),
  ],
);

// ==================== 通用组件 ====================

/// 硬阴影卡片容器
class HardShadowCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double borderRadius;
  final EdgeInsets? padding;
  final double shadowOffset;
  const HardShadowCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.borderRadius = 24,
    this.padding,
    this.shadowOffset = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.shadow, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            offset: Offset(0, shadowOffset),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// 返回按钮
class BackButtonCircle extends StatelessWidget {
  final VoidCallback? onTap;
  const BackButtonCircle({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).pop(),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.shadow, width: 2.5),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              offset: Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Icon(Icons.arrow_back, color: AppColors.shadow, size: 22),
      ),
    );
  }
}

/// 顶部标题标签（Chapter 1 / Restaurant）
class TitleTag extends StatelessWidget {
  final String text;
  const TitleTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return HardShadowCard(
      color: AppColors.primary,
      borderRadius: 16,
      shadowOffset: 5,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: AppColors.shadow,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// 喇叭播放按钮
class AudioButton extends StatelessWidget {
  final VoidCallback? onTap;
  const AudioButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.accentBlue,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.shadow, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              offset: Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Icon(Icons.volume_up, color: Colors.white, size: 22),
      ),
    );
  }
}

/// 虚线分隔
class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 6.0;
        final dashSpace = 4.0;
        final count = constraints.maxWidth / (dashWidth + dashSpace);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(count.floor(), (i) {
            return Container(
              width: dashWidth,
              height: 2,
              color: AppColors.divider,
            );
          }),
        );
      },
    );
  }
}

// ==================== 页面1: Restaurant 主题列表 (图2) ====================

class RestaurantPage extends StatelessWidget {
  final Topic topic;
  const RestaurantPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // 顶部导航
              Row(
                children: [
                  const BackButtonCircle(),
                  const SizedBox(width: 16),
                  const TitleTag(text: 'Restaurant'),
                ],
              ),
              const SizedBox(height: 24),
              // 深色横幅
              HardShadowCard(
                color: AppColors.darkCard,
                borderRadius: 20,
                shadowOffset: 5,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(topic.icon, color: AppColors.darkCard, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withOpacity(0.7),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          topic.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 章节列表
              Expanded(
                child: ListView.separated(
                  itemCount: topic.chapters.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, i) {
                    final ch = topic.chapters[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChapterDetailPage(
                              topic: topic,
                              initialIndex: i,
                            ),
                          ),
                        );
                      },
                      child: HardShadowCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        child: Row(
                          children: [
                            // 数字方块
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.accentBlue,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.shadow, width: 2),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.shadow,
                                    offset: Offset(0, 3),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '${ch.index}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // 标题
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ch.title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.shadow,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${ch.sentenceCount} sentences',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.english,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.shadow, size: 28),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 页面2: Chapter 详情 (图1 / 图3) ====================

class ChapterDetailPage extends StatefulWidget {
  final Topic topic;
  final int initialIndex;
  const ChapterDetailPage({
    super.key,
    required this.topic,
    this.initialIndex = 0,
  });

  @override
  State<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    if (index < 0 || index >= widget.topic.chapters.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chapters = widget.topic.chapters;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // 顶部：返回 + SlideBar 章节选择器
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  BackButtonCircle(),
                  const SizedBox(width: 12),
                  // SlideBar：横向滑动章节选择器
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: chapters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          final isActive = i == _currentIndex;
                          return GestureDetector(
                            onTap: () => _goToPage(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.shadow, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadow,
                                    offset: Offset(0, isActive ? 4 : 3),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Chapter ${chapters[i].index}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: isActive ? AppColors.shadow : AppColors.english,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 章节大标题
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    chapters[_currentIndex].title,
                    key: ValueKey(_currentIndex),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.shadow,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 句子列表 PageView（支持左右滑动切换章节）
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemCount: chapters.length,
                itemBuilder: (context, pageIndex) {
                  final chapter = chapters[pageIndex];
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: chapter.phrases.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, i) {
                      final p = chapter.phrases[i];
                      return HardShadowCard(
                        padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 中文
                                  Text(
                                    p.chinese,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.shadow,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // 拼音
                                  Text(
                                    p.pinyin,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.pinyin,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // 虚线
                                  const DashedDivider(),
                                  const SizedBox(height: 10),
                                  // 英文
                                  Text(
                                    p.english,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.english,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: AudioButton(
                                onTap: () {
                                  // TODO: 播放音频
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // 底部 Prev / Next 或 Finish
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Prev
                  Expanded(
                    child: GestureDetector(
                      onTap: _currentIndex > 0 ? () => _goToPage(_currentIndex - 1) : null,
                      child: HardShadowCard(
                        color: Colors.white,
                        borderRadius: 16,
                        shadowOffset: 5,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              size: 20,
                              color: _currentIndex > 0 ? AppColors.shadow : AppColors.english.withOpacity(0.4),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Prev',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: _currentIndex > 0 ? AppColors.shadow : AppColors.english.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Next / Finish
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_currentIndex < chapters.length - 1) {
                          _goToPage(_currentIndex + 1);
                        } else {
                          // TODO: 完成逻辑
                          Navigator.of(context).pop();
                        }
                      },
                      child: HardShadowCard(
                        color: _currentIndex < chapters.length - 1 ? AppColors.primary : AppColors.accentBlue,
                        borderRadius: 16,
                        shadowOffset: 5,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentIndex < chapters.length - 1 ? 'Next' : 'Finish',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: _currentIndex < chapters.length - 1 ? AppColors.shadow : Colors.white,
                              ),
                            ),
                            if (_currentIndex < chapters.length - 1) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward, size: 20, color: AppColors.shadow),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ==================== 入口 ====================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto', // 可替换为你项目的中文字体
        useMaterial3: true,
      ),
      home: const RestaurantPage(topic: demoTopic),
    );
  }
}