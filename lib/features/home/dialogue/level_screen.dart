import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/di.dart';
import '../../../core/models/level.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/app_safe_area.dart';
import '../../../widgets/dashed_divider.dart';
import '../../../widgets/pressable.dart';

class LevelScreen extends StatefulWidget {
  final int levelId;
  final int sceneId;
  const LevelScreen({super.key, required this.levelId, required this.sceneId});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  Level? _level;
  String? _error;

  int _currentQIndex = 0;
  int? _selectedOption;
  bool _hasAnswered = false;
  bool _isCorrect = false;
  int _correctCount = 0;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _loadLevel();
  }

  Future<void> _loadLevel() async {
    try {
      final levels = await Di.api.getSceneLevels(widget.sceneId);
      if (!mounted) return;
      final level = levels.firstWhere((l) => l.id == widget.levelId);
      setState(() => _level = level);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  Question get _currentQ => _level!.questions[_currentQIndex];
  int get _totalQ => _level!.questions.length;
  bool get _isLastQ => _currentQIndex == _totalQ - 1;

  void _selectOption(int index) {
    if (_hasAnswered) return;
    setState(() {
      _selectedOption = index;
      _hasAnswered = true;
      _isCorrect = index == _currentQ.correctIndex;
      if (_isCorrect) _correctCount++;
    });
  }

  void _nextQuestion() {
    if (_isLastQ) {
      final stars = _passed ? min(3, (_accuracy / 33).ceil()) : 0;
      Di.api.submitProgress(widget.levelId, stars, _accuracy.round());
      setState(() => _showResult = true);
    } else {
      setState(() {
        _currentQIndex++;
        _selectedOption = null;
        _hasAnswered = false;
        _isCorrect = false;
      });
    }
  }

  double get _accuracy => _totalQ > 0 ? (_correctCount / _totalQ) * 100 : 0;
  bool get _passed => _accuracy >= (_level?.passThreshold ?? 80);

  void _retry() {
    setState(() {
      _currentQIndex = 0;
      _selectedOption = null;
      _hasAnswered = false;
      _isCorrect = false;
      _correctCount = 0;
      _showResult = false;
    });
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
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.springWood14,
        body: AppSafeArea(
          child: Center(
            child: Text(_error!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.semanticRed)),
          ),
        ),
      );
    }
    if (_level == null) {
      return const Scaffold(
        backgroundColor: AppColors.springWood14,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_showResult) return _buildResultView();
    return _buildQuestionView();
  }

  // ═══════════════════════════════════════════════════════════
  //  QUESTION VIEW
  // ═══════════════════════════════════════════════════════════

  Widget _buildQuestionView() {
    final q = _currentQ;

    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildTopBar(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildProgressBar(),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildQuestionCard(),
                      const SizedBox(height: 16),
                      ...List.generate(q.options.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildOptionButton(i),
                        );
                      }),
                      if (_hasAnswered) ...[
                        const SizedBox(height: 12),
                        _buildFeedbackCard(),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
              child: _buildNextButton(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top bar ──────────────────────────────────────────────

  Widget _buildTopBar() {
    final level = _level!;

    return Row(
      children: [
        _buildCircleBackBtn(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('LEVEL ${level.levelNum} / ${_totalQ > 0 ? _totalQ : 4}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black45, letterSpacing: 1)),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(level.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
                  const SizedBox(width: 8),
                  Text(level.subtitle,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.morandiText, width: 2),
          ),
          child: Text('${_currentQIndex + 1} / $_totalQ',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
        ),
      ],
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

  // ── Progress bar ─────────────────────────────────────────

  Widget _buildProgressBar() {
    final progress = (_currentQIndex + (_hasAnswered ? 1 : 0)) / _totalQ;
    return Container(
      height: 14,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.morandiText, width: 2.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(color: AppColors.baliHai30),
        ),
      ),
    );
  }

  // ── Question card (the big white container) ──────────────

  Widget _buildQuestionCard() {
    final q = _currentQ;

    // Role play: history card + current question card
    if (q.type == QuestionType.rolePlay) {
      return Column(
        children: [
          if (q.history.isNotEmpty) _buildHistoryCard(),
          const SizedBox(height: 16),
          _buildCurrentQuestionCard(q),
        ],
      );
    }

    // Standard question types: single card
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.morandiText, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.morandiText, offset: Offset(5, 5), blurRadius: 0),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuestionArea(q),
            const SizedBox(height: 24),
            const DashedDivider(color: AppColors.mercury25),
          ],
        ),
      ),
    );
  }

  // ── Question area (varies by type) ───────────────────────

  Widget _buildQuestionArea(Question q) {
    switch (q.type) {
      case QuestionType.listeningChoice:
        return _buildListeningArea(q);
      case QuestionType.blankFilling:
        return _buildBlankFillingArea(q);
      case QuestionType.rolePlay:
        return _buildRolePlayArea(q);
      case QuestionType.vocabularyMatch:
        return _buildVocabMatchArea(q);
    }
  }

  Widget _buildVocabMatchArea(Question q) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (q.instruction != null) ...[
                Text(q.instruction!,
                    style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
              ],
              Text(q.mainText ?? q.questionText,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
            ],
          ),
        ),
        // Speaker button
        if (q.audioUrl != null)
          Pressable(
            onPressed: () => _playAudio(q.audioUrl!),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.morandiText, width: 2),
                boxShadow: const [
                  BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0),
                ],
              ),
              child: const Icon(Icons.volume_up, color: AppColors.morandiText, size: 22),
            ),
          ),
      ],
    );
  }

  Widget _buildListeningArea(Question q) {
    return Column(
      children: [
        // Large speaker circle
        Pressable(
          onPressed: q.audioUrl != null ? () => _playAudio(q.audioUrl!) : null,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.baliHai30,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.morandiText, width: 3),
              boxShadow: const [
                BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0),
              ],
            ),
            child: const Icon(Icons.volume_up, color: AppColors.morandiText, size: 36),
          ),
        ),
        const SizedBox(height: 12),
        if (q.audioUrl != null)
          const Text('请播放拼音音频',
              style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        if (q.phonetic != null)
          Text(q.phonetic!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
        if (q.instruction != null) ...[
          const SizedBox(height: 8),
          Text(q.instruction!,
              style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600)),
        ],
      ],
    );
  }

  Widget _buildBlankFillingArea(Question q) {
    final text = q.mainText ?? q.questionText;
    final parts = text.split('____');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (q.instruction != null) ...[
          Text(q.instruction!, style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
        ],
        if (parts.length == 2)
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.morandiText, height: 1.4),
              children: [
                TextSpan(text: parts[0]),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: Container(
                    width: 48,
                    height: 3,
                    color: AppColors.morandiText,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                  ),
                ),
                TextSpan(text: parts[1]),
              ],
            ),
          )
        else
          Text(text, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
      ],
    );
  }

  Future<void> _playAudio(String url) async {
    try {
      final file = await Di.audioCache.getSingleFile(url);
      final player = AudioPlayer();
      await player.play(DeviceFileSource(file.path));
    } catch (_) {}
  }

  // ── Role Play: history card ──────────────────────────────

  Widget _buildHistoryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.morandiText, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Column(
        children: _currentQ.history.map((turn) => _buildChatTurn(turn)).toList(),
      ),
    );
  }

  // ── Role Play: current question card ─────────────────────

  Widget _buildCurrentQuestionCard(Question q) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.morandiText, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRolePlayArea(q),
          const SizedBox(height: 20),
          const DashedDivider(color: AppColors.mercury25),
        ],
      ),
    );
  }

  Widget _buildRolePlayArea(Question q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (q.instruction != null) ...[
          Text(q.instruction!, style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
        ],
        Text(q.currentQuestion ?? q.questionText,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.morandiText, height: 1.4)),
      ],
    );
  }

  Widget _buildChatTurn(DialogueTurn turn) {
    if (turn.isWaiter) {
      // Waiter (left)
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.whisper15,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.morandiText, width: 2),
              ),
              child: const Icon(Icons.person_outline, color: AppColors.morandiText, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            const SizedBox(width: 36),
          ],
        ),
      );
    } else {
      // User (right)
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const SizedBox(width: 36),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.55),
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
                    Icon(Icons.check, size: 13, color: AppColors.semanticGreen),
                    SizedBox(width: 4),
                    Text('CORRECT',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.semanticGreen)),
                  ],
                ),
              ),
          ],
        ),
      );
    }
  }

  // ── Option buttons ───────────────────────────────────────

  Widget _buildOptionButton(int index) {
    final opt = _currentQ.options[index];
    final label = String.fromCharCode(65 + index); // A, B, C
    final isSel = _selectedOption == index;
    final showCorrect = _hasAnswered && index == _currentQ.correctIndex;
    final showWrong = _hasAnswered && isSel && !_isCorrect;

    Color bgColor = Colors.white;
    if (showCorrect) bgColor = AppColors.semanticGreen.withValues(alpha: 0.15);
    if (showWrong) bgColor = AppColors.semanticRed.withValues(alpha: 0.15);

    return Pressable(
      onPressed: () => _selectOption(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: showCorrect
                ? AppColors.semanticGreen
                : showWrong
                    ? AppColors.semanticRed
                    : AppColors.morandiText,
            width: 2.5,
          ),
          boxShadow: const [
            BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: showCorrect
                    ? AppColors.semanticGreen
                    : showWrong
                        ? AppColors.semanticRed
                        : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: showCorrect || showWrong ? Colors.transparent : AppColors.morandiText,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: showCorrect || showWrong ? Colors.white : AppColors.morandiText)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(opt,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: showCorrect || showWrong ? AppColors.morandiText : Colors.black87)),
            ),
            if (showCorrect)
              const Icon(Icons.check_circle, color: AppColors.semanticGreen, size: 22)
            else if (showWrong)
              const Icon(Icons.cancel, color: AppColors.semanticRed, size: 22),
          ],
        ),
      ),
    );
  }

  // ── Feedback card ────────────────────────────────────────

  Widget _buildFeedbackCard() {
    final q = _currentQ;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isCorrect
            ? AppColors.semanticGreen.withValues(alpha: 0.08)
            : AppColors.semanticRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.shark40.withValues(alpha: 0.15), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _isCorrect ? AppColors.semanticGreen : AppColors.semanticRed,
                  shape: BoxShape.circle,
                ),
                child: Icon(_isCorrect ? Icons.check : Icons.close, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(_isCorrect ? '回答正确 (Correct)' : '回答错误 (Incorrect)',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w900, color: _isCorrect ? AppColors.semanticGreen : AppColors.semanticRed)),
            ],
          ),
          const SizedBox(height: 8),
          Text(q.explanation,
              style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ── Next button ──────────────────────────────────────────

  Widget _buildNextButton() {
    final isRolePlay = _currentQ.type == QuestionType.rolePlay;
    final beforeAnswer = !_hasAnswered;
    final showSubmit = isRolePlay && beforeAnswer;

    return Pressable(
      onPressed: _hasAnswered ? _nextQuestion : null,
      child: Opacity(
        opacity: _hasAnswered ? 1.0 : 0.45,
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
            children: [
              Text(
                  showSubmit
                      ? '确认提交'
                      : _isLastQ
                          ? '查看结果'
                          : '下一题',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
              const SizedBox(width: 6),
              Text(
                  showSubmit
                      ? 'Submit Answer'
                      : _isLastQ
                          ? 'See Results'
                          : 'Next Question',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right, color: AppColors.morandiText, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  RESULT / SUMMARY VIEW
  // ═══════════════════════════════════════════════════════════

  Widget _buildResultView() {
    final starCount = _passed ? min(3, (_accuracy / 33).ceil()) : 0;
    final level = _level!;

    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),
            // Back + title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  _buildCircleBackBtn(),
                  const SizedBox(width: 12),
                  const Text('闯关报告 (Summary)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Main card
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      // Large white card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.morandiText, width: 3),
                          boxShadow: const [
                            BoxShadow(color: AppColors.morandiText, offset: Offset(5, 5), blurRadius: 0),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Stars
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: _buildSummaryStar(filled: i < starCount),
                                );
                              }),
                            ),
                            const SizedBox(height: 24),

                            // Score label
                            const Text('得分 SCORE',
                                style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                            const SizedBox(height: 6),

                            // Score number
                            Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.morandiText),
                                children: [
                                  TextSpan(text: '$_correctCount', style: const TextStyle(fontSize: 56, height: 1.1)),
                                  TextSpan(text: ' / $_totalQ', style: const TextStyle(fontSize: 24, color: Colors.black38)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Pass/fail description
                            Text(
                              _passed ? '🎉 恭喜通过本关！' : '需正确率 ≥ ${level.passThreshold}% 才可通关',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: _passed ? AppColors.semanticGreen : AppColors.semanticRed,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),

                            // Reward area
                            if (_passed)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.morandiText, width: 2),
                                ),
                                child: Column(
                                  children: [
                                    const Text('通关获得奖励',
                                        style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.auto_awesome, color: AppColors.straw14, size: 24),
                                        const SizedBox(width: 6),
                                        Text('+${level.pointsReward} PTS',
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 20),
                            const DashedDivider(color: AppColors.mercury25),
                            const SizedBox(height: 20),

                            // Back to level select button
                            Pressable(
                              onPressed: _goBack,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.morandiText, width: 2.5),
                                  boxShadow: const [
                                    BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0),
                                  ],
                                ),
                                child: const Text('返回关卡选择',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
                              ),
                            ),

                            // Retry button
                            const SizedBox(height: 12),
                            Pressable(
                              onPressed: _retry,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.baliHai30,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.morandiText, width: 2.5),
                                  boxShadow: const [
                                    BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0),
                                  ],
                                ),
                                child: const Text('Retry Level',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // "闯关成功！" badge overlapping top
                      Positioned(
                        top: -20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                          decoration: BoxDecoration(
                            color: _passed ? AppColors.baliHai30 : AppColors.semanticRed.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.morandiText, width: 3),
                            boxShadow: const [
                              BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0),
                            ],
                          ),
                          child: Text(
                            _passed ? '闯关成功！' : '未通过',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.morandiText),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStar({required bool filled}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.star, size: 42, color: AppColors.morandiText),
        Icon(Icons.star, size: 34, color: filled ? AppColors.straw14 : AppColors.mercury25),
      ],
    );
  }
}
