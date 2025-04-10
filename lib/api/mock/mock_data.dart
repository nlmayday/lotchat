import 'dart:math';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:sky/models/character.dart';

class MockData {
  static List<Character>? _characters;
  static final Random _random = Random();

  static Future<void> init() async {
    if (_characters != null) return;

    final jsonString = await rootBundle.loadString('lib/data/characters.json');
    final jsonData = json.decode(jsonString);
    _characters = (jsonData['characters'] as List)
        .map((json) => Character.fromJson(json))
        .toList();
  }

  static List<Character> get characters {
    if (_characters == null) {
      throw Exception('MockData not initialized');
    }
    return _characters!;
  }

  static final List<String> _chatReplies = [
    "这个想法很有趣呢！",
    "嗯，我明白你的意思了。",
    "确实是这样呢。",
    "让我想想...",
    "这个问题很有深度啊。",
    "我觉得这样说很有道理。",
    "你说得对，不过我有不同的看法。",
    "这让我想起了一个有趣的故事。",
    "我们可以多聊聊这个话题。",
    "你的想法很独特！",
  ];

  static String getRandomReply() {
    return _chatReplies[_random.nextInt(_chatReplies.length)];
  }
}