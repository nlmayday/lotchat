import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;

  const ChatInput({super.key, required this.onSendMessage});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _canSend = _controller.text.trim().isNotEmpty;
      });
    });
  }

  void _handleSubmit() {
    if (!_canSend) return;
    widget.onSendMessage(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // TODO: 实现添加更多功能
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '发送消息...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: 4,
              minLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.send,
              color: _canSend ? Theme.of(context).primaryColor : Colors.grey,
            ),
            onPressed: _canSend ? _handleSubmit : null,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
