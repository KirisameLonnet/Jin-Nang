import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 虚线分隔符，用于短语卡片中分隔拼音和英文。
class DashedDivider extends StatelessWidget {
  final Color color;

  const DashedDivider({super.key, this.color = AppColors.mercury25});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 6.0;
        const dashSpace = 4.0;
        final count = constraints.maxWidth / (dashWidth + dashSpace);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(count.floor(), (_) {
            return Container(width: dashWidth, height: 2, color: color);
          }),
        );
      },
    );
  }
}
