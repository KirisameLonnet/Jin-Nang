import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/di.dart';
import '../../core/models/vocab.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_safe_area.dart';
import '../../widgets/pressable.dart';

class ToolboxCard extends StatefulWidget {
  final int sceneId;
  const ToolboxCard({super.key, required this.sceneId});

  @override
  State<ToolboxCard> createState() => _ToolboxCardState();
}

class _ToolboxCardState extends State<ToolboxCard> {
  List<VocabItem>? _vocabList;
  final Map<int, VocabDetail> _detailCache = {};
  VocabDetail? _currentDetail;
  String? _error;
  int _currentIndex = 0;
  bool _showRelated = true;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadVocab();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadVocab() async {
    try {
      final list = await Di.api.getSceneVocab(widget.sceneId);
      if (!mounted) return;
      setState(() => _vocabList = list);
      await _loadDetail(0);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  Future<void> _loadDetail(int index) async {
    if (_vocabList == null) return;
    final id = _vocabList![index].id;
    if (_detailCache.containsKey(id)) {
      setState(() => _currentDetail = _detailCache[id]);
      return;
    }
    try {
      final detail = await Di.api.getVocabDetail(id);
      _detailCache[id] = detail;
      if (!mounted) return;
      setState(() => _currentDetail = detail);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  Future<void> _playAudio() async {
    if (_currentDetail == null) return;
    try {
      final file = await Di.audioCache.getSingleFile(_currentDetail!.audioUrl);
      await _player.stop();
      await _player.play(DeviceFileSource(file.path));
    } catch (e) {
      debugPrint('[Audio] Error: $e');
    }
  }

  Future<void> _goNext() async {
    final total = _vocabList?.length ?? 0;
    if (_currentIndex < total - 1) {
      final next = _currentIndex + 1;
      setState(() { _currentIndex = next; _currentDetail = null; _showRelated = true; });
      await _loadDetail(next);
    } else {
      if (Navigator.of(context).canPop()) { context.pop(); } else { context.go('/study/vocab-scene'); }
    }
  }

  Future<void> _goPrev() async {
    if (_currentIndex > 0) {
      final prev = _currentIndex - 1;
      setState(() { _currentIndex = prev; _currentDetail = null; _showRelated = true; });
      await _loadDetail(prev);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _vocabList?.length ?? 0;
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: AppSafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: 48),
              AppHeader(
                title: 'Vocab Battle',
                progress: total > 0 ? '${_currentIndex + 1}/$total' : '',
                onBack: () {
                  if (Navigator.of(context).canPop()) {
                    context.pop();
                  } else {
                    context.go('/study/vocab-scene');
                  }
                },
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildBody()),
              _buildNavigationButtons(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Text(_error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.semanticRed, fontWeight: FontWeight.w600)),
      );
    }
    if (_currentDetail == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Column(
          children: [
            _buildMainCard(),
            const SizedBox(height: 20),
            _buildToggleButtons(),
            const SizedBox(height: 20),
            _showRelated ? _buildRelatedSection() : _buildPhraseSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    final w = _currentDetail!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 3),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(w.chinese,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
              const SizedBox(height: 4),
              Text(w.pinyin,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                      color: AppColors.lavenderPurple.withValues(alpha: 0.8))),
            ]),
          ),
          Pressable(
            onPressed: _playAudio,
            child: Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: AppColors.baliHai30,
                border: Border.all(color: AppColors.morandiText, width: 2),
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(color: AppColors.morandiText, offset: Offset(0, 4), blurRadius: 0),
                ],
              ),
              child: const Icon(Icons.volume_up, size: 24, color: AppColors.morandiText),
            ),
          ),
        ]),
        const SizedBox(height: 16),
        _buildDashedDivider(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppColors.morandiText, borderRadius: BorderRadius.circular(8)),
          child: Text('${w.partOfSpeech} ${w.englishMeaning}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white)),
        ),
        const SizedBox(height: 12),
        Text(w.chineseMeaning,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.morandiText)),
        const SizedBox(height: 2),
        Text(w.chineseMeaningPinyin,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                color: AppColors.lavenderPurple.withValues(alpha: 0.7))),
        const SizedBox(height: 16),
        _buildDashedDivider(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // ← 改这里
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.oldRose15,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Lìjù',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                ),
              ),
            ),
            const Text(
              '例句 example sentence',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.morandiText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...w.examples.map(_buildExampleCard),
      ]),
    );
  }

  Widget _buildDashedDivider() {
    return LayoutBuilder(builder: (context, constraints) {
      final count = (constraints.maxWidth / 12).floor();
      return Row(
        children: List.generate(count * 2 - 1, (i) {
          if (i.isOdd) return const SizedBox(width: 4);
          return Expanded(child: Container(height: 1,
              color: AppColors.morandiText.withValues(alpha: 0.15)));
        }),
      );
    });
  }

  Widget _buildExampleCard(VocabExample e) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F1EC),
        border: Border.all(color: AppColors.shark40.withValues(alpha: 0.15), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(e.chinese,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.morandiText)),
        const SizedBox(height: 4),
        Text(e.pinyin,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                color: AppColors.lavenderPurple.withValues(alpha: 0.7))),
        const SizedBox(height: 4),
        Text(e.english,
            style: TextStyle(fontSize: 12, color: AppColors.shark40.withValues(alpha: 0.7))),
      ]),
    );
  }

  Widget _buildToggleButtons() {
    return Row(children: [
      Expanded(child: _buildToggleBtn('关联词\n(Associated)', _showRelated, () => setState(() => _showRelated = true))),
      const SizedBox(width: 16),
      Expanded(child: _buildToggleBtn('短语\n(Phrases)', !_showRelated, () => setState(() => _showRelated = false))),
    ]);
  }

  Widget _buildToggleBtn(String label, bool active, VoidCallback onPressed) {
    return Pressable(
      onPressed: onPressed,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: active ? AppColors.straw14 : Colors.white,
          border: Border.all(color: AppColors.morandiText, width: 3),
          borderRadius: BorderRadius.circular(14),
          boxShadow: active ? const [BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0)] : null,
        ),
        child: Center(
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, height: 1.3,
                  color: active ? AppColors.morandiText : AppColors.shark40.withValues(alpha: 0.5))),
        ),
      ),
    );
  }

  Widget _buildRelatedSection() {
    final w = _currentDetail!;
    final synonyms = w.relatedWords.where((r) => r.type == 'synonym').toList();
    final antonyms = w.relatedWords.where((r) => r.type == 'antonym').toList();
    final expands = w.relatedWords.where((r) => r.type == 'expand').toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 1.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildCategoryTag('近义词 synonym', AppColors.baliHai30),
        const SizedBox(height: 12),
        if (synonyms.isNotEmpty) ...synonyms.map(_buildRelatedRow)
        else const Text('无 (None)', style: TextStyle(fontSize: 14, color: AppColors.naturalGray19)),
        const SizedBox(height: 16),
        _buildCategoryTag('反义词 antonym', AppColors.oldRose15),
        const SizedBox(height: 12),
        if (antonyms.isNotEmpty) ...antonyms.map(_buildRelatedRow)
        else const Text('无 (None)', style: TextStyle(fontSize: 14, color: AppColors.naturalGray19)),
        const SizedBox(height: 16),
        _buildCategoryTag('拓展词 expand word', AppColors.lavenderPurple.withValues(alpha: 0.3)),
        const SizedBox(height: 12),
        if (expands.isNotEmpty) ...expands.map(_buildRelatedRow)
        else const Text('无 (None)', style: TextStyle(fontSize: 14, color: AppColors.naturalGray19)),
      ]),
    );
  }

  Widget _buildCategoryTag(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
    );
  }

  Widget _buildRelatedRow(RelatedWord r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        SizedBox(width: 60,
            child: Text(r.chinese,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.morandiText))),
        SizedBox(width: 70,
            child: Text(r.pinyin,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                    color: AppColors.lavenderPurple.withValues(alpha: 0.7)))),
        Expanded(
            child: Text(r.english,
                style: TextStyle(fontSize: 13, color: AppColors.shark40.withValues(alpha: 0.7)))),
      ]),
    );
  }

  Widget _buildPhraseSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 1.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildCategoryTag('短语 (Phrases)', AppColors.straw14),
        const SizedBox(height: 12),
        ..._currentDetail!.phrases.map(_buildPhraseRow),
      ]),
    );
  }

  Widget _buildPhraseRow(VocabPhrase p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Expanded(flex: 2,
            child: Text(p.chinese,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.morandiText))),
        Expanded(flex: 3,
            child: Text(p.english,
                style: TextStyle(fontSize: 13, color: AppColors.shark40.withValues(alpha: 0.7)))),
      ]),
    );
  }

  Widget _buildNavigationButtons() {
    final total = _vocabList?.length ?? 0;
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == total - 1;

    return Row(children: [
      Expanded(
        child: Pressable(
          onPressed: isFirst ? null : _goPrev,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: isFirst ? AppColors.whisper15 : Colors.white,
              border: Border.all(
                  color: isFirst ? AppColors.shark40.withValues(alpha: 0.2) : AppColors.morandiText, width: 3),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0)],
            ),
            child: Center(child: Text('← Prev',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900,
                    color: isFirst ? AppColors.shark40.withValues(alpha: 0.4) : AppColors.morandiText))),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Pressable(
          onPressed: _goNext,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: isLast ? AppColors.baliHai30 : AppColors.straw14,
              border: Border.all(color: AppColors.morandiText, width: 3),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0)],
            ),
            child: Center(child: Text(isLast ? 'Finish' : 'Next →',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.morandiText))),
          ),
        ),
      ),
    ]);
  }
}
