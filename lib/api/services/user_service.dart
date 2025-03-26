import 'package:sky/models/user.dart';
import '../client/http_client.dart';
import 'package:dio/dio.dart';

class UserService {
  static Future<User> updateProfile({
    required String username,
    required String email,
    String? avatar,
  }) async {
    // TODO: 实现真实的API调用
    // final response = await HttpClient.post('/user/profile', body: {
    //   'username': username,
    //   'email': email,
    //   if (avatar != null) 'avatar': avatar,
    // });
    // return User.fromJson(response);

    return User(
      id: '1',
      username: username,
      email: email,
      avatar: avatar ?? 'assets/images/avator1.png',
      token: 'dummy_token',
      coins: 10000,
    );
  }

  static Future<User> updateAvatar(String avatarPath) async {
    // TODO: 实现真实的API调用
    // final formData = FormData.fromMap({
    //   'avatar': await MultipartFile.fromFile(avatarPath),
    // });
    // final response = await HttpClient.post('/user/avatar', body: formData);
    // return User.fromJson(response);

    return User(
      id: '1',
      username: '测试用户',
      email: 'test@example.com',
      avatar: avatarPath,
      token: 'dummy_token',
      coins: 10000,
    );
  }

  static Future<User> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    // TODO: 实现真实的API调用
    // final response = await HttpClient.post('/user/password', body: {
    //   'old_password': oldPassword,
    //   'new_password': newPassword,
    // });
    // return User.fromJson(response);

    return User(
      id: '1',
      username: '测试用户',
      email: 'test@example.com',
      avatar: 'assets/images/avator1.png',
      token: 'dummy_token',
      coins: 10000,
    );
  }
}