import 'dart:convert';
import 'dart:io';

void main() {
  final categories = ['治愈', '知识', '热门', '闲聊'];
  final List<Map<String, dynamic>> characters = [];
  final tags = {
    '治愈': ['情感', '倾听', '安慰', '陪伴'],
    '知识': ['学习', '科技', '历史', '文化'],
    '热门': ['趣味', '娱乐', '游戏', '音乐'],
    '闲聊': ['日常', '搞笑', '八卦', '生活'],
  };
  final names = ['小冰', '小美', '小智', '小萌', '小乐', '小晴', '小雨', '小风', '小云', '小月'];

  for (int i = 1; i <= 100; i++) {
    final category = categories[i % categories.length];
    final name = '${names[i % names.length]}${(i / names.length).floor() + 1}';
    final avatarIndex = (i % 4) + 1;

    characters.add({
      'id': i.toString(),
      'name': name,
      'description':
          '这是一个${tags[category]![i % 4]}的AI助手，擅长${category}类话题，能够为你提供专业的${tags[category]![(i + 1) % 4]}服务。',
      'avatar': 'assets/images/nv$avatarIndex.png',
      'backgroundImage': 'assets/images/nv$avatarIndex-banner.png',
      'tags': [category, ...tags[category]!.take(2)],
      'price': (i % 20) * 5,
      'category': category,
      'chatCount': 10000 + (i * 123),
      'rating': 4.0 + (i % 10) / 10,
    });
  }

  final json = JsonEncoder.withIndent('  ').convert({'characters': characters});
  File(
    '/Users/jarvis/work/tools/sky/lib/data/characters.json',
  ).writeAsStringSync(json);
}
