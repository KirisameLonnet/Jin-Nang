import 'package:flutter/material.dart';

void main() => runApp(const RestaurantApp());

// ==================== 颜色 ====================
class AppColors {
  static const bg = Color(0xFFF5F0E8);
  static const dark = Color(0xFF3D3D3D);
  static const cardBg = Color(0xFFF0EDE6);
  static const white = Color(0xFFFAF8F3);
  static const blue = Color(0xFF7A9E9F);
  static const green = Color(0xFF8FD694);
  static const gold = Color(0xFFD4C896);
  static const red = Color(0xFFE57373);
  static const lightGray = Color(0xFFE8E5DE);
  static const purpleTint = Color(0xFFEAE8F0);
}

// ==================== 数据模型 ====================
enum QuestionType { vocabularyMatch, listeningChoice, blankFilling }

class OptionData {
  final String label;
  final String text;
  final bool isCorrect;
  const OptionData(this.label, this.text, {this.isCorrect = false});
}

class QuestionData {
  final QuestionType type;
  final String levelIndicator;
  final String title;
  final String titleEn;
  final String questionCounter;
  final double progress;

  final String? instruction;
  final String? mainText;
  final String? phonetic;
  final String? audioLabel;

  final List<OptionData> options;
  final String feedbackTitle;
  final String feedbackDetail;

  const QuestionData({
    required this.type,
    required this.levelIndicator,
    required this.title,
    required this.titleEn,
    required this.questionCounter,
    required this.progress,
    this.instruction,
    this.mainText,
    this.phonetic,
    this.audioLabel,
    required this.options,
    required this.feedbackTitle,
    required this.feedbackDetail,
  });
}

// ==================== 示例题库 ====================
final List<QuestionData> demoQuestions = [
  // Level 1: 词汇匹配
  const QuestionData(
    type: QuestionType.vocabularyMatch,
    levelIndicator: 'LEVEL 1 / 4',
    title: '词汇匹配',
    titleEn: '(Vocabulary Match)',
    questionCounter: '4 / 10',
    progress: 0.4,
    instruction: '请翻译中文词组含义',
    mainText: '水',
    options: [
      OptionData('A', 'fire'),
      OptionData('B', 'water', isCorrect: true),
      OptionData('C', 'earth'),
    ],
    feedbackTitle: '回答正确 (Correct)',
    feedbackDetail: '“水是 WATER，基础生命必需品。”',
  ),
  // Level 2: 听力选择
  const QuestionData(
    type: QuestionType.listeningChoice,
    levelIndicator: 'LEVEL 2 / 4',
    title: '听力选择',
    titleEn: '(Listening Choice)',
    questionCounter: '3 / 8',
    progress: 0.375,
    audioLabel: '请播放拼音音频',
    phonetic: 'chá',
    options: [
      OptionData('A', '茶'),
      OptionData('B', '查', isCorrect: true),
      OptionData('C', '插'),
    ],
    feedbackTitle: '回答正确 (Correct)',
    feedbackDetail: '“chá 对应汉字为 查 / 茶，此处根据语境选择。”',
  ),
  // Level 3: 句子填空
  const QuestionData(
    type: QuestionType.blankFilling,
    levelIndicator: 'LEVEL 3 / 4',
    title: '句子填空',
    titleEn: '(Blank Filling)',
    questionCounter: '3 / 8',
    progress: 0.375,
    instruction: '填空：请寻找最合适的词语补全对话',
    mainText: '顾客：来一杯茶。这个菜____钱？',
    options: [
      OptionData('A', '多小'),
      OptionData('B', '多少', isCorrect: true),
      OptionData('C', '几'),
    ],
    feedbackTitle: '回答正确 (Correct)',
    feedbackDetail: '“询问价格专用固定词组是‘多少钱’，其余选项不符合语法。”',
  ),
];

// ==================== 应用入口 ====================
class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '餐厅点餐',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        useMaterial3: true,
        fontFamily: 'PingFang SC',
      ),
      home: const LevelSelectionPage(),
    );
  }
}

// ==================== 页面1：关卡选择 ====================
class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 顶部栏
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _circleBtn(Icons.arrow_back),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: _hardShadowBox(AppColors.blue, radius: 12),
                    child: const Text('餐厅点餐',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: _hardShadowBox(AppColors.gold, radius: 10),
                    child: Row(
                      children: const [
                        Icon(Icons.auto_awesome, size: 16, color: AppColors.dark),
                        SizedBox(width: 4),
                        Text('0 PTS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.dark)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 横幅
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.dark, width: 3),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: const Color(0xFFB88A8A), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.person_outline, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('RESTAURANT QUEST MODULE',
                              style: TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                          SizedBox(height: 4),
                          Text('挑战即可获得金星星与丰厚积分！',
                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 关卡列表
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _levelCard(
                    context,
                    num: 1,
                    title: '词汇匹配',
                    sub: '(Vocabulary Match)',
                    desc: '识形、知意：选择正确的英文释义或匹配中文词。',
                    progress: '8 /10题',
                    stars: 2,
                    pts: 10,
                    status: _Status.done,
                    qIndex: 0,
                  ),
                  const SizedBox(height: 16),
                  _levelCard(
                    context,
                    num: 2,
                    title: '听力选择',
                    sub: '((Listening Selection))',
                    desc: '听音知意：播放音频，从备选中文汉字里选择正确的对应。',
                    progress: '7 /8题',
                    stars: 3,
                    pts: 15,
                    status: _Status.play,
                    qIndex: 1,
                  ),
                  const SizedBox(height: 16),
                  _levelCard(
                    context,
                    num: 3,
                    title: '句子填空',
                    sub: '(Blank Filling)',
                    desc: '选择最合适的词语补全餐厅对话。',
                    progress: '0 /8题',
                    stars: 3,
                    pts: 15,
                    status: _Status.locked,
                    qIndex: 2,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: _hardShadowBox(AppColors.white, shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.dark, size: 20),
    );
  }

  BoxDecoration _hardShadowBox(Color color, {double radius = 0, BoxShape shape = BoxShape.rectangle}) {
    return BoxDecoration(
      color: color,
      shape: shape,
      borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(radius),
      border: Border.all(color: AppColors.dark, width: 2.5),
      boxShadow: const [BoxShadow(color: AppColors.dark, offset: Offset(3, 3), blurRadius: 0)],
    );
  }

  Widget _levelCard(
    BuildContext context, {
    required int num,
    required String title,
    required String sub,
    required String desc,
    required String progress,
    required int stars,
    required int pts,
    required _Status status,
    required int qIndex,
  }) {
    final locked = status == _Status.locked;
    return Opacity(
      opacity: locked ? 0.7 : 1,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.dark, width: 3),
          boxShadow: const [BoxShadow(color: AppColors.dark, offset: Offset(4, 4), blurRadius: 0)],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(21), topRight: Radius.circular(21)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: locked ? AppColors.lightGray : AppColors.blue,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.dark, width: 2),
                        ),
                        child: Center(
                          child: Text('$num',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('第 $num 关：$title',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark)),
                            Text(sub,
                                style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      if (status == _Status.done)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFB88A8A), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: const [
                              Icon(Icons.check_circle, size: 12, color: Colors.white),
                              SizedBox(width: 2),
                              Text('已通关', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      else if (locked)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: AppColors.lightGray, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.dark, width: 1.5)),
                          child: Row(
                            children: const [
                              Icon(Icons.lock, size: 12, color: AppColors.dark),
                              SizedBox(width: 2),
                              Text('未解锁', style: TextStyle(fontSize: 11, color: AppColors.dark, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(desc, style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4)),
                  const SizedBox(height: 12),
                  _dashedLine(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('通关: $progress', style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      const Icon(Icons.star, size: 14, color: AppColors.gold),
                      Text(' X$stars ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.dark)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.purpleTint, borderRadius: BorderRadius.circular(6)),
                        child: Text('+$pts PTS', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.dark)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(21), bottomRight: Radius.circular(21)),
              ),
              child: locked
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.lock_outline, size: 16, color: Colors.black45),
                        SizedBox(width: 6),
                        Text('请先通关前一关卡', style: TextStyle(fontSize: 14, color: Colors.black45, fontWeight: FontWeight.w600)),
                      ],
                    )
                  : Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => QuizPage(question: demoQuestions[qIndex])),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: _hardShadowBox(AppColors.gold, radius: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.play_arrow, size: 18, color: AppColors.dark),
                              const SizedBox(width: 4),
                              Text(status == _Status.done ? 'Replay' : 'START',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.dark)),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashedLine() {
    return Row(children: List.generate(30, (i) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 2), height: 1, color: Colors.grey.shade400))));
  }
}

enum _Status { done, play, locked }

// ==================== 页面2：通用答题页 ====================
class QuizPage extends StatefulWidget {
  final QuestionData question;
  const QuizPage({super.key, required this.question});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int? selectedIndex;
  bool hasAnswered = false;

  void _onSelect(int index) {
    if (hasAnswered) return;
    setState(() {
      selectedIndex = index;
      hasAnswered = true;
    });
  }

  bool get _isCorrect => selectedIndex != null && widget.question.options[selectedIndex!].isCorrect;

  @override
  Widget build(BuildContext context) {
    final q = widget.question;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ---------- 顶部 ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      _circleBtn(Icons.arrow_back, onTap: () => Navigator.pop(context)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(q.levelIndicator,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black45, letterSpacing: 1)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(q.title,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.dark)),
                              const SizedBox(width: 8),
                              Text(q.titleEn,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400, width: 2),
                        ),
                        child: Text(q.questionCounter,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 进度条
                  Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.dark, width: 2.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: q.progress,
                        child: Container(color: AppColors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- 大卡片 ----------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppColors.dark, width: 3.5),
                    boxShadow: const [BoxShadow(color: AppColors.dark, offset: Offset(5, 5), blurRadius: 0)],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ===== 题目区域（根据题型切换） =====
                              _buildQuestionArea(q),
                              const SizedBox(height: 24),
                              _dashedLine(),
                              const SizedBox(height: 24),

                              // ===== 选项 =====
                              ...List.generate(q.options.length, (i) {
                                final opt = q.options[i];
                                final isSel = selectedIndex == i;
                                final showCorrect = hasAnswered && opt.isCorrect;
                                final showWrong = hasAnswered && isSel && !opt.isCorrect;

                                Color bg = AppColors.white;
                                if (showCorrect) bg = AppColors.green;
                                if (showWrong) bg = AppColors.red;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: GestureDetector(
                                    onTap: () => _onSelect(i),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: bg,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: AppColors.dark, width: 2.5),
                                        boxShadow: const [BoxShadow(color: AppColors.dark, offset: Offset(3, 3), blurRadius: 0)],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: AppColors.dark, width: 2),
                                            ),
                                            child: Center(
                                              child: Text(opt.label,
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark)),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Text(opt.text,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: showCorrect || showWrong ? AppColors.dark : Colors.black54)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),

                              // ===== 反馈 =====
                              if (hasAnswered) ...[
                                const SizedBox(height: 20),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.purpleTint,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.shade400, width: 1.5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 28,
                                            height: 28,
                                            decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                                            child: const Icon(Icons.check, size: 18, color: Colors.white),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(q.feedbackTitle,
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(q.feedbackDetail,
                                          style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------- 底部按钮 ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: GestureDetector(
                onTap: hasAnswered ? () {} : null,
                child: Opacity(
                  opacity: hasAnswered ? 1 : 0.5,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.dark, width: 3),
                      boxShadow: const [BoxShadow(color: AppColors.dark, offset: Offset(4, 4), blurRadius: 0)],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('下一题', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                        SizedBox(width: 6),
                        Text('Next Question', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                        SizedBox(width: 8),
                        Icon(Icons.chevron_right, color: AppColors.dark, size: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== 三种题型的题目区域 =====
  Widget _buildQuestionArea(QuestionData q) {
    switch (q.type) {
      case QuestionType.vocabularyMatch:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.instruction ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text(q.mainText ?? '',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.dark)),
                ],
              ),
            ),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.dark, width: 2.5),
                boxShadow: const [BoxShadow(color: AppColors.dark, offset: Offset(3, 3), blurRadius: 0)],
              ),
              child: const Icon(Icons.volume_up, color: AppColors.dark, size: 24),
            ),
          ],
        );

      case QuestionType.listeningChoice:
        return Column(
          children: [
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.dark, width: 3),
                  boxShadow: const [BoxShadow(color: AppColors.dark, offset: Offset(4, 4), blurRadius: 0)],
                ),
                child: const Icon(Icons.volume_up, color: AppColors.dark, size: 40),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(q.audioLabel ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(q.phonetic ?? '',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.dark)),
            ),
          ],
        );

      case QuestionType.blankFilling:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q.instruction ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            _buildBlankText(q.mainText ?? ''),
          ],
        );
    }
  }

  // 填空题带下划线的文本
  Widget _buildBlankText(String text) {
    // 预期格式: "顾客：来一杯茶。这个菜____钱？"
    final parts = text.split('____');
    if (parts.length == 2) {
      return Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.dark, height: 1.4),
          children: [
            TextSpan(text: parts[0]),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: Container(
                width: 50,
                height: 3,
                color: AppColors.dark,
                margin: const EdgeInsets.symmetric(horizontal: 2),
              ),
            ),
            TextSpan(text: parts[1]),
          ],
        ),
      );
    }
    return Text(text, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.dark));
  }

  Widget _circleBtn(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.dark, width: 2.5),
          boxShadow: const [BoxShadow(color: AppColors.dark, offset: Offset(3, 3), blurRadius: 0)],
        ),
        child: Icon(icon, color: AppColors.dark, size: 22),
      ),
    );
  }

  Widget _dashedLine() {
    return Row(children: List.generate(40, (i) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 2), height: 1, color: Colors.grey.shade400))));
  }
}



/* 最后一题答完后跳转
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => const SummaryPage(
      score: 5,      // 实际答对数
      total: 6,      // 总题数
      stars: 3,      // 计算得出的星星数
      points: 50,    // 本关奖励积分
    ),
  ),
);*/