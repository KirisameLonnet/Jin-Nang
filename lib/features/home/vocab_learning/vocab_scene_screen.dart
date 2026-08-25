import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di.dart';
import '../../../core/models/scene.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_safe_area.dart';
import '../../../widgets/selectable_card.dart';
import '../../../l10n/l10n.dart';

class VocabSceneScreen extends StatefulWidget {
  const VocabSceneScreen({super.key});

  @override
  State<VocabSceneScreen> createState() => _VocabSceneScreenState();
}

class _VocabSceneScreenState extends State<VocabSceneScreen> {
  List<Scene>? _scenes;
  String? _error;

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/study');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadScenes();
  }

  Future<void> _loadScenes() async {
    try {
      final scenes = await Di.api.getScenes();
      if (!mounted) return;
      setState(() => _scenes = scenes);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: Stack(
          children: [
            // Scrollable scene cards (behind header)
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  176,
                  AppSpacing.lg,
                  0,
                ),
                child: _buildBody(context),
              ),
            ),
            // Fixed header (on top)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColors.springWood14,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    AppHeader(
                      title: context.l10n.vocabLearningSingleLine,
                      titleColor: AppColors.straw14,
                      onBack: _goBack,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      context.l10n.selectScene,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.morandiText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Text(
          context.l10n.loadFailed,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.semanticRed,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    if (_scenes == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      clipBehavior: Clip.none,
      children: [
        ..._scenes!.map(
          (scene) => Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: SelectableCard(
              title: context.usesChinese ? scene.nameZh : scene.nameEn,
              subtitle: localizeSceneSubtitle(context, scene.nameEn),
              icon: _iconForScene(scene.nameEn),
              color: _colorFromHex(scene.colorHex),
              onTap: scene.isUnlockedDefault
                  ? () => context.push('/study/vocab-battle/${scene.id}')
                  : null,
              onLockedTap: scene.isUnlockedDefault
                  ? null
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.sceneComingSoon),
                        duration: const Duration(seconds: 2),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  IconData _iconForScene(String name) {
    switch (name.toLowerCase()) {
      case 'restaurant':
        return Icons.local_cafe;
      case 'supermarket':
        return Icons.shopping_cart;
      case 'airport':
        return Icons.flight;
      default:
        return Icons.place;
    }
  }

  Color _colorFromHex(String hex) {
    final value = int.tryParse(hex.replaceFirst('#', ''), radix: 16);
    return value != null ? Color(0xFF000000 | value) : AppColors.baliHai30;
  }
}
