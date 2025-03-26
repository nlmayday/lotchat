import 'package:sky/models/user.dart';
import '../client/http_client.dart';

class AuthService {
  static Future<User> login(String email, String password) async {
    // final response = await HttpClient.post('/auth/login', body: {
    //   'email': email,
    //   'password': password,
    // });
    // return User.fromJson(response);

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
    // final response = await HttpClient.post('/auth/register', body: {
    //   'username': username,
    //   'email': email,
    //   'password': password,
    // });
    // return User.fromJson(response);

     return User(
      id: '2',
      username: username,
      email: email,
      avatar: 'assets/images/avtor1.png',
      token: 'dummy_token',
      coins: 10000,
    );
  }

  static Future<void> logout() async {
    try {
      // await HttpClient.post('/auth/logout');
      HttpClient.setToken(''); // 确保清除 token
    } catch (e) {
      // 即使请求失败也要清除本ß地 token
      HttpClient.setToken('');
      rethrow;
    }
  }

  static Future<User> updateAvatar(String userId, String avatarPath) async {
    // TODO: 实现真实的API调用
    // final response = await HttpClient.post('/user/avatar', body: {
    //   'userId': userId,
    //   'avatarPath': avatarPath,
    // });
    // return User.fromJson(response);
    
    return User(
      id: userId,
      username: '测试用户',
      email: 'test@example.com',
      avatar: avatarPath,
      token: 'dummy_token',
      coins: 10000,
    );
  }

  static Future<User> updatePassword(
    String userId,
    String oldPassword,
    String newPassword,
  ) async {
    // TODO: 实现真实的API调用
    // final response = await HttpClient.post('/user/password', body: {
    //   'userId': userId,
    //   'oldPassword': oldPassword,
    //   'newPassword': newPassword,
    // });
    // return User.fromJson(response);
    
    return User(
      id: userId,
      username: '测试用户',
      email: 'test@example.com',
      avatar: 'assets/images/avtor1.png',
      token: 'dummy_token',
      coins: 10000,
    );
  }
}