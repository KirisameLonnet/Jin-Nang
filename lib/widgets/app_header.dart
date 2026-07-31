import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'pressable.dart';

/// 页面顶部导航栏：返回按钮 + 标题标签 + 可选进度计数。
///
/// 用于次级页面（Vocab Scene、Dialogue Practice、Vocab Battle 等）。
class AppHeader extends StatelessWidget {
  final String title;
  final String? progress;
  final VoidCallback onBack;
  final Color titleColor;

  const AppHeader({
    super.key,
    required this.title,
    this.progress,
    required this.onBack,
    this.titleColor = AppColors.baliHai30,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Pressable(
          onPressed: onBack,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.morandiText, width: 3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.morandiText,
                  offset: Offset(3, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.morandiText,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: titleColor,
              border: Border.all(color: AppColors.morandiText, width: 3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.morandiText,
                  offset: Offset(3, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                ),
              ),
            ),
          ),
        ),
        if (progress != null) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.morandiText, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              progress!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.morandiText,
              ),
            ),
          ),
        ] else
          const SizedBox(width: 56),
      ],
    );
  }
}
