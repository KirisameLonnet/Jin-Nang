import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di.dart';
import '../../../core/models/level.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/app_safe_area.dart';
import '../../../widgets/dashed_divider.dart';
import '../../../widgets/pressable.dart';

class DialoguePracticeScreen extends StatefulWidget {
  final int sceneId;
  final String sceneName;
  final String sceneNameZh;
  const DialoguePracticeScreen({super.key, required this.sceneId, this.sceneName = 'Scene', this.sceneNameZh = '场景'});

  @override
  State<DialoguePracticeScreen> createState() => _DialoguePracticeScreenState();
}

class _DialoguePracticeScreenState extends State<DialoguePracticeScreen> {
  List<Level>? _levels;
  String? _error;
  int _totalPts = 0;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    try {
      final levels = await Di.api.getSceneLevels(widget.sceneId);
      if (!mounted) return;
      setState(() {
        _levels = levels;
        _totalPts = levels.fold(0, (sum, l) => sum + l.pointsReward);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/study/dialogue-scene');
    }
  }

  Future<void> _startLevel(Level level) async {
    await context.push('/study/level/${level.id}?sceneId=${widget.sceneId}');
    if (mounted) _loadLevels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null || _levels == null) {
      return Column(
        children: [
          DialoguePracticeHeader(
            sceneNameZh: widget.sceneNameZh,
            sceneName: widget.sceneName,
            totalPts: _totalPts,
            onBack: _goBack,
          ),
          const Spacer(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(_error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.semanticRed)),
            )
          else
            const CircularProgressIndicator(),
          const Spacer(),
        ],
      );
    }
    // Loaded: Stack with fixed header + scrollable level cards
    return Stack(
      children: [
        Positioned(
          top: 240,
          left: 0,
          right: 0,
          bottom: 0,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            children: [
              ..._levels!.map((l) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildLevelCard(l),
                  )),
              const SizedBox(height: 48),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: DialoguePracticeHeader(
            sceneNameZh: widget.sceneNameZh,
            sceneName: widget.sceneName,
            totalPts: _totalPts,
            onBack: _goBack,
          ),
        ),
      ],
    );
  }

  // ── Level card ───────────────────────────────────────────

  Widget _buildLevelCard(Level level) {
    final locked = !level.isUnlocked;
    final done = level.stars > 0;
    final totalQ = level.questions.length;
    final hasRolePlay = level.questions.any((q) => q.type == QuestionType.rolePlay);

    return Opacity(
      opacity: locked ? 0.65 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whisper15,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.morandiText, width: 3),
          boxShadow: const [
            BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(21),
                  topRight: Radius.circular(21),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 26,
                        height: 40,
                        decoration: BoxDecoration(
                          color: locked ? AppColors.mercury25 : AppColors.baliHai30,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.morandiText, width: 2),
                        ),
                        child: Center(
                          child: Text('${level.levelNum}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('第 ${level.levelNum} 关：${_levelTitle(level)}',
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
                                const SizedBox(height: 2),
                                Text(_levelSubtitle(level),
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
                              ],
                            ),
                            if (done)
                              Positioned(top: 0, right: 0, child: _buildStatusBadge('已通关', Icons.check_circle, AppColors.oldRose15))
                            else if (locked)
                              Positioned(top: 0, right: 0, child: _buildStatusBadge('未解锁', Icons.lock, AppColors.mercury25)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(_levelDescription(level),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,color: Colors.black54, height: 1.4)),
                  const SizedBox(height: 12),
                  const DashedDivider(color: AppColors.mercury25),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('通关: ${level.stars > 0 ? '${(level.bestScore / 100 * totalQ).round()}/$totalQ题' : '0/$totalQ题'}',
                          style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      const Icon(Icons.star, size: 14, color: AppColors.straw14),
                      const SizedBox(width: 2),
                      Text('X${level.stars}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.lavenderPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.lavenderPurple, width: 1),
                        ),
                        child: Text('+${level.pointsReward} PTS',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.lavenderPurple)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Separator line between upper and lower sections
            Container(height: 2, color: AppColors.morandiText),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF2F1EC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(21),
                  bottomRight: Radius.circular(21),
                ),
              ),
              child: locked
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Icon(Icons.lock_outline, size: 15, color: Colors.black38),
                        SizedBox(width: 6),
                        Text('请先通关前一关卡',
                            style: TextStyle(fontSize: 13, color: Colors.black38, fontWeight: FontWeight.w700)),
                      ],
                    )
                  : done && hasRolePlay
                      ? _buildDualButtons(level)
                      : _buildSingleActionBtn(level, done),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDualButtons(Level level) {
    return Row(
      children: [
        Expanded(
          child: Pressable(
            onPressed: () => context.push('/study/level/${level.id}/review?sceneId=${widget.sceneId}'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.whisper15,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.morandiText, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.play_arrow, size: 18, color: AppColors.morandiText),
                  SizedBox(width: 4),
                  Text('Review', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Pressable(
            onPressed: () => _startLevel(level),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.straw14,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.morandiText, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.play_arrow, size: 18, color: AppColors.morandiText),
                  SizedBox(width: 4),
                  Text('Replay', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleActionBtn(Level level, bool done) {
    return Align(
      alignment: Alignment.centerRight,
      child: Pressable(
        onPressed: () => _startLevel(level),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.straw14,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.morandiText, width: 2.5),
            boxShadow: const [
              BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_arrow, size: 18, color: AppColors.morandiText),
              const SizedBox(width: 4),
              Text(done ? 'Replay' : 'START',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
            ],
          ),
        ),
      ),
    );
  }

  String _levelTitle(Level level) {
    // CN → return as-is; EN → map to CN
    switch (level.title) {
      case 'Level 1': case 'Vocab Match': return '词汇匹配';
      case 'Level 2': case 'Listen & Choose': return '听力选择';
      case 'Level 3': case 'Fill in Blanks': return '句子填空';
      case 'Challenge': case 'Scenario Sort': return '点餐角色扮演';
      default: return level.title;
    }
  }

  String _levelSubtitle(Level level) {
    switch (level.subtitle) {
      case 'Vocab Match': return '(Vocabulary Match)';
      case 'Listen & Choose': return '(Listening Choice)';
      case 'Fill in Blanks': return '(Blank Filling)';
      case 'Scenario Sort': return '(Role Play)';
      default: return level.subtitle;
    }
  }

  String _levelDescription(Level level) {
    if (level.description.isNotEmpty) return level.description;
    final title = _levelTitle(level);
    switch (title) {
      case '词汇匹配':
        return '识形、知意：选择正确的英文释义或匹配中文词。';
      case '听力选择':
        return '听音知意：播放音频，从备选中文汉字里选择正确的对应。';
      case '句子填空':
        return '选择最合适的词语补全餐厅对话。';
      case '点餐角色扮演':
        return '模拟真实餐厅场景，与服务员进行中文对话练习。';
      default:
        return '完成题目，解锁下一关。';
    }
  }

  Widget _buildStatusBadge(String label, IconData icon, Color bgColor) {
    return Transform.rotate(
      angle: 0.07, // ~4 degrees
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: bgColor == AppColors.mercury25 ? AppColors.morandiText : Colors.white),
            const SizedBox(width: 3),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: bgColor == AppColors.mercury25 ? AppColors.morandiText : Colors.white)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Independent header component
// ═══════════════════════════════════════════════════════════════

class DialoguePracticeHeader extends StatelessWidget {
  final String sceneNameZh;
  final String sceneName;
  final int totalPts;
  final VoidCallback? onBack;

  const DialoguePracticeHeader({
    super.key,
    this.sceneNameZh = '场景',
    this.sceneName = 'Scene',
    this.totalPts = 0,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.springWood14,
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: _buildTopBar(context),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _buildBanner(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        _buildBackBtn(context),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.baliHai30,
              border: Border.all(color: AppColors.morandiText, width: 3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0),
              ],
            ),
            child: Center(
              child: Text(
                sceneNameZh,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.morandiText),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildPtsBadge(),
      ],
    );
  }

  Widget _buildBackBtn(BuildContext context) {
    return Pressable(
      onPressed: onBack ?? () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.morandiText, width: 3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: AppColors.morandiText, offset: Offset(6, 6), blurRadius: 0),
          ],
        ),
        child: const Icon(Icons.arrow_back, color: AppColors.morandiText),
      ),
    );
  }

  Widget _buildPtsBadge() {
    return Transform.rotate(
      angle: 0.07, // ~4 degrees
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.straw14,
          border: Border.all(color: AppColors.morandiText, width: 2),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: AppColors.morandiText, offset: Offset(2, 2), blurRadius: 0),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 14, color: AppColors.morandiText),
            const SizedBox(width: 4),
            Text('$totalPts  PTS',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.morandiText,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.morandiText, width: 3),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.oldRose15,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_outline, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${sceneName.toUpperCase()} QUEST MODULE',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                const SizedBox(height: 4),
                const Text('挑战即可获得金星星与丰厚积分！',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
