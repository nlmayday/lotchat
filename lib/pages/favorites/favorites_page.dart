import 'package:flutter/material.dart';
import 'package:sky/models/character.dart';
import 'package:sky/data/character_data_manager.dart';
import 'package:sky/pages/home/widgets/character_grid.dart';
import 'package:sky/widgets/common_bottom_nav.dart'; // 添加这行

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final CharacterDataManager _dataManager = CharacterDataManager();
  List<Character> _characters = [];
  bool _isLoading = true;
  int _currentIndex = 1; // 添加这行，表示当前是收藏页

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: 这里应该从本地存储或服务器获取收藏列表
    // 暂时模拟一些数据
    final allCharacters = await _dataManager.loadCharacters();
    final favorites = allCharacters.take(5).toList(); // 模拟5个收藏

    setState(() {
      _characters = favorites;
      _isLoading = false;
    });
  }

  void _onCharacterTap(String id) {
    Navigator.pushNamed(context, '/chat', arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题
                      const Row(
                        children: [
                          Text(
                            '我的收藏',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 用户等级卡片
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '当前等级',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Lv.15',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: FractionallySizedBox(
                                widthFactor: 0.75,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '已解锁角色: 12/20',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  '距离下一级: 300经验',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 筛选标签
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            _buildFilterTab('全部', true),
                            const SizedBox(width: 10),
                            _buildFilterTab('最近', false),
                            const SizedBox(width: 10),
                            _buildFilterTab('热门', false),
                          ],
                        ),
                      ),

                      // 角色网格
                      _characters.isEmpty
                          ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: Text(
                                '暂无收藏的角色',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                          : CharacterGrid(
                            characters: _characters,
                            onCharacterTap: _onCharacterTap,
                          ),

                      // 加载更多
                      if (_characters.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 70),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '加载更多 ↓',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
      ),
      bottomNavigationBar: CommonBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              // 当前页面，无需跳转
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

  Widget _buildFilterTab(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color:
            isActive
                ? Theme.of(context).primaryColor
                : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: isActive ? Colors.black : Colors.white),
      ),
    );
  }
}
