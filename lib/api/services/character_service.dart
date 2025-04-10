import 'package:sky/models/character.dart';
import 'package:sky/api/api_service.dart';
import 'package:sky/api/mock/mock_data.dart';

class CharacterService {
  static final ApiService _api = ApiService();

  static Future<void> init() async {
    await MockData.init();
  }

  static Future<List<Character>> getCharacterListByCategory({
    String category = '推荐',
  }) async {
    return _api.getCharacters(category: category);
  }

  static Future<Character?> getCharacterById(String id) async {
    return _api.getCharacterById(id);
  }

  static Future<List<Character>> searchCharacters(String keyword) async {
    return _api.searchCharacters(keyword);
  }

  static Future<String> getChatReply(String characterId, String message) async {
    return _api.getChatReply(characterId, message);
  }
}
