import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/di.dart';
import '../../../core/models/vocab.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_safe_area.dart';
import '../../../widgets/pressable.dart';
import '../../../l10n/l10n.dart';

class VocabLearningScreen extends StatefulWidget {
  final int sceneId;
  const VocabLearningScreen({super.key, required this.sceneId});

  @override
  State<VocabLearningScreen> createState() => _VocabLearningScreenState();
}

class _VocabLearningScreenState extends State<VocabLearningScreen> {
  List<VocabItem>? _vocabList;
  String? _error;

  final Set<int> _clickedCards = {};
  int _highlightedIndex = -1;
  bool _isPlaying = false;
  final AudioPlayer _player = AudioPlayer();

  bool get _allClicked =>
      _vocabList != null && _clickedCards.length >= _vocabList!.length;

  @override
  void initState() {
    super.initState();
    _loadVocab();
  }

  Future<void> _loadVocab() async {
    try {
      final list = await Di.api.getSceneVocab(widget.sceneId);
      if (!mounted) return;
      setState(() => _vocabList = list);
      for (final v in list) {
        Di.audioCache.prefetch(v.audioUrl);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _onCardTap(int index) async {
    if (_highlightedIndex == index || _isPlaying) return;

    setState(() {
      _clickedCards.add(index);
      _highlightedIndex = index;
      _isPlaying = true;
    });

    Timer(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _highlightedIndex = -1);
    });

    final vocab = _vocabList![index];
    unawaited(
      Di.api.markVocabSeen([vocab.id]).catchError((Object error) {
        debugPrint('[Progress] Error marking vocab ${vocab.id}: $error');
      }),
    );
    try {
      await _player.stop();
      await _player.play(await Di.audioCache.sourceFor(vocab.audioUrl));
    } catch (e) {
      debugPrint('[Audio] Error playing ${vocab.audioUrl}: $e');
    } finally {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  void _goToDialoguePractice() =>
      context.push('/study/dialogue-practice/${widget.sceneId}');
  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/study/vocab-scene');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Column(
        children: [
          const SizedBox(height: 48),
          AppHeader(
            title: context.l10n.vocabLearningSingleLine,
            titleColor: AppColors.baliHai30,
            onBack: _goBack,
          ),
          const Spacer(),
          Text(
            context.l10n.loadFailed,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.semanticRed,
            ),
          ),
          const Spacer(),
        ],
      );
    }

    if (_vocabList == null) {
      return Column(
        children: [
          const SizedBox(height: 48),
          AppHeader(
            title: context.l10n.vocabLearningSingleLine,
            titleColor: AppColors.baliHai30,
            onBack: _goBack,
          ),
          const Spacer(),
          const CircularProgressIndicator(),
          const Spacer(),
        ],
      );
    }

    return Column(
      children: [
        const SizedBox(height: 48),
        AppHeader(
          title: context.l10n.vocabLearningSingleLine,
          titleColor: AppColors.baliHai30,
          onBack: _goBack,
        ),
        const SizedBox(height: 24),
        _buildTitle(),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: _vocabList!.length,
            itemBuilder: (context, index) => _buildVocabCard(index),
          ),
        ),
        const SizedBox(height: 16),
        _buildNextButton(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 2),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: AppColors.morandiText,
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        context.l10n.learnTheseWords,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: AppColors.morandiText,
        ),
      ),
    );
  }

  Widget _buildVocabCard(int index) {
    final vocab = _vocabList![index];
    final isHighlighted = _highlightedIndex == index;
    final hasClicked = _clickedCards.contains(index);

    return Pressable(
      onPressed: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.straw14 : Colors.white,
          border: Border.all(
            color: hasClicked ? AppColors.semanticGreen : AppColors.morandiText,
            width: hasClicked ? 2.5 : 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.morandiText,
              offset: Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              vocab.chinese,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: AppColors.morandiText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.lavenderPurple.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                vocab.pinyin,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.morandiText,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              vocab.english,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.morandiText.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            if (hasClicked)
              const Icon(
                Icons.check_circle,
                size: 18,
                color: AppColors.semanticGreen,
              )
            else
              Icon(
                Icons.volume_up,
                size: 18,
                color: AppColors.morandiText.withValues(alpha: 0.3),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Pressable(
      onPressed: _allClicked ? _goToDialoguePractice : null,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: _allClicked ? AppColors.baliHai30 : AppColors.whisper15,
          border: Border.all(
            color: _allClicked
                ? AppColors.morandiText
                : AppColors.shark40.withValues(alpha: 0.2),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: _allClicked
              ? const [
                  BoxShadow(
                    color: AppColors.morandiText,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            _allClicked
                ? context.l10n.startPractice
                : context.l10n.cardsLearned(
                    _clickedCards.length,
                    _vocabList?.length ?? 0,
                  ),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: _allClicked
                  ? AppColors.morandiText
                  : AppColors.shark40.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
    );
  }
}
