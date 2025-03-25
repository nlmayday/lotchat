import 'package:sky/models/chat.dart';
import '../client/http_client.dart';

class ChatService {
  static Future<List<ChatMessage>> getChatHistory(String characterId) async {
    final response = await HttpClient.get('/chat/history/$characterId');
    return (response as List).map((json) => ChatMessage.fromJson(json)).toList();
  }

  static Future<ChatMessage> sendMessage(
    String characterId,
    String content,
  ) async {
    final response = await HttpClient.post(
      '/chat/send',
      body: {
        'characterId': characterId,
        'content': content,
      },
    );
    return ChatMessage.fromJson(response);
  }

  static Future<void> deleteMessage(String messageId) async {
    await HttpClient.post('/chat/delete/$messageId');
  }

  static Future<void> clearHistory(String characterId) async {
    await HttpClient.post('/chat/clear/$characterId');
  }
}