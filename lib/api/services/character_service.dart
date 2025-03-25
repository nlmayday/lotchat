import 'package:sky/models/character.dart';
import '../client/http_client.dart';

class CharacterService {
  // 模拟数据
  static final List<Character> _mockCharacters = [
    Character(
      id: '1',
      name: '角色1',
      description: '这是一个示例角色1。',
      avatar: 'assets/images/nv1.png',
      backgroundImage: 'assets/images/nv1-banner.png',
      tags: ['示例', '角色1'],
      price: 5,
      category: '示例',
    ),
    Character(
      id: '2',
      name: '角色2',
      description: '这是一个示例角色2。',
      avatar: 'assets/images/nv2.png',
      backgroundImage: 'assets/images/nv1-banner.png',
      tags: ['示例', '角色2'],
      price: 10,
      category: '示例',
    ),
    Character(
      id: '3',
      name: '另一个他',
      description: '来自2077年的AI助手，精通未来科技与赛博文化。',
      avatar: 'assets/images/nv3.png',
      backgroundImage: 'assets/images/nv1-banner.png',
      tags: ['未来科技', '赛博朋克'],
      price: 10,
      category: '科技',
    ),
  ];

  static Future<List<Character>> getCharacterList({
    int offset = 0,
    int pageSize = 10,
    Map<String, dynamic>? searchParams,
  }) async {
    // final response = await HttpClient.get(
    //   '/characters?offset=$offset&pageSize=$pageSize&search=${searchParams?['searchTerm'] ?? ''}',
    // );
    // return (response as List).map((json) => Character.fromJson(json)).toList();

    // 模拟搜索参数
    // 模拟搜索参数
    List<Character> filteredCharacters = _mockCharacters;
    if (searchParams != null) {
      final searchTerm = searchParams['searchTerm'] as String?;
      if (searchTerm != null && searchTerm.isNotEmpty) {
        filteredCharacters =
            filteredCharacters
                .where(
                  (character) =>
                      character.name.toLowerCase().contains(
                        searchTerm.toLowerCase(),
                      ) ||
                      character.description.toLowerCase().contains(
                        searchTerm.toLowerCase(),
                      ),
                )
                .toList();
      }
    }

    // 分页
    final List<Character> paginatedCharacters =
        filteredCharacters.skip(offset).take(pageSize).toList();

    return paginatedCharacters;
  }

  static Future<Character> getCharacterById(String id) async {
    // final response = await HttpClient.get('/characters/$id');
    // return Character.fromJson(response);

     final character = _mockCharacters.firstWhere(
      (character) => character.id == id,
    );

    if (character != null) {
      return character;
    } else {
      throw Exception('Failed to load character with id $id: 404');
    }
  }
}
