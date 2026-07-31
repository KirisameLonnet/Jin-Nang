import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/pressable.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  static const _navItems = [
    _NavItemData(
      iconPath: 'assets/icon/study.png',
      label: 'STUDY',
      selectedColor: AppColors.straw14,
    ),
    _NavItemData(
      iconPath: 'assets/icon/toolbox.png',
      label: 'TOOLBOX',
      selectedColor: AppColors.baliHai30,
    ),
    _NavItemData(
      iconPath: 'assets/icon/my.png',
      label: 'MY',
      selectedColor: AppColors.oldRose15,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 92,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_navItems.length, (index) {
          return _buildNavItem(
            context: context,
            data: _navItems[index],
            index: index,
          );
        }),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required _NavItemData data,
    required int index,
  }) {
    final isSelected = navigationShell.currentIndex == index;

    return Expanded(
      child: Pressable(
        feedback: PressFeedback.defaultFeedback,
        onPressed: () {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -15),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: isSelected ? 0 : -0.06,
                  end: isSelected ? -0.06 : 0,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutBack,
                builder: (context, angle, child) {
                  return Transform.rotate(
                    angle: angle,
                    alignment: Alignment.center,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: isSelected ? 56 : 65,
                        end: isSelected ? 65 : 56,
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutBack,
                      builder: (context, size, child) {
                        return Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? data.selectedColor
                                : Colors.white,
                            border: Border.all(
                              color: AppColors.morandiText,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(
                              isSelected ? 14 : 12,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.morandiText,
                                offset: Offset(4, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: isSelected ? 22 : 28,
                                end: isSelected ? 28 : 22,
                              ),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOutBack,
                              builder: (context, iconSize, child) {
                                return Image.asset(
                                  data.iconPath,
                                  width: iconSize,
                                  height: iconSize,
                                  color: isSelected
                                      ? AppColors.morandiText
                                      : AppColors.naturalGray19,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -8),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: isSelected ? 0 : -0.06,
                  end: isSelected ? -0.06 : 0,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutBack,
                builder: (context, angle, child) {
                  return Transform.rotate(
                    angle: angle,
                    alignment: Alignment.center,
                    child: Text(
                      data.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: isSelected
                            ? AppColors.morandiText
                            : AppColors.naturalGray19,
                        letterSpacing: 0.5,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  final String iconPath;
  final String label;
  final Color selectedColor;

  const _NavItemData({
    required this.iconPath,
    required this.label,
    required this.selectedColor,
  });
}