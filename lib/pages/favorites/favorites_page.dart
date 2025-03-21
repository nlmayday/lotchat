import 'package:flutter/material.dart';
import 'package:sky/models/character.dart'; // 假设有 Character 模型
import 'package:sky/widgets/common_bottom_nav.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  int _currentIndex = 1; // 收藏页面索引为 1
  final bool _isLoading = true;
  bool selected = false;

  // 模拟收藏数据
  List<Character> _getMockFavorites() {
    return [
      Character(
        id: '1',
        name: '赛博朋克女孩',
        description: '未来科技风格的虚拟伙伴',
        avatar: 'assets/images/nv1.png',
        backgroundImage: 'assets/images/nv1.png',
        tags: ['科技'],
        price: 500,
        category: '科技',
      ),
      Character(
        id: '2',
        name: '机械天使',
        description: '科技与艺术的完美融合',
        avatar: 'assets/images/nv1.png',
        backgroundImage: 'assets/images/nv1.png',
        tags: ['艺术'],
        price: 450,
        category: '艺术',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80.0), // 防止底部溢出
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
                      '我的收藏',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // 筛选选项卡
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('全部'),
                      selected: true,
                      onSelected: (selected) {},
                      selectedColor: Colors.yellow[200],
                      backgroundColor: Colors.white.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: selected ? Colors.black : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('最近'),
                      selected: false,
                      onSelected: (selected) {},
                      selectedColor: Colors.yellow[200],
                      backgroundColor: Colors.white.withOpacity(0.1),
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('热门'),
                      selected: false,
                      onSelected: (selected) {},
                      selectedColor: Colors.yellow[200],
                      backgroundColor: Colors.white.withOpacity(0.1),
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              // 收藏列表
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _getMockFavorites().length,
                  itemBuilder: (context, index) {
                    final character = _getMockFavorites()[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white.withOpacity(0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.asset(
                              character.backgroundImage,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  character.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  character.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.favorite,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '2.8k',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.monetization_on,
                                          size: 14,
                                          color: Colors.yellow,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${character.price}',
                                          style: const TextStyle(
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
      ),
      bottomNavigationBar: CommonBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
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
}
