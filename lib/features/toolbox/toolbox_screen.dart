import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  // 后续可扩展为从 API 根据 widget.sceneId 加载 Topic 数据
  final Topic topic = demoTopic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              AppHeader(
                title: 'Restaurant',
                titleColor: AppColors.straw14,
                onBack: () { if (Navigator.of(context).canPop()) { context.pop(); } else { context.go('/toolbox'); } },
              ),
              const SizedBox(height: 24),
              // 深色横幅
              AppCard(
                color: AppColors.morandiText,
                borderRadius: 20,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                    const SizedBox(width: 16),
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
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, i) {
                    final ch = topic.chapters[i];
                    return Pressable(
                      onPressed: () => context.push('/toolbox/chapter/$i'),
                      child: AppCard(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.baliHai30,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.morandiText, width: 2),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.morandiText,
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ch.title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.morandiText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${ch.sentenceCount} sentences',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.naturalGray19,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.morandiText, size: 28),
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
