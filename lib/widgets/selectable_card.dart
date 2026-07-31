import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'pressable.dart';

/// 可点击的场景/工具卡片，支持锁定状态。
///
/// onTap == null 时显示锁定态（opacity 0.45 + 锁图标 + 无阴影）。
/// onLockedTap 在锁定态下仍可响应点击（用于 coming soon 提示），不影响视觉。
class SelectableCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final VoidCallback? onLockedTap;

  const SelectableCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
    this.onLockedTap,
  });

  bool get _isLocked => onTap == null;

  @override
  Widget build(BuildContext context) {
    // 全部统一：卡片背景白色，图标框彩色
    final cardBg = Colors.white;
    final iconBg = color;

    final card = Pressable(
      onPressed: onTap,
      child: Container(
        width: double.infinity,
        height: 188,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          border: Border.all(
            color: AppColors.morandiText,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isLocked
              ? null
              : const [
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
                color: iconBg,
                border: Border.all(
                  color: AppColors.morandiText,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 28,
                color: AppColors.morandiText,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.morandiText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.morandiText.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLocked)
              const Icon(
                Icons.lock,
                size: 24,
                color: AppColors.naturalGray19,
              ),
          ],
        ),
      ),
    );

    if (_isLocked) {
      final locked = Opacity(opacity: 0.45, child: card);
      if (onLockedTap != null) {
        return GestureDetector(onTap: onLockedTap, child: locked);
      }
      return locked;
    }

    return card;
  }
}
