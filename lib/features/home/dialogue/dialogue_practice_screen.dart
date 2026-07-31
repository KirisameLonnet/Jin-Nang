import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di.dart';
import '../../../core/models/level.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_safe_area.dart';
import '../../../widgets/pressable.dart';

const _levelIcons = [
  Icons.extension,
  Icons.hearing,
  Icons.edit_note,
  Icons.emoji_events,
];

const _levelColors = [
  AppColors.baliHai30,
  AppColors.lavenderPurple,
  AppColors.straw14,
  AppColors.oldRose15,
];

class DialoguePracticeScreen extends StatefulWidget {
  final int sceneId;
  const DialoguePracticeScreen({super.key, required this.sceneId});

  @override
  State<DialoguePracticeScreen> createState() => _DialoguePracticeScreenState();
}

class _DialoguePracticeScreenState extends State<DialoguePracticeScreen> {
  List<Level>? _levels;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    try {
      final levels = await Di.api.getSceneLevels(widget.sceneId);
      if (!mounted) return;
      setState(() => _levels = levels);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.springWood14,
      child: AppSafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_error != null) {
      return Column(
        children: [
          const SizedBox(height: 48),
          AppHeader(
            title: 'Dialogue Practice',
            onBack: () { if (Navigator.of(context).canPop()) { context.pop(); } else { context.go('/study/dialogue-scene'); } },
          ),
          const Spacer(),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.semanticRed,
            ),
          ),
          const Spacer(),
        ],
      );
    }

    if (_levels == null) {
      return Column(
        children: [
          const SizedBox(height: 48),
          AppHeader(
            title: 'Dialogue Practice',
            onBack: () { if (Navigator.of(context).canPop()) { context.pop(); } else { context.go('/study/dialogue-scene'); } },
          ),
          const Spacer(),
          const CircularProgressIndicator(),
          const Spacer(),
        ],
      );
    }

    final completedCount = _levels!.where((l) => l.stars > 0).length;

    return Column(
      children: [
        const SizedBox(height: 48),
        AppHeader(
          title: 'Dialogue Practice',
          onBack: () { if (Navigator.of(context).canPop()) { context.pop(); } else { context.go('/study/dialogue-scene'); } },
        ),
        const SizedBox(height: 32),
        _buildProgressSummary(completedCount),
        const SizedBox(height: 32),
        Expanded(
          child: ListView(
            clipBehavior: Clip.none,
            children: [
              ..._levels!.map((level) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildLevelCard(context, level),
                  )),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSummary(int completedCount) {
    final total = _levels!.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.morandiText,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.straw14,
              border: Border.all(color: AppColors.morandiText, width: 2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 28,
              color: AppColors.morandiText,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.morandiText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$completedCount / $total levels completed',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.morandiText.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(total, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        i < completedCount ? Icons.star : Icons.star_border,
                        size: 16,
                        color: i < completedCount ? AppColors.straw14 : AppColors.mercury25,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, Level level) {
    final iconIndex = (level.levelNum - 1).clamp(0, _levelIcons.length - 1);
    final icon = _levelIcons[iconIndex];
    final color = _levelColors[iconIndex];

    return Pressable(
      onPressed: level.isUnlocked
          ? () => context.push('/study/level/${level.id}?sceneId=${widget.sceneId}')
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: level.isUnlocked ? color : AppColors.whisper15,
          border: Border.all(
            color: level.isUnlocked
                ? AppColors.morandiText
                : AppColors.shark40.withValues(alpha: 0.2),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: level.isUnlocked
              ? const [
                  BoxShadow(
                    color: AppColors.morandiText,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: level.isUnlocked
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.white,
                border: Border.all(
                  color: level.isUnlocked
                      ? AppColors.morandiText
                      : AppColors.shark40.withValues(alpha: 0.2),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(
                  level.isUnlocked ? icon : Icons.lock,
                  size: 24,
                  color: level.isUnlocked
                      ? AppColors.morandiText
                      : AppColors.shark40.withValues(alpha: 0.3),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: level.isUnlocked
                          ? AppColors.morandiText
                          : AppColors.shark40.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    level.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: level.isUnlocked
                          ? AppColors.stormGray32
                          : AppColors.shark40.withValues(alpha: 0.3),
                    ),
                  ),
                  if (level.isUnlocked && level.stars > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(3, (i) {
                        return Icon(
                          i < level.stars ? Icons.star : Icons.star_border,
                          size: 14,
                          color: i < level.stars ? AppColors.straw14 : AppColors.mercury25,
                        );
                      }),
                    ),
                  ],
                ],
              ),
            ),
            if (level.isUnlocked)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.morandiText,
              )
            else
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.mercury25,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock,
                  size: 14,
                  color: AppColors.shark40,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
