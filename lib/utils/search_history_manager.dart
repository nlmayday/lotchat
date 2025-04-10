import 'package:shared_preferences/shared_preferences.dart'; // Fix the import path

class SearchHistoryManager {
  static const String _key = 'search_history';
  static const int _maxHistoryCount = 20;

  static Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> addSearchHistory(String keyword) async {
    if (keyword.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    List<String> history = await getSearchHistory();

    // 移除重复项
    history.remove(keyword);
    // 添加到开头
    history.insert(0, keyword);
    // 限制数量
    if (history.length > _maxHistoryCount) {
      history = history.sublist(0, _maxHistoryCount);
    }

    await prefs.setStringList(_key, history);
  }

  static Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, []); // 修改这里，使用 setStringList 而不是 remove
  }
}
