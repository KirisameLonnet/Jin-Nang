import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di.dart';
import '../../../core/models/level.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/app_safe_area.dart';
import '../../../widgets/pressable.dart';

class ReviewScreen extends StatefulWidget {
  final int levelId;
  final int sceneId;
  const ReviewScreen({super.key, required this.levelId, required this.sceneId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<DialogueTurn>? _dialogue;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDialogue();
  }

  Future<void> _loadDialogue() async {
    try {
      final levels = await Di.api.getSceneLevels(widget.sceneId);
      if (!mounted) return;
      final level = levels.firstWhere((l) => l.id == widget.levelId).enrichForLocal();
      final turns = <DialogueTurn>[];
      for (final q in level.questions) {
        turns.addAll(q.history);
        // Add the waiter's current question as a turn
        if (q.currentQuestion != null) {
          turns.add(DialogueTurn(isWaiter: true, text: q.currentQuestion!));
        }
        // Add the user's correct response if available
        if (q.correctIndex >= 0 && q.correctIndex < q.options.length) {
          final label = String.fromCharCode(65 + q.correctIndex);
          turns.add(DialogueTurn(
            isWaiter: false,
            text: q.options[q.correctIndex],
            isCorrect: true,
            optionLabel: '$label.${q.options[q.correctIndex]}',
          ));
        }
      }
      setState(() => _dialogue = turns);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/study/dialogue-practice/${widget.sceneId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Column(
        children: [
          const SizedBox(height: 48),
          _buildTopBar(),
          const Spacer(),
          Text(_error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.quizError)),
          const Spacer(),
        ],
      );
    }
    if (_dialogue == null) {
      return Column(
        children: [
          const SizedBox(height: 48),
          _buildTopBar(),
          const Spacer(),
          const CircularProgressIndicator(),
          const Spacer(),
        ],
      );
    }
    return Column(
      children: [
        const SizedBox(height: 48),
        _buildTopBar(),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.morandiText, width: 3),
                boxShadow: const [
                  BoxShadow(color: AppColors.morandiText, offset: Offset(5, 5), blurRadius: 0),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: _dialogue!.map((turn) => _buildTurn(turn)).toList(),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
          child: Pressable(
            onPressed: _goBack,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.baliHai30,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.morandiText, width: 3),
                boxShadow: const [
                  BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('完成', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
                  SizedBox(width: 6),
                  Text('Done', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: AppColors.morandiText, size: 22),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          _buildCircleBackBtn(),
          const SizedBox(width: 12),
          const Text('对话回顾（Review）',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
        ],
      ),
    );
  }

  Widget _buildCircleBackBtn() {
    return Pressable(
      onPressed: _goBack,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.morandiText, width: 2.5),
          boxShadow: const [
            BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0),
          ],
        ),
        child: const Icon(Icons.arrow_back, color: AppColors.morandiText, size: 20),
      ),
    );
  }

  Widget _buildTurn(DialogueTurn turn) {
    if (turn.isWaiter) {
      // Waiter (left side)
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.whisper15,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.morandiText, width: 2),
              ),
              child: const Icon(Icons.person_outline, color: AppColors.morandiText, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.whisper15,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(color: AppColors.morandiText, width: 2),
                ),
                child: Text(turn.text,
                    style: const TextStyle(fontSize: 14, color: AppColors.morandiText, height: 1.5, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      );
    } else {
      // User (right side)
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const SizedBox(width: 40),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
                  decoration: BoxDecoration(
                    color: AppColors.baliHai30,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: AppColors.morandiText, width: 2),
                  ),
                  child: Text(
                    turn.optionLabel ?? turn.text,
                    style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            if (turn.isCorrect == true)
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check, size: 13, color: AppColors.quizCorrect),
                    SizedBox(width: 4),
                    Text('CORRECT',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.quizCorrect)),
                  ],
                ),
              ),
          ],
        ),
      );
    }
  }
}
