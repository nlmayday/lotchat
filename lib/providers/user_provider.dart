import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  // 从本地存储加载用户信息
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        _user = User.fromJson(
          Map<String, dynamic>.from(Map<String, dynamic>.from(userJson as Map)),
        );
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // 保存用户信息到本地存储
  Future<void> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', user.toJson().toString());
      _user = user;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving user: $e');
    }
  }

  // 清除用户信息（登出）
  Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      _user = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing user: $e');
    }
  }
}
