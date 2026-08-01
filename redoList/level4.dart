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
  static const red = Color(0xFFFF6B6B);
  static const lightRed = Color(0xFFF5E0E0);
  static const lightGray = Color(0xFFE8E5DE);
  static const purpleTint = Color(0xFFEAE8F0);
  static const waiterBubble = Color(0xFFE8E0F0); // 服务员气泡淡紫
  static const reviewPurple = Color(0xFFD8D0E8); // Review按钮淡紫
}

// ==================== 通用组件 ====================
BoxDecoration hardShadow({
  Color color = AppColors.white,
  double radius = 16,
  BoxShape shape = BoxShape.rectangle,
  double borderWidth = 2.5,
  Color borderColor = AppColors.dark,
  List<BoxShadow> extra = const [],
}) {
  return BoxDecoration(
    color: color,
    shape: shape,
    borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(radius),
    border: Border.all(color: borderColor, width: borderWidth),
    boxShadow: [
      const BoxShadow(color: AppColors.dark, offset: Offset(3, 3), blurRadius: 0),
      ...extra,
    ],
  );
}

Widget dashedLine() {
  return Row(
    children: List.generate(
      40,
      (i) => Expanded(
        child: Container(margin: const EdgeInsets.symmetric(horizontal: 2), height: 1, color: Colors.grey.shade400),
      ),
    ),
  );
}

Widget circleBtn({required IconData icon, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 44,
      height: 44,
      decoration: hardShadow(shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.dark, size: 22),
    ),
  );
}

// ==================== 数据模型 ====================
class DialogueTurn {
  final bool isWaiter; // true=服务员(左), false=用户(右)
  final String text;
  final bool? isCorrect; // 用户回答是否正确
  final String? optionLabel; // 如 "B.请给我菜单。"
  const DialogueTurn({
    required this.isWaiter,
    required this.text,
    this.isCorrect,
    this.optionLabel,
  });
}

class RolePlayQuestion {
  final String levelIndicator;
  final String title;
  final String titleEn;
  final String questionCounter;
  final double progress;
  final List<DialogueTurn> history;
  final String instruction;
  final String currentQuestion;
  final List<OptionData> options;
  final String feedbackTitle;
  final String feedbackDetail;
  const RolePlayQuestion({
    required this.levelIndicator,
    required this.title,
    required this.titleEn,
    required this.questionCounter,
    required this.progress,
    required this.history,
    required this.instruction,
    required this.currentQuestion,
    required this.options,
    required this.feedbackTitle,
    required this.feedbackDetail,
  });
}

class OptionData {
  final String label;
  final String text;
  final bool isCorrect;
  const OptionData(this.label, this.text, {this.isCorrect = false});
}

// ==================== 应用入口 ====================
class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '餐厅点餐',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: AppColors.bg, useMaterial3: true, fontFamily: 'PingFang SC'),
      home: const LevelSelectionPage(),
    );
  }
}

// ==================== 页面1：关卡选择（已更新 Level 4）====================
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
                  circleBtn(icon: Icons.arrow_back),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: hardShadow(color: AppColors.blue, radius: 12),
                    child: const Text('餐厅点餐', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: hardShadow(color: AppColors.gold, radius: 10),
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
                decoration: BoxDecoration(color: AppColors.dark, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.dark, width: 3)),
                child: Row(
                  children: [
                    Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFB88A8A), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.person_outline, color: Colors.white)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('RESTAURANT QUEST MODULE', style: TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                          SizedBox(height: 4),
                          Text('挑战即可获得金星星与丰厚积分！', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
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
                  _levelCard(context, num: 1, title: '词汇匹配', sub: '(Vocabulary Match)', desc: '识形、知意：选择正确的英文释义或匹配中文词。', progress: '8 /10题', stars: 2, pts: 10, status: _Status.done),
                  const SizedBox(height: 16),
                  _levelCard(context, num: 2, title: '听力选择', sub: '((Listening Selection))', desc: '听音知意：播放音频，从备选中文汉字里选择正确的对应。', progress: '7 /8题', stars: 3, pts: 15, status: _Status.done),
                  const SizedBox(height: 16),
                  _levelCard(context, num: 3, title: '句子填空', sub: '(Blank Filling)', desc: '选择最合适的词语补全餐厅对话。', progress: '7 /8题', stars: 3, pts: 15, status: _Status.done),
                  const SizedBox(height: 16),
                  // ========== Level 4：角色扮演（已通关，双按钮）==========
                  _level4Card(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Level 4 特殊卡片（Review + Replay）----------
  Widget _level4Card(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.dark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.dark, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Column(
        children: [
          // 上半部分
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
                      decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.dark, width: 2)),
                      child: const Center(child: Text('4', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark))),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('第 4 关：点餐角色\n扮演', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark)),
                          Text('(Role Play )', style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
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
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('滴滴叭丢第八地丢记得替换', style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.4)),
                const SizedBox(height: 12),
                dashedLine(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('通关: 8 /10题', style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
                    const Spacer(),
                    const Icon(Icons.star, size: 14, color: AppColors.gold),
                    const Text(' X2 ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.dark)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.purpleTint, borderRadius: BorderRadius.circular(6)),
                      child: const Text('+10 PTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.dark)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 下半部分：双按钮
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(21), bottomRight: Radius.circular(21)),
            ),
            child: Row(
              children: [
                // Review 按钮
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewPage())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: hardShadow(color: AppColors.reviewPurple, radius: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.play_arrow, size: 18, color: AppColors.dark),
                          SizedBox(width: 4),
                          Text('Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Replay 按钮
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RolePlayQuizPage())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: hardShadow(color: AppColors.gold, radius: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.play_arrow, size: 18, color: AppColors.dark),
                          SizedBox(width: 4),
                          Text('Replay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _levelCard(BuildContext context, {required int num, required String title, required String sub, required String desc, required String progress, required int stars, required int pts, required _Status status}) {
    final locked = status == _Status.locked;
    return Opacity(
      opacity: locked ? 0.7 : 1,
      child: Container(
        decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.dark, width: 3), boxShadow: const [BoxShadow(color: AppColors.dark, offset: Offset(4, 4), blurRadius: 0)]),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(21), topRight: Radius.circular(21))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 32, height: 32, decoration: BoxDecoration(color: locked ? AppColors.lightGray : AppColors.blue, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.dark, width: 2)), child: Center(child: Text('$num', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark)))),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('第 $num 关：$title', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark)), Text(sub, style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600))])),
                      if (status == _Status.done)
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFB88A8A), borderRadius: BorderRadius.circular(8)), child: Row(children: const [Icon(Icons.check_circle, size: 12, color: Colors.white), SizedBox(width: 2), Text('已通关', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold))]))
                      else if (locked)
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.dark, width: 1.5)), child: Row(children: const [Icon(Icons.lock, size: 12, color: AppColors.dark), SizedBox(width: 2), Text('未解锁', style: TextStyle(fontSize: 11, color: AppColors.dark, fontWeight: FontWeight.bold))])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(desc, style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4)),
                  const SizedBox(height: 12),
                  dashedLine(),
                  const SizedBox(height: 10),
                  Row(children: [Text('通关: $progress', style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)), const Spacer(), const Icon(Icons.star, size: 14, color: AppColors.gold), Text(' X$stars ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.dark)), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.purpleTint, borderRadius: BorderRadius.circular(6)), child: Text('+$pts PTS', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.dark)))]),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(21), bottomRight: Radius.circular(21))),
              child: locked
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.lock_outline, size: 16, color: Colors.black45), SizedBox(width: 6), Text('请先通关前一关卡', style: TextStyle(fontSize: 14, color: Colors.black45, fontWeight: FontWeight.w600))])
                  : Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), decoration: hardShadow(color: AppColors.gold, radius: 16), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.play_arrow, size: 18, color: AppColors.dark), const SizedBox(width: 4), Text(status == _Status.done ? 'Replay' : 'START', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.dark))])),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _Status { done, play, locked }

// ==================== 页面2：对话回顾（Review）====================
class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  final List<DialogueTurn> dialogue = const [
    DialogueTurn(isWaiter: true, text: '您好，欢迎光临！请坐。您想吃点什么？'),
    DialogueTurn(isWaiter: false, text: '请给我菜单。', isCorrect: true, optionLabel: 'B.请给我菜单。'),
    DialogueTurn(isWaiter: true, text: '好的，这是菜单。\n您想喝点什么？'),
    DialogueTurn(isWaiter: false, text: '我想喝茶。', isCorrect: true, optionLabel: 'A.我想喝茶。'),
    DialogueTurn(isWaiter: true, text: '好的，一杯茶。那您想吃什么菜？我们有鱼香肉丝、麻婆豆腐、炒青菜。'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  circleBtn(icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  const Text('对话回顾（Review）', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.dark)),
                ],
              ),
            ),
            // 对话卡片
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  decoration: hardShadow(radius: 32, borderWidth: 3.5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          ...dialogue.map((turn) => _buildTurn(turn)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 底部按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: hardShadow(color: AppColors.blue, radius: 16, borderWidth: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('完成', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                      SizedBox(width: 6),
                      Text('Done', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                      SizedBox(width: 8),
                      Icon(Icons.chevron_right, color: AppColors.dark, size: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTurn(DialogueTurn turn) {
    if (turn.isWaiter) {
      // 服务员（左侧）
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头像
            Container(
              width: 44,
              height: 44,
              decoration: hardShadow(color: AppColors.purpleTint, shape: BoxShape.circle, borderWidth: 2),
              child: const Icon(Icons.person_outline, color: AppColors.dark, size: 24),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.waiterBubble,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(color: AppColors.dark, width: 2),
                ),
                child: Text(
                  turn.text,
                  style: const TextStyle(fontSize: 15, color: AppColors.dark, height: 1.5, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(width: 40), // 右侧留白对齐
          ],
        ),
      );
    } else {
      // 用户（右侧）
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 40), // 左侧留白
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: AppColors.dark, width: 2),
                  ),
                  child: Text(
                    turn.optionLabel ?? turn.text,
                    style: const TextStyle(fontSize: 15, color: AppColors.white, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            if (turn.isCorrect == true)
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check, size: 14, color: AppColors.green),
                    SizedBox(width: 4),
                    Text('CORRECT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.green)),
                  ],
                ),
              ),
          ],
        ),
      );
    }
  }
}

// ==================== 页面3：角色扮演答题页 ====================
class RolePlayQuizPage extends StatefulWidget {
  const RolePlayQuizPage({super.key});

  @override
  State<RolePlayQuizPage> createState() => _RolePlayQuizPageState();
}

class _RolePlayQuizPageState extends State<RolePlayQuizPage> {
  int? selectedIndex;
  bool hasAnswered = false;

  final RolePlayQuestion question = const RolePlayQuestion(
    levelIndicator: 'LEVEL 4 / 4',
    title: '点餐角色扮演',
    titleEn: '(Role Play)',
    questionCounter: '3 / 6',
    progress: 0.5,
    history: [
      DialogueTurn(isWaiter: true, text: '您好，欢迎光临！请坐。您想吃点什么？'),
      DialogueTurn(isWaiter: false, text: '请给我菜单。', isCorrect: true, optionLabel: 'B.请给我菜单。'),
      DialogueTurn(isWaiter: true, text: '好的，这是菜单。\n您想喝点什么？'),
      DialogueTurn(isWaiter: false, text: '我想喝茶。', isCorrect: true, optionLabel: 'A.我想喝茶。'),
      DialogueTurn(isWaiter: true, text: '好的，一杯茶。那您想吃什么菜？我们有鱼香肉丝、麻婆豆腐、炒青菜。'),
    ],
    instruction: '角色扮演：针对服务员的对话作答',
    currentQuestion: '好的，一杯茶。那您想吃点什么菜？我们有鱼香肉丝、麻婆豆腐、炒青菜。',
    options: [
      OptionData('A', '我要一份炒青菜和一碗米饭。'),
      OptionData('B', '我喜欢蛋糕', isCorrect: false), // 模拟错误答案
      OptionData('C', '多少钱？'),
    ],
    feedbackTitle: '× 回答不严谨 (Incorrect)',
    feedbackDetail: '“蛋糕（cake）通常是甜点或下午茶。而在中餐饭店，一般先要点热菜下饭。”',
  );

  void _onSelect(int index) {
    if (hasAnswered) return;
    setState(() {
      selectedIndex = index;
      hasAnswered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      circleBtn(icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(question.levelIndicator, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black45, letterSpacing: 1)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(question.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.dark)),
                              const SizedBox(width: 8),
                              Text(question.titleEn, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade400, width: 2)),
                        child: Text(question.questionCounter, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 进度条
                  Container(
                    height: 14,
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.dark, width: 2.5)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: question.progress, child: Container(color: AppColors.blue)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ---------- 主体滚动区 ----------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // ===== 历史对话卡片 =====
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: hardShadow(radius: 28, borderWidth: 3.5),
                      child: Column(
                        children: question.history.map((turn) => _buildHistoryTurn(turn)).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ===== 当前题目卡片 =====
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: hardShadow(radius: 28, borderWidth: 3.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(question.instruction, style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10),
                          Text(question.currentQuestion, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.dark, height: 1.4)),
                          const SizedBox(height: 20),
                          dashedLine(),
                          const SizedBox(height: 20),

                          // 选项
                          ...List.generate(question.options.length, (i) {
                            final opt = question.options[i];
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
                                  decoration: hardShadow(color: bg, radius: 16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.dark, width: 2)),
                                        child: Center(child: Text(opt.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark))),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          opt.text,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: showWrong ? AppColors.white : (showCorrect ? AppColors.dark : Colors.black54),
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),

                          // 反馈
                          if (hasAnswered) ...[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.lightRed,
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
                                        decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                                        child: const Icon(Icons.close, size: 18, color: Colors.white),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(question.feedbackTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(question.feedbackDetail, style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500, height: 1.5)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

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
                    decoration: hardShadow(color: AppColors.blue, radius: 16, borderWidth: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(hasAnswered ? '下一题' : '确认提交', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                        const SizedBox(width: 6),
                        Text(hasAnswered ? 'Next Question' : 'Submit Answer', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: AppColors.dark, size: 24),
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

  Widget _buildHistoryTurn(DialogueTurn turn) {
    if (turn.isWaiter) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: hardShadow(color: AppColors.purpleTint, shape: BoxShape.circle, borderWidth: 2),
              child: const Icon(Icons.person_outline, color: AppColors.dark, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.waiterBubble,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(color: AppColors.dark, width: 2),
                ),
                child: Text(turn.text, style: const TextStyle(fontSize: 14, color: AppColors.dark, height: 1.5, fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(width: 36),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const SizedBox(width: 36),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: AppColors.dark, width: 2),
                  ),
                  child: Text(
                    turn.optionLabel ?? turn.text,
                    style: const TextStyle(fontSize: 14, color: AppColors.white, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            if (turn.isCorrect == true)
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check, size: 13, color: AppColors.green),
                    SizedBox(width: 4),
                    Text('CORRECT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.green)),
                  ],
                ),
              ),
          ],
        ),
      );
    }
  }
}