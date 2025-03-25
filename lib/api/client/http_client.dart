import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpClient {
  static const String baseUrl = 'http://your-api-base-url';
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  static void setToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }

  static Future<dynamic> get(String path) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  static Future<dynamic> post(String path, {dynamic body}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('请求失败: ${response.body}');
    }
  }
}