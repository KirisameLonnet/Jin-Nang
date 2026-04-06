import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      color: AppColors.neutralGray01,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context: context,
            imagePath: 'assets/images/Icon-Study.png',
            label: 'Study',
            index: 0,
          ),
          _buildNavItem(
            context: context,
            imagePath: 'assets/images/Icon-Toolbox.png',
            label: 'Toolbox',
            index: 1,
          ),
          _buildNavItem(
            context: context,
            imagePath: 'assets/images/Icon-Me.png',
            label: 'Me',
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required String imagePath,
    required String label,
    required int index,
  }) {
    final isSelected = navigationShell.currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        // Remove default opaque layout hit testing issues
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.brandPurple.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Image.asset(
                imagePath,
                width: 24, // reduced slightly to prevent overflow
                height: 24,
                fit: BoxFit.contain,
                color: isSelected ? AppColors.brandPurple : AppColors.neutralGray05,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? AppColors.brandPurple
                        : AppColors.neutralGray05,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
