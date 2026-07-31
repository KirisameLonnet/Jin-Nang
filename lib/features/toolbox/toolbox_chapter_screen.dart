import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/phrase.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_safe_area.dart';
import '../../widgets/audio_button.dart';
import '../../widgets/dashed_divider.dart';
import '../../widgets/pressable.dart';

class ToolboxChapterScreen extends StatefulWidget {
  final Topic topic;
  final int initialChapter;

  const ToolboxChapterScreen({
    super.key,
    required this.topic,
    this.initialChapter = 0,
  });

  @override
  State<ToolboxChapterScreen> createState() => _ToolboxChapterScreenState();
}

class _ToolboxChapterScreenState extends State<ToolboxChapterScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  List<Chapter> get _chapters => widget.topic.chapters;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialChapter.clamp(0, _chapters.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    if (index < 0 || index >= _chapters.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // 顶部：返回 + 横向 SlideBar 章节选择器
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Pressable(
                    onPressed: () => context.go('/toolbox'),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.morandiText, width: 2.5),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.morandiText,
                            offset: Offset(3, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.morandiText),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _chapters.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          final isActive = i == _currentIndex;
                          return Pressable(
                            onPressed: () => _goToPage(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.straw14 : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.morandiText, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.morandiText,
                                    offset: Offset(0, isActive ? 4 : 3),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Chapter ${_chapters[i].index}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: isActive ? AppColors.morandiText : AppColors.naturalGray19,
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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _chapters[_currentIndex].title,
                    key: ValueKey(_currentIndex),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.morandiText,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 短语列表 PageView（支持左右滑动切换章节）
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemCount: _chapters.length,
                itemBuilder: (context, pageIndex) {
                  final chapter = _chapters[pageIndex];
                  return ListView.separated(
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    itemCount: chapter.phrases.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, i) {
                      final p = chapter.phrases[i];
                      return AppCard(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.chinese,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.morandiText,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    p.pinyin,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.lavenderPurple,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const DashedDivider(),
                                  const SizedBox(height: 10),
                                  Text(
                                    p.english,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.naturalGray19,
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
                                  // TODO: 接入音频播放
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
            // 底部 Prev / Next
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Pressable(
                      onPressed: _currentIndex > 0 ? () => _goToPage(_currentIndex - 1) : null,
                      child: AppCard(
                        color: Colors.white,
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              size: 20,
                              color: _currentIndex > 0 ? AppColors.morandiText : AppColors.mercury25,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Prev',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: _currentIndex > 0 ? AppColors.morandiText : AppColors.mercury25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Pressable(
                      onPressed: () {
                        if (_currentIndex < _chapters.length - 1) {
                          _goToPage(_currentIndex + 1);
                        } else {
                          context.go('/toolbox');
                        }
                      },
                      child: AppCard(
                        color: _currentIndex < _chapters.length - 1 ? AppColors.straw14 : AppColors.baliHai30,
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentIndex < _chapters.length - 1 ? 'Next' : 'Finish',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: _currentIndex < _chapters.length - 1 ? AppColors.morandiText : Colors.white,
                              ),
                            ),
                            if (_currentIndex < _chapters.length - 1) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward, size: 20, color: AppColors.morandiText),
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
