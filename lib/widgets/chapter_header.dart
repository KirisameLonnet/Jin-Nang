import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'pressable.dart';

/// 章节页面专用顶部导航栏：返回按钮 + 可倾斜的标题标签 + 可选进度计数。
///
/// 与 [AppHeader] 的区别：标题文字会逆时针旋转 1°，营造手账贴纸感。
/// 返回按钮不受影响，保持水平。
class ChapterHeader extends StatelessWidget {
  final String title;
  final String? progress;
  final VoidCallback onBack;
  final Color titleColor;
  final double tiltAngle;

  const ChapterHeader({
    super.key,
    required this.title,
    this.progress,
    required this.onBack,
    this.titleColor = AppColors.baliHai30,
    this.tiltAngle = -0.00945,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 返回按钮：保持水平，不旋转
        Pressable(
          onPressed: onBack,
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
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.morandiText,
            ),
          ),
        ),
        const SizedBox(width: 24),
        // 标题：单独包旋转
        Expanded(
          child: Transform.rotate(
            angle: tiltAngle,
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: titleColor,
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
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: AppColors.morandiText,
                    letterSpacing: 1.2,
                  ),
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
              borderRadius: BorderRadius.circular(12),
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
          const SizedBox(width: 59),
      ],
    );
  }
}