import 'package:flutter/material.dart';
import 'package:sky/api/services/character_service.dart';
import 'package:sky/models/character.dart';
import 'package:sky/pages/chat/widgets/chat_app_bar.dart';
import 'package:sky/pages/chat/widgets/chat_input.dart';
import 'package:sky/pages/chat/widgets/chat_messages.dart';
import 'package:sky/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? backgroundImage;
  final String? avatar;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.backgroundImage,
    this.avatar,
  });
}

class ChatPage extends StatefulWidget {
  final String characterId;
  const ChatPage({super.key, required this.characterId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future<Character> _characterFuture;
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String? _currentBackground;

  @override
  void initState() {
    super.initState();
    _characterFuture = _loadCharacter();
  }

  Future<Character> _loadCharacter() async {
    final character = await CharacterService.getCharacterById(
      widget.characterId,
    );
    if (character == null) {
      throw Exception('Character not found for ID: ${widget.characterId}');
    }
    _loadInitialMessage(character);
    return character;
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

  Future<void> _handleSendMessage(String text, Character character) async {
    if (text.trim().isEmpty) return;

    // 获取用户信息
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print('UserProvider: ${userProvider.toString()}');
    print('Current User Data: ${userProvider.user}');
    print('User ID: ${userProvider.user?.id}');

    // 获取用户头像
    final userAvatar =
        userProvider.user?.avatar ?? 'assets/images/avatar_default.png';
    print('User Avatar Path: $userAvatar'); // 添加这行来查看实际的头像路径

    final userMessage = ChatMessage(
      id: DateTime.now().toString(),
      content: text,
      timestamp: DateTime.now(),
      isUser: true,
      backgroundImage: character.backgroundImage,
      avatar: userAvatar,
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    // 模拟AI思考和打字时间
    await Future.delayed(const Duration(seconds: 1));

    // 获取AI回复
    final reply = await CharacterService.getChatReply(widget.characterId, text);

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            id: DateTime.now().toString(),
            content: reply,
            timestamp: DateTime.now(),
            isUser: false,
            backgroundImage: character.backgroundImage,
            avatar: character.avatar,
          ),
        );
      });
    }
  }

  Widget _buildTypingIndicator(Character character) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end, // 改为底部对齐
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(character.avatar),
            radius: 16,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              // 使用Column布局
              children: [
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (index) => Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: FutureBuilder<Character>(
        future: _characterFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
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
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length + (_isTyping ? 1 : 0),
                      reverse: true,
                      itemBuilder: (context, index) {
                        if (index == 0 && _isTyping) {
                          return _buildTypingIndicator(character);
                        }
                        final messageIndex = _isTyping ? index - 1 : index;
                        return ChatMessages(
                          messages: [_messages[messageIndex]],
                        );
                      },
                    ),
                  ),
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
