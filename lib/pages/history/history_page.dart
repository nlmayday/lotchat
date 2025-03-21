import 'package:flutter/material.dart';
import 'package:sky/widgets/common_bottom_nav.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _currentIndex = 2; // 历史页面索引为 2

  // 模拟历史数据
  List<Map<String, dynamic>> _getMockHistory() {
    return [
      {
        'name': '赛博朋克女孩',
        'avatar': 'assets/images/nv1.png',
        'time': '2024-01-20 14:30',
        'preview': '今天我们聊了很多关于未来科技的话题，包括人工智能、虚拟现实等领域的发展。这些技术将如何改变我们的生活？',
        'duration': '30分钟',
        'messages': 24,
      },
      {
        'name': '机械天使',
        'avatar': 'assets/images/nv1.png',
        'time': '2024-01-19 18:45',
        'preview': '探讨了艺术与科技的融合，以及如何在数字时代保持人文关怀。艺术创作在未来会有什么新的可能性？',
        'duration': '45分钟',
        'messages': 36,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 头部：返回按钮和标题
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    '对话历史',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // 筛选选项卡
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  ChoiceChip(label: Text('全部'), selected: true),
                  SizedBox(width: 10),
                  ChoiceChip(label: Text('今天'), selected: false),
                  SizedBox(width: 10),
                  ChoiceChip(label: Text('本周'), selected: false),
                  SizedBox(width: 10),
                  ChoiceChip(label: Text('本月'), selected: false),
                  SizedBox(width: 10),
                  ChoiceChip(label: Text('更早'), selected: false),
                ],
              ),
            ),
            // 历史列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _getMockHistory().length,
                itemBuilder: (context, index) {
                  final history = _getMockHistory()[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white.withOpacity(0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 头部：头像和角色信息
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(history['avatar']),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      history['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      history['time'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 对话预览
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            history['preview'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        // 底部：统计和继续对话
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '对话时长: ${history['duration']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    '消息数: ${history['messages']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: 继续对话逻辑
                                },
                                child: const Text(
                                  '继续对话',
                                  style: TextStyle(color: Colors.yellow),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          // TODO: 添加页面导航逻辑
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/favorites');
              break;
            case 2:
              // 当前页面，无需跳转
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
