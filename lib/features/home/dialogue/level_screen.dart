import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di.dart';
import '../../../core/models/level.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/app_safe_area.dart';
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
      setState(() => _showResult = true);
      final stars = _passed ? min(3, (_accuracy / 33).ceil()) : 0;
      Di.api.submitProgress(widget.levelId, stars, _accuracy.round());
    } else {
      setState(() {
        _currentQIndex++;
        _selectedOption = null;
        _hasAnswered = false;
        _isCorrect = false;
      });
    }
  }

  double get _accuracy => (_correctCount / _totalQ) * 100;
  bool get _passed => _accuracy >= _level!.passThreshold;

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

  void _goBack() { if (Navigator.of(context).canPop()) { context.pop(); } else { context.go('/study/dialogue-practice/${widget.sceneId}'); } }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.springWood14,
        body: AppSafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.semanticRed,
                  ),
                ),
              ],
            ),
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

  Widget _buildQuestionView() {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: 48),
              _buildTopBar(),
              const SizedBox(height: 24),
              _buildProgressBar(),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildQuestionCard(),
                      const SizedBox(height: 24),
                      ...List.generate(_currentQ.options.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildOptionButton(i),
                        );
                      }),
                      if (_hasAnswered) ...[
                        const SizedBox(height: 16),
                        _buildFeedbackCard(),
                      ],
                      const SizedBox(height: 24),
                      if (_hasAnswered) _buildNextButton(),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Pressable(
          onPressed: _goBack,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.morandiText, width: 3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.morandiText,
                  offset: Offset(3, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.morandiText,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _level!.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.morandiText,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${_currentQIndex + 1}/$_totalQ',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progress = (_currentQIndex + (_hasAnswered ? 1 : 0)) / _totalQ;
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.whisper15,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.morandiText.withValues(alpha: 0.1)),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.baliHai30,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.baliHai30,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Question ${_currentQIndex + 1}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.morandiText,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _currentQ.questionText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(int index) {
    Color bgColor = Colors.white;
    Color borderColor = AppColors.morandiText;
    Color textColor = AppColors.morandiText;

    if (_hasAnswered) {
      if (index == _currentQ.correctIndex) {
        bgColor = AppColors.semanticGreen.withValues(alpha: 0.15);
        borderColor = AppColors.semanticGreen;
        textColor = AppColors.semanticGreen;
      } else if (index == _selectedOption) {
        bgColor = AppColors.semanticRed.withValues(alpha: 0.15);
        borderColor = AppColors.semanticRed;
        textColor = AppColors.semanticRed;
      } else {
        bgColor = AppColors.whisper15;
        borderColor = AppColors.shark40.withValues(alpha: 0.15);
        textColor = AppColors.shark40.withValues(alpha: 0.4);
      }
    }

    return Pressable(
      onPressed: () => _selectOption(index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(14),
          boxShadow: !_hasAnswered || index == _selectedOption || index == _currentQ.correctIndex
              ? const [
                  BoxShadow(
                    color: AppColors.morandiText,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _hasAnswered && index == _currentQ.correctIndex
                    ? AppColors.semanticGreen
                    : _hasAnswered && index == _selectedOption
                        ? AppColors.semanticRed
                        : AppColors.whisper15,
                border: Border.all(
                  color: _hasAnswered &&
                          (index == _currentQ.correctIndex || index == _selectedOption)
                      ? Colors.transparent
                      : AppColors.morandiText,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: _hasAnswered &&
                            (index == _currentQ.correctIndex || index == _selectedOption)
                        ? Colors.white
                        : AppColors.morandiText,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _currentQ.options[index],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
            if (_hasAnswered && index == _currentQ.correctIndex)
              const Icon(Icons.check_circle, color: AppColors.semanticGreen, size: 22)
            else if (_hasAnswered && index == _selectedOption && !_isCorrect)
              const Icon(Icons.cancel, color: AppColors.semanticRed, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isCorrect
            ? AppColors.semanticGreen.withValues(alpha: 0.1)
            : AppColors.semanticRed.withValues(alpha: 0.1),
        border: Border.all(
          color: _isCorrect ? AppColors.semanticGreen : AppColors.semanticRed,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isCorrect ? Icons.check_circle : Icons.cancel,
                color: _isCorrect ? AppColors.semanticGreen : AppColors.semanticRed,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _isCorrect ? 'Correct!' : 'Not quite...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: _isCorrect ? AppColors.semanticGreen : AppColors.semanticRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _currentQ.explanation,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.morandiText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Pressable(
      onPressed: _nextQuestion,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.baliHai30,
          border: Border.all(color: AppColors.morandiText, width: 3),
          borderRadius: BorderRadius.circular(14),
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
            _isLastQ ? 'See Results' : 'Next Question →',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultView() {
    final starCount = _passed ? min(3, (_accuracy / 33).ceil()) : 0;

    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              const Spacer(),
              _buildResultIcon(),
              const SizedBox(height: 24),
              Text(
                _passed ? 'Level Complete!' : 'Try Again!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Score: $_correctCount/$_totalQ (${_accuracy.toStringAsFixed(0)}%)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.morandiText.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      i < starCount ? Icons.star : Icons.star_border,
                      size: 36,
                      color: i < starCount ? AppColors.straw14 : AppColors.mercury25,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              if (!_passed)
                Text(
                  'Need ${_level!.passThreshold}% to pass',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.semanticRed.withValues(alpha: 0.8),
                  ),
                ),
              const Spacer(),
              if (!_passed)
                _buildRetryButton()
              else ...[
                _buildContinueButton(),
                const SizedBox(height: 12),
                _buildRetryButton(isSecondary: true),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: _passed
            ? AppColors.semanticGreen.withValues(alpha: 0.15)
            : AppColors.semanticRed.withValues(alpha: 0.15),
        border: Border.all(
          color: _passed ? AppColors.semanticGreen : AppColors.semanticRed,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Icon(
          _passed ? Icons.emoji_events : Icons.refresh,
          size: 48,
          color: _passed ? AppColors.semanticGreen : AppColors.semanticRed,
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Pressable(
      onPressed: _goBack,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.baliHai30,
          border: Border.all(color: AppColors.morandiText, width: 3),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: AppColors.morandiText,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Continue →',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRetryButton({bool isSecondary = false}) {
    return Pressable(
      onPressed: _retry,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isSecondary ? AppColors.whisper15 : Colors.white,
          border: Border.all(
            color: isSecondary
                ? AppColors.shark40.withValues(alpha: 0.2)
                : AppColors.morandiText,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSecondary
              ? null
              : const [
                  BoxShadow(
                    color: AppColors.morandiText,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            'Retry Level',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: isSecondary
                  ? AppColors.shark40.withValues(alpha: 0.6)
                  : AppColors.morandiText,
            ),
          ),
        ),
      ),
    );
  }
}
