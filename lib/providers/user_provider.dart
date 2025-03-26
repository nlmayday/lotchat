import 'package:flutter/foundation.dart';
// 需要先运行 flutter pub add shared_preferences 添加依赖
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky/models/user.dart';
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = true;
  static final UserProvider _instance = UserProvider._internal();
  static SharedPreferences? _prefs;

  factory UserProvider() {
    return _instance;
  }

  UserProvider._internal();

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  User? get user => _user;

  Future<void> loadUser() async {
    if (_prefs == null) {
      await initialize();
    }

    _isLoading = true;
    notifyListeners();

    try {
      final userJson = _prefs?.getString('user_data');
      if (userJson != null) {
        _user = User.fromJson(json.decode(userJson));
      }
    } catch (e) {
      await _prefs?.remove('user_data');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUser(User user) async {
    if (_prefs == null) {
      await initialize();
    }
    
    _user = user;
    await _prefs?.setString('user_data', json.encode(user.toJson()));
    notifyListeners();
  }

  Future<void> clearUser() async {
    if (_prefs == null) {
      await initialize();
    }
    
    _user = null;
    await _prefs?.remove('user_data');
    notifyListeners();
  }
}
