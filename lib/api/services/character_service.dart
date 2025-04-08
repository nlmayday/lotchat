import 'package:sky/models/character.dart';
import '../client/http_client.dart';

class CharacterService {
  // 模拟数据
  static List<Character> _generateMockCharacters() {
    final categories = ['治愈', '知识', '热门', '闲聊'];
    final List<Character> characters = [];

    for (int i = 1; i <= 100; i++) {
      final category = categories[i % categories.length];
      characters.add(
        Character(
          id: i.toString(),
          name: '角色$i',
          description: '这是第$i个AI助手，属于$category分类。',
          avatar: 'assets/images/nv${(i % 4) + 1}.png',
          backgroundImage: 'assets/images/nv1-banner.png',
          tags: [category, '标签$i'],
          price: (i % 20) * 5,
          category: category,
        ),
      );
    }
    return characters;
  }

  static final List<Character> _mockCharacters = _generateMockCharacters();

  // 按分类获取角色列表
  static Future<List<Character>> getCharacterListByCategory({
    String category = '推荐',
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (category == '推荐') {
      return _mockCharacters;
    }

    return _mockCharacters.where((char) => char.category == category).toList();
  }

  // 根据ID获取角色详情
  static Future<Character?> getCharacterById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockCharacters.firstWhere((char) => char.id == id);
    } catch (e) {
      return null;
    }
  }

  // 获取热门角色
  static Future<List<Character>> getHotCharacters() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCharacters.where((char) => char.category == '热门').toList();
  }

  // 获取推荐角色
  static Future<List<Character>> getRecommendedCharacters() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCharacters.take(2).toList();
  }

  // 搜索角色
  static Future<List<Character>> searchCharacters(String keyword) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockCharacters
        .where(
          (char) =>
              char.name.contains(keyword) ||
              char.description.contains(keyword) ||
              char.tags.any((tag) => tag.contains(keyword)),
        )
        .toList();
  }

  // 获取角色列表（带分页和搜索参数）
  static Future<Map<String, dynamic>> getCharacterList({
    int page = 1,
    int pageSize = 10,
    Map<String, dynamic>? searchParams,
    String sortField = 'id',
    bool ascending = true,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    var filteredList = List<Character>.from(_mockCharacters);

    // 应用搜索条件
    if (searchParams != null) {
      if (searchParams['category'] != null) {
        filteredList =
            filteredList
                .where((char) => char.category == searchParams['category'])
                .toList();
      }
      if (searchParams['keyword'] != null) {
        final keyword = searchParams['keyword'].toString().toLowerCase();
        filteredList =
            filteredList
                .where(
                  (char) =>
                      char.name.toLowerCase().contains(keyword) ||
                      char.description.toLowerCase().contains(keyword) ||
                      char.tags.any(
                        (tag) => tag.toLowerCase().contains(keyword),
                      ),
                )
                .toList();
      }
      if (searchParams['priceRange'] != null) {
        final maxPrice = searchParams['priceRange']['max'];
        final minPrice = searchParams['priceRange']['min'];
        if (maxPrice != null) {
          filteredList =
              filteredList.where((char) => char.price <= maxPrice).toList();
        }
        if (minPrice != null) {
          filteredList =
              filteredList.where((char) => char.price >= minPrice).toList();
        }
      }
    }

    // 排序
    filteredList.sort((a, b) {
      dynamic valueA = a.toJson()[sortField];
      dynamic valueB = b.toJson()[sortField];
      return ascending
          ? Comparable.compare(valueA, valueB)
          : Comparable.compare(valueB, valueA);
    });

    // 计算分页
    final total = filteredList.length;
    final start = (page - 1) * pageSize;
    final end = start + pageSize;

    // 获取当前页数据
    final currentPageData = filteredList.sublist(
      start.clamp(0, total),
      end.clamp(0, total),
    );

    return {
      'total': total,
      'currentPage': page,
      'pageSize': pageSize,
      'data': currentPageData,
    };
  }
}
