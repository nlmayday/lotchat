import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sky/models/character.dart';

class CharacterDataManager {
  static final CharacterDataManager _instance =
      CharacterDataManager._internal();
  factory CharacterDataManager() => _instance;
  CharacterDataManager._internal();

  List<Character>? _characters;

  Future<List<Character>> loadCharacters() async {
    if (_characters != null) {
      return _characters!;
    }

    try {
      final jsonString = await rootBundle.loadString(
        'lib/data/characters.json',
      );
      final jsonData = json.decode(jsonString);

      _characters =
          (jsonData['characters'] as List)
              .map((json) {
                try {
                  return Character.fromJson(json);
                } catch (e) {
                  print('解析角色数据失败: $json');
                  print('错误信息: $e');
                  return null;
                }
              })
              .whereType<Character>()
              .toList();

      return _characters!;
    } catch (e) {
      print('加载角色数据失败: $e');
      _characters = [];
      return [];
    }
  }

  Future<List<Character>> getCharactersByCategory(String category) async {
    final characters = await loadCharacters();
    if (category == '推荐') {
      return characters;
    }
    return characters.where((char) => char.category == category).toList();
  }

  Future<Character?> getCharacterById(String id) async {
    final characters = await loadCharacters();
    try {
      return characters.firstWhere((char) => char.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Character>> searchCharacters(String keyword) async {
    final characters = await loadCharacters();
    if (keyword.isEmpty) {
      return characters;
    }
    return characters
        .where(
          (char) =>
              char.name.contains(keyword) ||
              char.description.contains(keyword) ||
              char.tags.any((tag) => tag.contains(keyword)),
        )
        .toList();
  }
}
