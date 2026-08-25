import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'pressable.dart';

/// 圆形音频播放按钮，用于短语卡片。
///
/// 复用 Pressable 获得统一的点击反馈和音效。
class AudioButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AudioButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPressed: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.35 : 1,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.baliHai30,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.morandiText, width: 2),
            boxShadow: onTap == null
                ? null
                : const [
                    BoxShadow(
                      color: AppColors.morandiText,
                      offset: Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
          ),
          child: const Icon(Icons.volume_up, color: Colors.black, size: 22),
        ),
      ),
    );
  }
}
