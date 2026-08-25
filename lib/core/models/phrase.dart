import 'package:flutter/material.dart';

class Phrase {
  final int id;
  final String chinese;
  final String pinyin;
  final String english;
  final String? audioUrl;

  const Phrase({
    required this.id,
    required this.chinese,
    required this.pinyin,
    required this.english,
    this.audioUrl,
  });

  factory Phrase.fromJson(Map<String, dynamic> json) => Phrase(
    id: json['id'] as int,
    chinese: json['chinese'] as String,
    pinyin: json['pinyin'] as String,
    english: json['english'] as String,
    audioUrl: json['audio_url'] as String?,
  );
}

class Chapter {
  final int id;
  final int index;
  final String title;
  final String subtitle;
  final int sentenceCount;
  final List<Phrase> phrases;

  const Chapter({
    required this.id,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.sentenceCount,
    required this.phrases,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json['id'] as int,
    index: json['index'] as int,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    sentenceCount: json['sentence_count'] as int,
    phrases: (json['phrases'] as List)
        .map((item) => Phrase.fromJson(item as Map<String, dynamic>))
        .toList(),
  );
}

class Topic {
  final int sceneId;
  final String sceneNameEn;
  final String sceneNameZh;
  final String category;
  final String title;
  final String iconKey;
  final List<Chapter> chapters;

  const Topic({
    required this.sceneId,
    required this.sceneNameEn,
    required this.sceneNameZh,
    required this.category,
    required this.title,
    required this.iconKey,
    required this.chapters,
  });

  IconData get icon => switch (iconKey) {
    'restaurant' => Icons.local_cafe,
    'supermarket' => Icons.shopping_cart,
    'airport' => Icons.flight,
    _ => Icons.chat_bubble_outline,
  };

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    sceneId: json['scene_id'] as int,
    sceneNameEn: json['scene_name_en'] as String,
    sceneNameZh: json['scene_name_zh'] as String,
    category: json['category'] as String,
    title: json['title'] as String,
    iconKey: json['icon_key'] as String,
    chapters: (json['chapters'] as List)
        .map((item) => Chapter.fromJson(item as Map<String, dynamic>))
        .toList(),
  );
}
