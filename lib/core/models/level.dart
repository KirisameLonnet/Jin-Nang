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

  factory DialogueTurn.fromJson(Map<String, dynamic> json) => DialogueTurn(
    isWaiter: json['is_waiter'] == true || json['is_waiter'] == 1,
    text: json['text'] as String,
    isCorrect: json['is_correct'] == null
        ? null
        : json['is_correct'] == true || json['is_correct'] == 1,
    optionLabel: json['option_label'] as String?,
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
    required this.type,
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

  factory Question.fromJson(Map<String, dynamic> json) {
    final type = switch (json['question_type'] as String?) {
      'listening_choice' => QuestionType.listeningChoice,
      'blank_filling' => QuestionType.blankFilling,
      'role_play' => QuestionType.rolePlay,
      _ => QuestionType.vocabularyMatch,
    };

    return Question(
      id: json['id'] as int,
      type: type,
      questionText: json['question_text'] as String,
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correct_index'] as int,
      explanation: json['explanation'] as String,
      mainText: json['main_text'] as String?,
      phonetic: json['phonetic'] as String?,
      instruction: json['instruction'] as String?,
      audioUrl: json['audio_url'] as String?,
      history:
          (json['history'] as List?)
              ?.map(
                (item) => DialogueTurn.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      currentQuestion: json['current_question'] as String?,
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
    required this.pointsReward,
    required this.description,
  });

  factory Level.fromJson(Map<String, dynamic> json) => Level(
    id: json['id'] as int,
    levelNum: json['level_num'] as int,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    passThreshold: json['pass_threshold'] as int,
    stars: json['stars'] as int,
    bestScore: json['best_score'] as int,
    isUnlocked: json['is_unlocked'] as bool,
    questions: (json['questions'] as List)
        .map((item) => Question.fromJson(item as Map<String, dynamic>))
        .toList(),
    pointsReward: json['points_reward'] as int,
    description: json['description'] as String,
  );
}
