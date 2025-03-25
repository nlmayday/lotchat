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
    final response = await HttpClient.post('/auth/register', body: {
      'username': username,
      'email': email,
      'password': password,
    });
    return User.fromJson(response);
  }
}