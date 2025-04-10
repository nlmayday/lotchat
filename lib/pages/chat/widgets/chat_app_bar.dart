import 'package:flutter/material.dart';
import 'package:sky/models/character.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Character character;

  const ChatAppBar({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(character.avatar),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(character.name),
              Text(
                character.category,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // TODO: 实现更多功能菜单
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
