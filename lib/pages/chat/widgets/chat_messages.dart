import 'package:flutter/material.dart';
import 'package:sky/pages/chat/chat_page.dart';

class ChatMessages extends StatelessWidget {
  final List<ChatMessage> messages;

  const ChatMessages({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          messages.map((message) => _buildMessage(context, message)).toList(),
    );
  }

  Widget _buildMessage(BuildContext context, ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser) ...[
              CircleAvatar(
                backgroundImage: AssetImage(message.avatar!),
                radius: 16,
              ),
              const SizedBox(width: 8),
            ],
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color:
                    message.isUser
                        ? const Color(0xFFFFD700) // 金黄色背景
                        : const Color(0xFF333333), // 深灰色背景
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: message.isUser ? Colors.black : Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            if (message.isUser) ...[
              const SizedBox(width: 8),
              // 检查 ChatMessages 组件中的头像渲染代码
              CircleAvatar(
                backgroundImage:
                    message.avatar!.startsWith('http')
                        ? NetworkImage(message.avatar!) as ImageProvider
                        : AssetImage(message.avatar!),
                radius: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
