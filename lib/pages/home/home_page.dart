import 'package:flutter/material.dart';
import 'package:sky/models/character.dart';
import 'package:sky/pages/home/widgets/character_grid.dart';
import 'package:sky/pages/home/widgets/category_tabs.dart';
import 'package:sky/pages/home/widgets/search_bar.dart';
import 'package:sky/widgets/common_bottom_nav.dart';
import 'package:sky/api/api_client.dart'; // 导入 ApiClient

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // 首页索引为 0
  late Future<List<Character>> _characterListFuture;

  @override
  void initState() {
    super.initState();
    // 初始化角色列表数据
    _characterListFuture = ApiClient.getCharacterList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: HomeSearchBar(),
            ),
            const CategoryTabs(),
            Expanded(
              child: FutureBuilder<List<Character>>(
                future: _characterListFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // 加载中...
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // 错误处理
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // 没有数据
                    return const Center(
                      child: Text('No characters available.'),
                    );
                  }
                  // 展示角色网格
                  return CharacterGrid(
                    characters: snapshot.data!,
                    onCharacterTap: _onCharacterTap,
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
          switch (index) {
            case 0:
              // 当前页面，无需跳转
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/favorites');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/history');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  void _onCharacterTap(String characterId) {
    Navigator.pushNamed(context, '/chat', arguments: {'characterId': '3'});
  }
}
