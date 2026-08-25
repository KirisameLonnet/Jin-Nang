import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/di.dart';
import '../../core/models/phrase.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_safe_area.dart';
import '../../widgets/pressable.dart';

class ToolboxScreen extends StatefulWidget {
  final int sceneId;

  const ToolboxScreen({super.key, required this.sceneId});

  @override
  State<ToolboxScreen> createState() => _ToolboxScreenState();
}

class _ToolboxScreenState extends State<ToolboxScreen> {
  Topic? _topic;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTopic();
  }

  Future<void> _loadTopic() async {
    try {
      final topic = await Di.api.getScenePhrases(widget.sceneId);
      if (!mounted) return;
      setState(() {
        _topic = topic;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    }
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/toolbox');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final topic = _topic;
    if (topic == null) {
      return Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          AppHeader(
            title: 'Useful Phrases',
            titleColor: AppColors.straw14,
            onBack: _goBack,
          ),
          const Spacer(),
          if (_error != null) ...[
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.semanticRed,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Pressable(onPressed: _loadTopic, child: const Text('Retry')),
          ] else
            const CircularProgressIndicator(),
          const Spacer(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xxl),
        AppHeader(
          title: topic.sceneNameEn,
          titleColor: AppColors.straw14,
          onBack: _goBack,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          color: AppColors.morandiText,
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.straw14,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(topic.icon, color: AppColors.morandiText, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.category,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.straw14,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
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
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: ListView.separated(
            clipBehavior: Clip.none,
            itemCount: topic.chapters.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final chapter = topic.chapters[index];
              return Pressable(
                onPressed: () => context.push(
                  '/toolbox/${widget.sceneId}/chapter/$index',
                  extra: topic,
                ),
                child: AppCard(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.baliHai30,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.morandiText,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.morandiText,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${chapter.index}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chapter.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: AppColors.morandiText,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              '${chapter.sentenceCount} sentences',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.naturalGray19,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.morandiText,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
