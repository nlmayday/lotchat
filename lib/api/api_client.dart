import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sky/models/character.dart';
import 'package:collection/collection.dart';
import 'dart:convert';
import 'package:sky/models/user.dart';

class ApiClient {
  // static const String _baseUrl = 'https://api.example.com'; // 替换为实际的API基础URL

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

  // 获取角色列表
  static Future<List<Character>> getCharacterList({
    int offset = 0,
    int pageSize = 10,
    Map<String, dynamic>? searchParams,
  }) async {
    // 模拟延迟
    await Future.delayed(Duration(seconds: 1));

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

  static Future<Character?> getCharacterById(String id) async {
    // 模拟延迟
    await Future.delayed(Duration(seconds: 1));

    final character = _mockCharacters.firstWhereOrNull(
      (character) => character.id == id,
    );

    if (character != null) {
      return character;
    } else {
      throw Exception('Failed to load character with id $id: 404');
    }
  }

  static const String baseUrl = 'http://your-api-base-url';

  static Future<User> login(String email, String password) async {
    // final response = await http.post(
    //   Uri.parse('$baseUrl/login'),
    //   body: json.encode({'email': email, 'password': password}),
    //   headers: {'Content-Type': 'application/json'},
    // );

    // if (response.statusCode == 200) {
    //   return User.fromJson(json.decode(response.body));
    // } else {
    //   throw Exception('登录失败: ${response.body}');
    // }
    // 模拟登陆成功
    return User(
      id: '1',
      username: '测试用户',
      email: 'test@example.com',
      avatar: 'assets/images/avtor1.png',
      token: 'dummy_token',
      coins: 10000,
    );
  }

  static Future<User> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('注册失败: ${response.body}');
    }
  }
}
