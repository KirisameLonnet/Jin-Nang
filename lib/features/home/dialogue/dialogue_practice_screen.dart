import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di.dart';
import '../../../core/models/level.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/app_safe_area.dart';
import '../../../widgets/dashed_divider.dart';
import '../../../widgets/pressable.dart';
import '../../../l10n/l10n.dart';

class DialoguePracticeScreen extends StatefulWidget {
  final int sceneId;
  final String sceneName;
  final String sceneNameZh;
  const DialoguePracticeScreen({
    super.key,
    required this.sceneId,
    this.sceneName = '',
    this.sceneNameZh = '',
  });

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
      body: AppSafeArea(child: _buildBody()),
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
              child: Text(
                context.l10n.loadFailed,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.semanticRed,
                ),
              ),
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
              ..._levels!.map(
                (l) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildLevelCard(l),
                ),
              ),
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
    final hasRolePlay = level.questions.any(
      (q) => q.type == QuestionType.rolePlay,
    );

    return Opacity(
      opacity: locked ? 0.65 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whisper15,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.morandiText, width: 3),
          boxShadow: const [
            BoxShadow(
              color: AppColors.morandiText,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
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
                          color: locked
                              ? AppColors.mercury25
                              : AppColors.baliHai30,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.morandiText,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${level.levelNum}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.morandiText,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.levelTitle(
                                    level.levelNum,
                                    _levelTitle(level),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.morandiText,
                                  ),
                                ),
                              ],
                            ),
                            if (done)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: _buildStatusBadge(
                                  context.l10n.passed,
                                  Icons.check_circle,
                                  AppColors.oldRose15,
                                ),
                              )
                            else if (locked)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: _buildStatusBadge(
                                  context.l10n.locked,
                                  Icons.lock,
                                  AppColors.mercury25,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _levelDescription(level),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const DashedDivider(color: AppColors.mercury25),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        context.l10n.passProgress(
                          level.stars > 0
                              ? (level.bestScore / 100 * totalQ).round()
                              : 0,
                          totalQ,
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.straw14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        context.l10n.starCount(level.stars),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppColors.morandiText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lavenderPurple.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.lavenderPurple,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          context.l10n.rewardPoints(level.pointsReward),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: AppColors.lavenderPurple,
                          ),
                        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
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
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 15,
                          color: Colors.black38,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.l10n.completePreviousLevel,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black38,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Pressable(
            onPressed: () => context.push(
              '/study/level/${level.id}/review?sceneId=${widget.sceneId}',
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFD6C6F5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.morandiText, width: 2.5),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.morandiText,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_arrow,
                    size: 18,
                    color: AppColors.morandiText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.review,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.morandiText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Pressable(
            onPressed: () => _startLevel(level),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.straw14,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.morandiText, width: 2.5),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.morandiText,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_arrow,
                    size: 18,
                    color: AppColors.morandiText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.replay,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.morandiText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleActionBtn(Level level, bool done) {
    return Align(
      alignment: Alignment.centerRight,
      child: Pressable(
        onPressed: () => _startLevel(level),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.straw14,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.morandiText, width: 2.5),
            boxShadow: const [
              BoxShadow(
                color: AppColors.morandiText,
                offset: Offset(3, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.play_arrow,
                size: 18,
                color: AppColors.morandiText,
              ),
              const SizedBox(width: 4),
              Text(
                done ? context.l10n.replay : context.l10n.start,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _levelTitle(Level level) {
    return switch (level.levelNum) {
      1 => context.l10n.vocabMatch,
      2 => context.l10n.listeningChoice,
      3 => context.l10n.blankFilling,
      4 => context.l10n.rolePlay,
      _ => level.title,
    };
  }

  String _levelDescription(Level level) {
    return switch (level.levelNum) {
      1 => context.l10n.vocabMatchDescription,
      2 => context.l10n.listeningChoiceDescription,
      3 => context.l10n.blankFillingDescription,
      4 => context.l10n.rolePlayDescription,
      _ => context.l10n.unlockNextLevelDescription,
    };
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
            Icon(
              icon,
              size: 11,
              color: bgColor == AppColors.mercury25
                  ? AppColors.morandiText
                  : Colors.white,
            ),
            const SizedBox(width: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: bgColor == AppColors.mercury25
                    ? AppColors.morandiText
                    : Colors.white,
              ),
            ),
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
    this.sceneNameZh = '',
    this.sceneName = '',
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
            child: _buildBanner(context),
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
                BoxShadow(
                  color: AppColors.morandiText,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Text(
                sceneNameZh.isEmpty ? context.l10n.selectScene : sceneNameZh,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildPtsBadge(context),
      ],
    );
  }

  Widget _buildBackBtn(BuildContext context) {
    return Pressable(
      onPressed:
          onBack ??
          () {
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
            BoxShadow(
              color: AppColors.morandiText,
              offset: Offset(6, 6),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Icon(Icons.arrow_back, color: AppColors.morandiText),
      ),
    );
  }

  Widget _buildPtsBadge(BuildContext context) {
    return Transform.rotate(
      angle: 0.07, // ~4 degrees
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.straw14,
          border: Border.all(color: AppColors.morandiText, width: 2),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: AppColors.morandiText,
              offset: Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome,
              size: 14,
              color: AppColors.morandiText,
            ),
            const SizedBox(width: 4),
            Text(
              context.l10n.points(totalPts),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.morandiText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
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
                Text(
                  context.l10n.questModule(
                    sceneNameZh.isEmpty
                        ? context.l10n.selectScene
                        : sceneNameZh,
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.questRewardHint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
