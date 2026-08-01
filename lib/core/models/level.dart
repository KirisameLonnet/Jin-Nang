enum QuestionType { vocabularyMatch, listeningChoice, blankFilling, rolePlay }

class DialogueTurn {
  final bool isWaiter;
  final String text;
  final bool? isCorrect;
  final String? optionLabel;

  const DialogueTurn({
    required this.isWaiter,
    required this.text,
    this.isCorrect,
    this.optionLabel,
  });

  factory DialogueTurn.fromJson(Map<String, dynamic> j) => DialogueTurn(
        isWaiter: (j['is_waiter'] as int?) == 1,
        text: j['text'] as String,
        isCorrect: j['is_correct'] as bool?,
        optionLabel: j['option_label'] as String?,
      );
}

class Question {
  final int id;
  final QuestionType type;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String? mainText;
  final String? phonetic;
  final String? instruction;
  final String? audioUrl;
  final List<DialogueTurn> history;
  final String? currentQuestion;

  const Question({
    required this.id,
    this.type = QuestionType.vocabularyMatch,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.mainText,
    this.phonetic,
    this.instruction,
    this.audioUrl,
    this.history = const [],
    this.currentQuestion,
  });

  factory Question.fromJson(Map<String, dynamic> j) {
    QuestionType type;
    switch (j['question_type'] as String?) {
      case 'listening_choice':
        type = QuestionType.listeningChoice;
        break;
      case 'blank_filling':
        type = QuestionType.blankFilling;
        break;
      case 'role_play':
        type = QuestionType.rolePlay;
        break;
      default:
        type = QuestionType.vocabularyMatch;
    }
    return Question(
      id: j['id'] as int,
      type: type,
      questionText: j['question_text'] as String,
      options: List<String>.from(j['options'] as List),
      correctIndex: j['correct_index'] as int,
      explanation: j['explanation'] as String,
      mainText: j['main_text'] as String?,
      phonetic: j['phonetic'] as String?,
      instruction: j['instruction'] as String?,
      audioUrl: j['audio_url'] as String?,
      history: (j['history'] as List?)
              ?.map((e) => DialogueTurn.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentQuestion: j['current_question'] as String?,
    );
  }

  /// Enrich with local role-play fallback data for Level 4 debugging.
  /// Only applies when backend hasn't set question_type yet (still default).
  Question enrichForLocal({int levelNum = 1}) {
    if (levelNum != 4 || type != QuestionType.vocabularyMatch) return this;
    // Backend hasn't returned role_play yet — use local mock data
    const mockHistoryQ1 = [
      DialogueTurn(isWaiter: true, text: '您好，欢迎光临！请坐。您想吃点什么？'),
      DialogueTurn(isWaiter: false, text: '请给我菜单。', isCorrect: true, optionLabel: 'B.请给我菜单。'),
      DialogueTurn(isWaiter: true, text: '好的，这是菜单。\n您想喝点什么？'),
      DialogueTurn(isWaiter: false, text: '我想喝茶。', isCorrect: true, optionLabel: 'A.我想喝茶。'),
      DialogueTurn(isWaiter: true, text: '好的，一杯茶。那您想吃什么菜？我们有鱼香肉丝、麻婆豆腐、炒青菜。'),
    ];
    const mockHistoryQ2 = [
      DialogueTurn(isWaiter: true, text: '您好，欢迎光临！'),
      DialogueTurn(isWaiter: false, text: '请给我菜单。', isCorrect: true, optionLabel: 'B.请给我菜单。'),
      DialogueTurn(isWaiter: true, text: '好的，这是菜单。您想喝点什么？'),
      DialogueTurn(isWaiter: false, text: '我想喝茶。', isCorrect: true, optionLabel: 'A.我想喝茶。'),
      DialogueTurn(isWaiter: true, text: '好的，一杯茶。那您想吃什么菜？我们有鱼香肉丝、麻婆豆腐、炒青菜。'),
      DialogueTurn(isWaiter: false, text: '我要一份炒青菜和一碗米饭。', isCorrect: true, optionLabel: 'A.我要一份炒青菜和一碗米饭。'),
      DialogueTurn(isWaiter: true, text: '好的。请慢用。\n（上菜后）您吃好了吗？还需要加点什么吗？'),
    ];

    final isQ1 = (id % 2 == 1); // odd id = first question
    return Question(
      id: id,
      type: QuestionType.rolePlay,
      questionText: questionText,
      options: options,
      correctIndex: correctIndex,
      explanation: explanation,
      instruction: '角色扮演：针对服务员的对话作答',
      currentQuestion: isQ1
          ? '好的，一杯茶。那您想吃点什么菜？我们有鱼香肉丝、麻婆豆腐、炒青菜。'
          : '您吃好了吗？还需要加点什么吗？',
      history: isQ1 ? mockHistoryQ1 : mockHistoryQ2,
    );
  }
}

class Level {
  final int id;
  final int levelNum;
  final String title;
  final String subtitle;
  final int passThreshold;
  final int stars;
  final int bestScore;
  final bool isUnlocked;
  final List<Question> questions;
  final int pointsReward;
  final String description;

  const Level({
    required this.id,
    required this.levelNum,
    required this.title,
    required this.subtitle,
    required this.passThreshold,
    required this.stars,
    required this.bestScore,
    required this.isUnlocked,
    required this.questions,
    this.pointsReward = 0,
    this.description = '',
  });

  factory Level.fromJson(Map<String, dynamic> j) => Level(
        id: j['id'] as int,
        levelNum: j['level_num'] as int,
        title: j['title'] as String,
        subtitle: j['subtitle'] as String,
        passThreshold: j['pass_threshold'] as int,
        stars: j['stars'] as int,
        bestScore: j['best_score'] as int,
        isUnlocked: j['is_unlocked'] as bool,
        questions: (j['questions'] as List).map((e) => Question.fromJson(e as Map<String, dynamic>)).toList(),
        pointsReward: (j['points_reward'] as int?) ?? 0,
        description: (j['description'] as String?) ?? '',
      );

  /// Enrich with local fallback data when backend doesn't return new fields yet.
  Level enrichForLocal() {
    const ptsMap = {1: 10, 2: 15, 3: 15, 4: 20};
    const titleMap = {
      'Level 1': '词汇匹配', 'Vocab Match': '词汇匹配',
      'Level 2': '听力选择', 'Listen & Choose': '听力选择',
      'Level 3': '句子填空', 'Fill in Blanks': '句子填空',
      'Challenge': '点餐角色扮演', 'Scenario Sort': '点餐角色扮演',
    };
    const subMap = {
      'Vocab Match': '(Vocabulary Match)',
      'Listen & Choose': '(Listening Choice)',
      'Fill in Blanks': '(Blank Filling)',
      'Scenario Sort': '(Role Play)',
    };
    const descMap = {
      '词汇匹配': '识形、知意：选择正确的英文释义或匹配中文词。',
      '听力选择': '听音知意：播放音频，从备选中文汉字里选择正确的对应。',
      '句子填空': '选择最合适的词语补全餐厅对话。',
      '点餐角色扮演': '模拟真实餐厅场景，与服务员进行中文对话练习。',
    };
    final newTitle = titleMap[title] ?? title;
    final newSub = subMap[subtitle] ?? subtitle;
    final newDesc = description.isNotEmpty ? description : (descMap[newTitle] ?? '完成题目，解锁下一关。');
    final newPts = pointsReward > 0 ? pointsReward : (ptsMap[levelNum] ?? 10);

    return Level(
      id: id, levelNum: levelNum,
      title: newTitle, subtitle: newSub,
      passThreshold: passThreshold,
      stars: stars, bestScore: bestScore,
      isUnlocked: isUnlocked,
      questions: questions.map((q) => q.enrichForLocal(levelNum: levelNum)).toList(),
      pointsReward: newPts, description: newDesc,
    );
  }
}
