import 'package:shared_preferences/shared_preferences.dart'; // Fix the import path

class SearchHistoryManager {
  static const String _key = 'search_history';
  static const int _maxHistoryCount = 10;

  static Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> addSearchHistory(String keyword) async {
    if (keyword.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    var history = prefs.getStringList(_key) ?? [];

    // 移除已存在的相同关键词
    history.remove(keyword);
    // 添加到开头
    history.insert(0, keyword);
    // 保持最大数量为10
    if (history.length > _maxHistoryCount) {
      history = history.sublist(0, _maxHistoryCount);
    }

    await prefs.setStringList(_key, history);
  }

  static Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
