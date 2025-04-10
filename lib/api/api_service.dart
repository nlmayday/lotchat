import 'dart:async';
import 'package:sky/models/character.dart';
import 'package:sky/api/mock/mock_data.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // 模拟网络延迟
  Future<T> _mockDelay<T>(T data) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return data;
  }

  // 获取角色列表
  Future<List<Character>> getCharacters({String? category}) async {
    final characters = await _mockDelay(MockData.characters);
    if (category == null || category == '推荐') {
      return characters;
    }
    return characters.where((char) => char.category == category).toList();
  }

  // 获取角色详情
  Future<Character?> getCharacterById(String id) async {
    final characters = await _mockDelay(MockData.characters);
    try {
      return characters.firstWhere((char) => char.id == id);
    } catch (e) {
      return null;
    }
  }

  // 搜索角色
  Future<List<Character>> searchCharacters(String keyword) async {
    final characters = await _mockDelay(MockData.characters);
    if (keyword.isEmpty) {
      return characters;
    }
    return characters.where((char) =>
        char.name.contains(keyword) ||
        char.description.contains(keyword) ||
        char.tags.any((tag) => tag.contains(keyword))).toList();
  }

  // 获取聊天回复
  Future<String> getChatReply(String characterId, String message) async {
    return _mockDelay(MockData.getRandomReply());
  }
}