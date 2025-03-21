import 'package:flutter/material.dart';
import 'package:sky/models/character.dart';
import 'package:sky/models/chat.dart';
import 'package:sky/pages/chat/widgets/chat_app_bar.dart';
import 'package:sky/pages/chat/widgets/chat_input.dart';
import 'package:sky/pages/chat/widgets/chat_messages.dart';
import 'package:sky/api/api_client.dart'; // 导入 ApiClient
import 'dart:developer' as developer; // 导入 dart:developer

class ChatPage extends StatefulWidget {
  final String characterId;

  const ChatPage({super.key, required this.characterId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future<Character> _characterFuture;
  final List<ChatMessage> _messages = [];
  String? _currentBackground;

  @override
  void initState() {
    super.initState();
    // 异步加载角色数据，并确保非空
    _characterFuture = ApiClient.getCharacterById(widget.characterId).then((
      character,
    ) {
      if (character == null) {
        // 使用 dart:developer 的 log 函数记录日志
        developer.log('Character not found for ID: ${widget.characterId}');
        throw Exception('Character not found for ID: ${widget.characterId}');
      }
      // 角色数据加载成功后调用 _loadInitialMessage
      _loadInitialMessage(character);
      return character;
    });
  }

  void _loadInitialMessage(Character character) {
    final welcome = ChatMessage(
      id: DateTime.now().toString(),
      content: '嗨！很高兴见到你。我是${character.name}，让我们开始探索吧！',
      timestamp: DateTime.now(),
      isUser: false,
      backgroundImage: character.backgroundImage,
      avatar: character.avatar,
    );
    setState(() => _messages.add(welcome));
  }

  void _handleSendMessage(String text, Character character) {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().toString(),
      content: text,
      timestamp: DateTime.now(),
      isUser: true,
      backgroundImage: character.backgroundImage,
      avatar: character.avatar,
    );

    setState(() => _messages.add(userMessage));
    // TODO: 发送消息到服务器并获取回复
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Character>(
        future: _characterFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 加载中...
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 错误处理
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            // 没有数据
            return const Center(child: Text('No character data available.'));
          }

          final character = snapshot.data!;
          _currentBackground ??= character.backgroundImage;

          return Container(
            decoration: BoxDecoration(
              image:
                  _currentBackground != null
                      ? DecorationImage(
                        image: AssetImage(_currentBackground!),
                        fit: BoxFit.cover,
                        opacity: 0.2,
                      )
                      : null,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  ChatAppBar(character: character),
                  Expanded(child: ChatMessages(messages: _messages)),
                  ChatInput(
                    onSendMessage:
                        (text) => _handleSendMessage(text, character),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
