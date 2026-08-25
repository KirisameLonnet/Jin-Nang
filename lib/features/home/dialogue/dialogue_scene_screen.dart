import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di.dart';
import '../../../core/models/scene.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_safe_area.dart';
import '../../../widgets/selectable_card.dart';

class DialogueSceneScreen extends StatefulWidget {
  const DialogueSceneScreen({super.key});

  @override
  State<DialogueSceneScreen> createState() => _DialogueSceneScreenState();
}

class _DialogueSceneScreenState extends State<DialogueSceneScreen> {
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
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 176, AppSpacing.lg, 0),
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
                      title: 'Dialogue Practice',
                      titleColor: AppColors.baliHai30,
                      onBack: _goBack,
                    ),
                    const SizedBox(height: 32),
                    const Text('Select a scene',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
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
        child: Text(_error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.semanticRed, fontWeight: FontWeight.w600)),
      );
    }
    if (_scenes == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      clipBehavior: Clip.none,
      children: [
        ..._scenes!.map((scene) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: SelectableCard(
                title: scene.nameEn,
                subtitle: scene.subtitleEn,
                icon: _iconForScene(scene.nameEn),
                color: _colorFromHex(scene.colorHex),
                onTap: scene.isUnlockedDefault
                    ? () {
                        final pageTitle = _dialoguePageTitle(scene.nameZh);
                        context.push('/study/dialogue-practice/${scene.id}?sceneName=${Uri.encodeComponent(scene.nameEn)}&sceneNameZh=${Uri.encodeComponent(pageTitle)}');
                      }
                    : null,
                onLockedTap: scene.isUnlockedDefault
                    ? null
                    : () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('This scene is coming soon.'),
                            duration: Duration(seconds: 2),
                          ),
                        ),
              ),
            )),
        const SizedBox(height: 48),
      ],
    );
  }

  IconData _iconForScene(String name) {
    switch (name.toLowerCase()) {
      case 'restaurant': return Icons.restaurant;
      case 'supermarket': return Icons.shopping_cart;
      case 'airport': return Icons.flight;
      default: return Icons.place;
    }
  }

  String _dialoguePageTitle(String nameZh) {
    switch (nameZh) {
      case '餐厅': return '餐厅点餐';
      case '超市': return '超市购物';
      case '机场': return '机场出行';
      default: return nameZh;
    }
  }

  Color _colorFromHex(String hex) {
    final value = int.tryParse(hex.replaceFirst('#', ''), radix: 16);
    return value != null ? Color(0xFF000000 | value) : AppColors.baliHai30;
  }
}
