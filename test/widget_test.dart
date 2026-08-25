import 'package:flutter_test/flutter_test.dart';
import 'package:test1/core/models/level.dart';
import 'package:test1/core/models/phrase.dart';

void main() {
  group('API model contract', () {
    test('parses typed role-play questions returned by D1', () {
      final level = Level.fromJson({
        'id': 4,
        'level_num': 4,
        'title': '点餐角色扮演',
        'subtitle': '(Role Play)',
        'pass_threshold': 100,
        'points_reward': 20,
        'description': '模拟真实餐厅场景。',
        'stars': 0,
        'best_score': 0,
        'is_unlocked': true,
        'questions': [
          {
            'id': 10,
            'question_type': 'role_play',
            'question_text': '角色扮演',
            'options': ['请给我菜单。', '我想喝水。'],
            'correct_index': 0,
            'explanation': '先索要菜单。',
            'instruction': '针对服务员的对话作答',
            'audio_url': null,
            'main_text': null,
            'phonetic': null,
            'current_question': '您想吃点什么？',
            'history': [
              {'is_waiter': true, 'text': '您好，欢迎光临！'},
              {
                'is_waiter': false,
                'text': '您好。',
                'is_correct': true,
                'option_label': 'A.您好。',
              },
            ],
          },
        ],
      });

      expect(level.pointsReward, 20);
      expect(level.questions.single.type, QuestionType.rolePlay);
      expect(level.questions.single.history.first.isWaiter, isTrue);
      expect(level.questions.single.history.last.isCorrect, isTrue);
    });

    test('parses Toolbox topics, chapters, phrases and nullable audio', () {
      final topic = Topic.fromJson({
        'scene_id': 1,
        'scene_name_en': 'Restaurant',
        'scene_name_zh': '餐厅',
        'category': 'USEFUL PHRASES',
        'title': 'Ordering Food',
        'icon_key': 'restaurant',
        'chapters': [
          {
            'id': 1,
            'index': 1,
            'title': '一、进入餐厅',
            'subtitle': '进入餐厅',
            'sentence_count': 1,
            'phrases': [
              {
                'id': 1,
                'chinese': '我有预订。',
                'pinyin': 'Wǒ yǒu yùdìng.',
                'english': 'I have a reservation.',
                'audio_url': null,
              },
            ],
          },
        ],
      });

      expect(topic.sceneId, 1);
      expect(topic.chapters.single.sentenceCount, 1);
      expect(topic.chapters.single.phrases.single.audioUrl, isNull);
    });
  });
}
