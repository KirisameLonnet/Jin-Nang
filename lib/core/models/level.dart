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
}
